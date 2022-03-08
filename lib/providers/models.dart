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
  final String user_id;
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
  final String user_id;
  final String user_email;
  final String first_name;
  final String last_name;

  UserDetail(
      {required this.user_id,
      required this.user_email,
      required this.first_name,
      required this.last_name});

  @override
  String toString() => '$user_id, $user_email,$first_name,$last_name';
}
