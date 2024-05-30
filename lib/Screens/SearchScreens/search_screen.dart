import 'package:BeatNow/Models/OtherUserSingleton.dart';
import 'package:BeatNow/Models/UserSingleton.dart';
import 'package:BeatNow/Screens/ProfileScreen/profileother_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BeatNow/Controllers/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
 
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}
 
class _SearchScreenState extends State<SearchScreen> {
  List<String> _searchHistory = [];
  final AuthController _authController = Get.find<AuthController>();
  bool _searchingUsers = false;
  List<Map<String, dynamic>> _userSearchResults = [];
 
  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }
 
  Future<void> _loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }
 
  Future<void> _saveSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('searchHistory', _searchHistory);
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _authController.changeTab(3);
          },
        ),
        actions: _searchingUsers
            ? null
            : [
                IconButton(
                  icon: Icon(Icons.filter_alt),
                  onPressed: () {
                    _showFilterPopup(context);
                  },
                ),
              ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onSubmitted: (value) {
                _addToSearchHistory(value);
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Searching in: '),
                InkWell(
                  onTap: () {
                    setState(() {
                      _searchingUsers = false;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Beats',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: _searchingUsers ? Colors.grey : Color(0xFF4E0566),
                        fontWeight: _searchingUsers ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _searchingUsers = true;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Users',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: _searchingUsers ? Color(0xFF4E0566) : Colors.grey,
                        fontWeight: _searchingUsers ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            if (_searchingUsers) ...[
              Text(
                'User Search Results',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: _buildUserSearchReadults(),
              ),
              SizedBox(height: 16.0),
              Text(
                'Search History',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: _buildSearchHistory(),
              ),
            ],
          ],
        ),
      ),
    );
  }
 
  Widget _buildSearchHistory() {
    return ListView.builder(
      itemCount: _searchHistory.length,
      itemBuilder: (context, index) {
        return _buildHistoryItem(_searchHistory[index]);
      },
    );
  }
 
  Widget _buildHistoryItem(String term) {
    return ListTile(
      title: Text(term),
      trailing: IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          _removeFromSearchHistory(term);
        },
      ),
    );
  }
 
  void _removeFromSearchHistory(String term) {
    setState(() {
      _searchHistory.remove(term);
      _saveSearchHistory();
    });
  }
 
  void _addToSearchHistory(String term) {
    setState(() {
      if (!_searchHistory.contains(term)) {
        _searchHistory.insert(0, term);
        _saveSearchHistory();
      }
    });
 
    if (_searchingUsers) {
      _searchUsers(term).then((results) {
        setState(() {
          _userSearchResults = results
              .map((user) => {'_id': user['_id'].toString(), 'username': user['username'].toString()})
              .toList();
        });
      }).catchError((error) {
        setState(() {
          _userSearchResults = [];
        });
      });
    }
  }
 
  Widget _buildUserSearchReadults() {
  if (_userSearchResults.isEmpty) {
    return Text('No se han encontrado resultados.');
  }
  return ListView.builder(
    itemCount: _userSearchResults.length,
    itemBuilder: (context, index) {
      final user = _userSearchResults[index];
      return ListTile(
        leading: CircleAvatar(  // Se añade un CircleAvatar como widget leading
          backgroundImage: NetworkImage(
            "http://172.203.251.28/beatnow/" + user['_id']+ "/photo_profile/photo_profile.png"
          ),
          radius: 20, // Tamaño del avatar
        ),
        title: Text('@' + user['username']!),
        onTap: () {
          if (user['_id'] != null && user['username'] != null) {
            OtherUserSingleton().id = user['_id']!;
            OtherUserSingleton().username = user['username']!;
            Get.to(() => ProfileOtherScreen());
          } else {
            // Manejar caso donde user['_id'] o user['username'] es nulo
            print('Usuario no válido: $_userSearchResults');
          }
        },
      );
    },
  );
}
 
  void _showFilterPopup(BuildContext context) {
    String selectedGenre = 'Rock';
    double selectedPrice = 0.00;
    int selectedBpm = 120;
    String selectedInstrument = 'Guitar';
 
    List<String> instruments = [
      'Guitar',
      'Bass',
      'Flute',
      'Drums',
      'Piano',
      'Synth',
      'Vocals',
      'Strings',
      'Brass',
      'Harp'
    ];
 
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Advanced Beat Filters'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Genre:'),
                    DropdownButton<String>(
                      value: selectedGenre,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedGenre = newValue;
                          });
                        }
                      },
                      items: <String>['Trap', 'Hip-Hop', 'Pop', 'Rock', 'Jazz', 'Reggae', 'R&B', 'Country', 'Blues', 'Metal']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16.0),
                    Text('Price: \$${selectedPrice.toStringAsFixed(2)}'),
                    Slider(
                      value: selectedPrice,
                      min: 0,
                      max: 150,
                      divisions: 30,
                      onChanged: (double value) {
                        setState(() {
                          selectedPrice = value;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Text('BPM: '),
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (selectedBpm > 0) {
                                selectedBpm--;
                              }
                            });
                          },
                        ),
                        Text('$selectedBpm'),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              if (selectedBpm < 300) {
                                selectedBpm++;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Text('Instruments:'),
                    DropdownButton<String>(
                      value: selectedInstrument,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedInstrument = newValue;
                          });
                        }
                      },
                      items: instruments
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF4E0566))
                  ),
                  child: Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }
 
  Future<List<dynamic>> _searchUsers(String query) async {
    final token = UserSingleton().token;
    final response = await http.get(
      Uri.parse('http://217.182.70.161:6969/v1/api/search/user?username=$query'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
 
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse is List) {
        return jsonResponse.where((user) => user['_id'] != null && user['username'] != null).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load search results');
    }
  }
  Future<List<dynamic>> _searchFilter(String query) async {
    final token = UserSingleton().token;
    final response = await http.get(
      Uri.parse('http://217.182.70.161:6969/v1/api/search/user?username=$query'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
 
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse is List) {
        return jsonResponse.where((user) => user['_id'] != null && user['username'] != null).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load search results');
    }
  }
}