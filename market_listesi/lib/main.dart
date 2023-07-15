import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(OrtakMarketListesiApp());
}

class OrtakMarketListesiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ortak Market Listesi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MarketListesiEkran(),
    );
  }
}

class MarketListesiEkran extends StatefulWidget {
  @override
  _MarketListesiEkranState createState() => _MarketListesiEkranState();
}

class _MarketListesiEkranState extends State<MarketListesiEkran> {
  List<String> ortakListe = [];
  List<String> eskiOneriler = ['Elma', 'Portakal', 'Ekmek'];

  @override
  void initState() {
    super.initState();
    loadList();
  }

  void loadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      ortakListe = prefs.getStringList('shoppingList') ?? [];
    });
  }

  void saveList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('shoppingList', ortakListe);
  }

  @override
  void dispose() {
    saveList();
    super.dispose();
  }

  void ekleEsinlenenlerle(String esya) {
    setState(() {
      ortakListe.add(esya);
    });
  }

  void cikar(String esya) {
    setState(() {
      ortakListe.remove(esya);
    });
  }

  void esyaSatinAlindi(String esya) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Satın Alındı'),
          content: Text('$esya satın alındı!'),
          actions: [
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    cikar(esya);
  }

  void oneriYap() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String yeniOneri = '';
        return AlertDialog(
          title: Text('Yeni Öneri'),
          content: TextField(
            onChanged: (value) {
              yeniOneri = value;
            },
          ),
          actions: [
            TextButton(
              child: Text('Öner'),
              onPressed: () {
                if (yeniOneri.isNotEmpty) {
                  setState(() {
                    eskiOneriler.add(yeniOneri);
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Yeni öneri eklendi: $yeniOneri'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void clearList() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear All Items'),
          content: Text('Are you sure you want to clear the list?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Clear'),
              onPressed: () {
                setState(() {
                  ortakListe.clear();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showErrorMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Please enter an item name.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ortak Market Listesi'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box),
            onPressed: oneriYap,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: clearList,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: ortakListe.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(ortakListe[index]),
            trailing: IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                esyaSatinAlindi(ortakListe[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String yeniEsyaAdi = '';
              return AlertDialog(
                title: Text('Yeni Eşya Ekle'),
                content: TextField(
                  onChanged: (value) {
                    yeniEsyaAdi = value;
                  },
                ),
                actions: [
                  TextButton(
                    child: Text('Ekle'),
                    onPressed: () {
                      if (yeniEsyaAdi.isNotEmpty) {
                        ekleEsinlenenlerle(yeniEsyaAdi);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Yeni eşya eklendi: $yeniEsyaAdi'),
                          ),
                        );
                      } else {
                        showErrorMessage();
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
