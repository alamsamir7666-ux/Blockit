class ParachuteModel {
  final int total;
  final int used;
  final int remaining;

  const ParachuteModel({
    required this.total,
    required this.used,
    required this.remaining,
  });

  factory ParachuteModel.fromJson(Map<String, dynamic> json) {
    return ParachuteModel(
      total: json['total'] as int? ?? 0,
      used: json['used'] as int? ?? 0,
      remaining: json['remaining'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'used': used,
      'remaining': remaining,
    };
  }
}
