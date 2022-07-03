import 'package:flutter/material.dart';
import './about.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model.dart';

class HomePage extends StatelessWidget {
  Future<List> getCurrencies() async {
    http.Response res = await http.Client()
        .get(Uri.parse('https://api.coinlore.com/api/tickers/'));
    return json.decode(res.body)['data'];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        elevation: 0.1,
        centerTitle: true,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text("Cryptocurrency"),
        actions: <Widget>[
          Tooltip(
            message: 'About us',
            child: IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => About(ritik)));
              },
            ),
          )
        ],
      ),
      body: Container(
        //color: Colors.green,
        child: FutureBuilder(
          future: getCurrencies(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            if (snapshot.hasError)
              return Center(
                child: Text("error"),
              );
            List data = snapshot.data;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                Coin coin = Coin.fromMap(data[index]);
                return Card(
                  elevation: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                    child: ListTile(
                      title: Text(
                        coin.name,
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        "\$${coin.priceUSD}",
                        style: TextStyle(color: Colors.greenAccent),
                      ),
                      subtitle: //
                          Text(
                        coin.symbol,
                        style: TextStyle(color: Colors.white30),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  static final RG ritik = RG(
    firstName: 'RITIK',
    lastName: 'GARG',
    avatar: 'assets/dp2.jpg',
    backdropPhoto: 'assets/dp.jpg',
    location: 'Muradnagar, Ghaziabad',
  );
}

class Coin {
  String id;
  String name;
  String symbol;
  String priceUSD;
  //double rank ;

  Coin.fromMap(Map data)
      : id = data['id'],
        name = data['name'],
        symbol = data['symbol'],
        priceUSD = data['price_usd'];
}
