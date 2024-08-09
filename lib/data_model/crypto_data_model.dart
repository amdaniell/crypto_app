class CryptoData {
  final int rank;
  final String id, symbol, name;
  final double? changePercent24hr, priceUsd, marketCap;
  CryptoData(
    this.rank,
    this.id,
    this.symbol,
    this.name,
    this.changePercent24hr,
    this.priceUsd,
    this.marketCap,
  );
  factory CryptoData.fromJson(Map<String, dynamic> jsonMap) {
    return CryptoData(
      int.parse(jsonMap['rank']),
      jsonMap['id'],
      jsonMap['symbol'],
      jsonMap['name'],
      double.tryParse(jsonMap['changePercent24Hr']),
      double.tryParse(jsonMap['priceUsd']),
      double.tryParse(jsonMap['marketCapUsd']),
    );
  }
}
