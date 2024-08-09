import 'package:crypto_app/data_model/crypto_data_model.dart';
import 'package:crypto_app/home_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  void getData() async {
    var dio = Dio();
    var response;
    do {
      response = await dio.get('https://api.coincap.io/v2/assets');
    } while (response.statusCode != 200);

    List<CryptoData> coinData = response.data['data']
        .map<CryptoData>((jsonMap) => CryptoData.fromJson(jsonMap))
        .toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          coinList: coinData,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/images/logo.png')),
          SpinKitWave(
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
    );
  }
}
