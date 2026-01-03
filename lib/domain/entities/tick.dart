/// ═══════════════════════════════════════════════════════════
/// Tick Entity - تحديث سعري لحظي
/// ═══════════════════════════════════════════════════════════
library;

import 'package:equatable/equatable.dart';

class Tick extends Equatable {
  /// الوقت
  final DateTime time;
  
  /// سعر البيع (Bid)
  final double bid;
  
  /// سعر الشراء (Ask)
  final double ask;
  
  /// اسم الأداة المالية
  final String instrument;
  
  /// السعر الأخير (Last traded price) - اختياري
  final double? last;

  const Tick({
    required this.time,
    required this.bid,
    required this.ask,
    required this.instrument,
    this.last,
  });

  /// السعر الوسطي (Mid Price)
  double get mid => (bid + ask) / 2;

  /// الفارق (Spread)
  double get spread => ask - bid;

  /// الفارق بالنقاط (Pips)
  double get spreadPips => spread * 10000; // للعملات الرئيسية

  /// Unix timestamp
  int get timestamp => time.millisecondsSinceEpoch;

  Tick copyWith({
    DateTime? time,
    double? bid,
    double? ask,
    String? instrument,
    double? last,
  }) {
    return Tick(
      time: time ?? this.time,
      bid: bid ?? this.bid,
      ask: ask ?? this.ask,
      instrument: instrument ?? this.instrument,
      last: last ?? this.last,
    );
  }

  @override
  List<Object?> get props => [time, bid, ask, instrument, last];

  @override
  String toString() {
    return 'Tick($instrument @ ${time.toIso8601String()}: '
        'bid=$bid, ask=$ask, spread=${spread.toStringAsFixed(5)})';
  }
}
