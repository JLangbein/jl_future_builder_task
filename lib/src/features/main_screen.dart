import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _controller = TextEditingController();
  Future<String>? _futureCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            spacing: 32,
            children: [
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Postleitzahl",
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _futureCity = getCityFromZip(_controller.text);
                  });
                },
                child: const Text("Suche"),
              ),
              FutureBuilder<String>(
                future: _futureCity,
                builder: (context, snapshot) {
                  // still waiting on data
                  if (_futureCity != null &&
                      snapshot.connectionState != ConnectionState.done) {
                    return CircularProgressIndicator();
                  }
                  // something went wrong
                  if (snapshot.hasError) {
                    return Row(
                      spacing: 4.0,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_rounded,
                          color: Colors.red,
                          size: 24.0,
                        ),
                        Text('${snapshot.error}'),
                      ],
                    );
                  }
                  // success
                  if (snapshot.hasData) {
                    return Text(
                      'Ergebnis: ${snapshot.data}',
                      style: Theme.of(context).textTheme.labelLarge,
                    );
                  }
                  // if all else fails
                  return Text(
                    "Ergebnis: Noch keine PLZ gesucht",
                    style: Theme.of(context).textTheme.labelLarge,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> getCityFromZip(String zip) async {
    // simuliere Dauer der Datenbank-Anfrage
    await Future.delayed(const Duration(seconds: 3));

    switch (zip) {
      case "10115":
        return 'Berlin';
      case "20095":
        return 'Hamburg';
      case "80331":
        return 'München';
      case "50667":
        return 'Köln';
      case "60311":
      case "60313":
        return 'Frankfurt am Main';
      default:
        //return 'Unbekannte Stadt';
        throw Exception('Unbekannte Stadt');
    }
  }
}
