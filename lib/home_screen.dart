import 'package:crypto_app/constants/constants.dart';
import 'package:crypto_app/data_model/crypto_data_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final List<CryptoData> coinList;
  HomeScreen({super.key, required this.coinList});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CryptoData>? coinList, copyCoinList;
  List<CryptoData>? coinData;
  @override
  void initState() {
    super.initState();
    coinList = widget.coinList;
    copyCoinList = widget.coinList.toList();
  }

  void getData() async {
    var dio = Dio();
    var response = await dio.get('https://api.coincap.io/v2/assets');
    coinData = response.data['data']
        .map<CryptoData>((jsonMap) => CryptoData.fromJson(jsonMap))
        .toList();
    setState(() {
      coinList = coinData;
    });
  }

  Widget changeMarketPercent(
    double? changePercent24hr,
    double? priceUsd,
  ) {
    if (changePercent24hr!.isNegative) {
      return SizedBox(
        width: 150,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              verticalDirection: VerticalDirection.up,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${changePercent24hr.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: redColor,
                  ),
                ),
                Text(
                  '${priceUsd!.toStringAsFixed(2)}\$',
                  style: TextStyle(
                    color: greyColor,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.trending_down,
              color: redColor,
            ),
          ],
        ),
      );
    }
    return SizedBox(
      width: 150,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            verticalDirection: VerticalDirection.up,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${changePercent24hr.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: greenColor,
                ),
              ),
              Text(
                '${priceUsd!.toStringAsFixed(2)}\$',
                style: TextStyle(
                  color: greyColor,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.trending_up,
            color: greenColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        title: Text('Crypto Bazzar'),
        centerTitle: true,
        backgroundColor: blackColor,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          backgroundColor: greenColor,
          color: blackColor,
          onRefresh: () async {
            var dio = Dio();
            var response = await dio.get('https://api.coincap.io/v2/assets');
            coinData = response.data['data']
                .map<CryptoData>((jsonMap) => CryptoData.fromJson(jsonMap))
                .toList();
            setState(() {
              coinList = coinData;
            });
          },
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type your crypto name to search...',
                    contentPadding: EdgeInsets.all(10),
                    fillColor: greenColor,
                    filled: true,
                    hintStyle: TextStyle(
                      color: blackColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (text) {
                    coinList = copyCoinList?.toList();
                    setState(() {
                      coinList = coinList
                          ?.where(
                            (element) => element.name.toLowerCase().contains(
                                  text.toLowerCase(),
                                ),
                          )
                          .toList();
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  shrinkWrap: true,
                  itemCount: coinList!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        coinList![index].name,
                        style: TextStyle(
                          color: greyColor,
                        ),
                      ),
                      subtitle: Text(
                        coinList![index].symbol,
                        style: TextStyle(
                          color: greenColor,
                        ),
                      ),
                      leading: Text(
                        coinList![index].rank.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: greyColor,
                        ),
                      ),
                      trailing: changeMarketPercent(
                        coinList![index].changePercent24hr,
                        coinList![index].priceUsd,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
