class AttendanceRecord {
  final int id;
  final int memberId;
  final String date;
  final String checkInTime;
  final String? checkOutTime;
  final String createdAt;
  final String updatedAt;

  AttendanceRecord({
    required this.id,
    required this.memberId,
    required this.date,
    required this.checkInTime,
    this.checkOutTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] ?? 0,
      memberId: json['memberId'] ?? 0,
      date: json['date'] ?? '',
      checkInTime: json['checkInTime'] ?? '',
      checkOutTime: json['checkOutTime'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class AttendanceDataModel {
  final int presentdays;
  final int percentage;
  final int totalWorkingDays;
  final List<AttendanceRecord> records;

  AttendanceDataModel({
    required this.presentdays,
    required this.percentage,
    required this.totalWorkingDays,
    required this.records,
  });

  factory AttendanceDataModel.fromJson(Map<String, dynamic> json) {
    var recordsList = json['records'] as List? ?? [];
    List<AttendanceRecord> records = recordsList.map((e) => AttendanceRecord.fromJson(e)).toList();

    return AttendanceDataModel(
      presentdays: json['presentdays'] ?? 0,
      percentage: json['percentage'] ?? 0,
      totalWorkingDays: json['totalWorkingDays'] ?? 0,
      records: records,
    );
  }
}
