import 'dart:convert';

import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart';


class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = "USD";
  String value="?";
  Future<void> getCoinVal() async{
    Response val = await get(Uri.parse('https://rest.coinapi.io/v1/exchangerate/BTC/$selectedCurrency?apikey=B7242533-DFD2-4907-883C-330565F5C964'));
    setState(() {
      value=jsonDecode(val.body)['rate'].toStringAsFixed(2);
    });
  }
  Widget getPicker(){
    if(Platform.isAndroid){
      return androidPicker();
    }
    else{
      return iosPicker();
    }
  }
  DropdownButton<String> androidPicker() {
    List<DropdownMenuItem<String>> l = [];
    for (var i in currenciesList) {
      l.add(DropdownMenuItem(
        child: Text('$i'),
        value: i,
      ));
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: l,
      onChanged: (value) {
        setState(() {
          getCoinVal();
          selectedCurrency = value;
        });
      },
    );
  }

  CupertinoPicker iosPicker(){
    List<Widget> l = [];
    for (String item in currenciesList) {
      l.add(Text(item));
    }
    return CupertinoPicker(
        itemExtent: 32,
        onSelectedItemChanged: (selectedIndex) {
          print(selectedIndex);
        },
        children: l);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $value $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: getPicker(),
          )],
      ),
    );
  }
}
