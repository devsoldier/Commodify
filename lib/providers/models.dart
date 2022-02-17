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
