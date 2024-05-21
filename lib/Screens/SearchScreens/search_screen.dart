import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BeatNow/Controllers/auth_controller.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> _searchHistory = [];
  final AuthController _authController = Get.find<AuthController>();
  bool _searchingUsers = false; // Variable para controlar qué se está buscando
  List<String> _selectedInstruments = [];

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
            ? null // Si se está buscando usuarios, no mostrar acciones
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
                      _searchingUsers = false; // Cambiar a búsqueda de beats
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
                      _searchingUsers = true; // Cambiar a búsqueda de usuarios
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
            Text(
              'Search History',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            _buildSearchHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHistory() {
    return Column(
      children: _searchHistory.map((term) => _buildHistoryItem(term)).toList(),
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
    });
  }

  void _addToSearchHistory(String term) {
    setState(() {
      if (!_searchHistory.contains(term)) {
        _searchHistory.insert(0, term);
      }
    });
  }

void _showFilterPopup(BuildContext context) {
  String selectedGenre = 'Rock';
  double selectedPrice = 0.00;
  int selectedBpm = 120;
  String selectedInstrument =
      'Guitar'; // Variable para almacenar el instrumento seleccionado

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
  ]; // Lista de instrumentos

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
                  // Menú desplegable para instrumentos
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
                  // Aquí puedes añadir lógica para aplicar los filtros
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF4E0566))
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
}
