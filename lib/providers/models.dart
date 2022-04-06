import 'dart:ui';

class Commodity {
  final num close;
  final DateTime epoch;
  final num high;
  final num low;
  final num open;
  Commodity(
      {required this.close,
      required this.epoch,
      required this.high,
      required this.low,
      required this.open});

  @override
  String toString() => '$close, $epoch,$high,$low,$open';
}

class TransactionHistory {
  final dynamic user_id;
  final DateTime epoch;
  final dynamic tx_amount;
  final String tx_type;
  final String tx_asset;
  final String tx_id;
  TransactionHistory({
    required this.user_id,
    required this.epoch,
    required this.tx_amount,
    required this.tx_type,
    required this.tx_asset,
    required this.tx_id,
  });
  @override
  String toString() => '$user_id, $epoch,$tx_amount,$tx_type,$tx_asset,$tx_id';
}

class UserDetail {
  final dynamic user_id;
  final String user_email;
  final String first_name;
  final String last_name;
  final dynamic phone_number;

  UserDetail(
      {required this.user_id,
      required this.user_email,
      required this.first_name,
      required this.last_name,
      required this.phone_number});

  @override
  String toString() =>
      '$user_id, $user_email,$first_name,$last_name,$phone_number';
}

// class PriceOnly {
//   final num Quote;
//   PriceOnly({required this.Quote});
//   @override
//   String toString() => '$Quote';
// }

class PaymentHistory {
  final dynamic user_id;
  final String payment_type;
  final dynamic payment_amount;
  final String payment_status;
  final DateTime payment_timestamp;
  final String payment_id;
  PaymentHistory({
    required this.user_id,
    required this.payment_type,
    required this.payment_amount,
    required this.payment_status,
    required this.payment_timestamp,
    required this.payment_id,
  });
  @override
  String toString() =>
      '$user_id, $payment_type,$payment_amount,$payment_status,$payment_timestamp,$payment_id';
}

class UserAsset {
  final dynamic user_id;
  final dynamic gold_amount;
  final dynamic platinum_amount;
  final dynamic silver_amount;
  final dynamic palladium_amount;

  UserAsset(
      {required this.user_id,
      required this.gold_amount,
      required this.platinum_amount,
      required this.silver_amount,
      required this.palladium_amount});

  @override
  String toString() =>
      '$user_id,$gold_amount,$platinum_amount,$silver_amount,$palladium_amount';
}

class AssetDummy {
  // final String user_id;
  final dynamic gold_amount;
  final dynamic platinum_amount;
  final dynamic silver_amount;
  final dynamic palladium_amount;

  AssetDummy(
      {/* required this.user_id, */
      required this.gold_amount,
      required this.platinum_amount,
      required this.silver_amount,
      required this.palladium_amount});

  @override
  String toString() =>
      '$gold_amount,$platinum_amount,$silver_amount,$palladium_amount';
}

class AssetData {
  final String x;
  final dynamic y;
  final Color color;
  AssetData({required this.x, required this.y, required this.color});
  @override
  String toString() => '$x,$y,$color';
}
