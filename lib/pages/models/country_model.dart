import 'dart:convert';

class Countries {
  final String? status;
  final int? statusCode;
  final String? version;
  final String? access;
  final int? total;
  final int? offset;
  final int? limit;
  final Map<String, Datum>? data;

  Countries({
    this.status,
    this.statusCode,
    this.version,
    this.access,
    this.total,
    this.offset,
    this.limit,
    this.data,
  });

  Countries copyWith({
    String? status,
    int? statusCode,
    String? version,
    String? access,
    int? total,
    int? offset,
    int? limit,
    Map<String, Datum>? data,
  }) =>
      Countries(
        status: status ?? this.status,
        statusCode: statusCode ?? this.statusCode,
        version: version ?? this.version,
        access: access ?? this.access,
        total: total ?? this.total,
        offset: offset ?? this.offset,
        limit: limit ?? this.limit,
        data: data ?? this.data,
      );

  factory Countries.fromRawJson(String str) => Countries.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Countries.fromJson(Map<String, dynamic> json) => Countries(
    status: json["status"],
    statusCode: json["status-code"],
    version: json["version"],
    access: json["access"],
    total: json["total"],
    offset: json["offset"],
    limit: json["limit"],
    data: Map.from(json["data"]!).map((k, v) => MapEntry<String, Datum>(k, Datum.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "status-code": statusCode,
    "version": version,
    "access": access,
    "total": total,
    "offset": offset,
    "limit": limit,
    "data": Map.from(data!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class Datum {
  final String? country;
  final Region? region;

  Datum({
    this.country,
    this.region,
  });

  Datum copyWith({
    String? country,
    Region? region,
  }) =>
      Datum(
        country: country ?? this.country,
        region: region ?? this.region,
      );

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    country: json["country"],
    region: regionValues.map[json["region"]]!,
  );

  Map<String, dynamic> toJson() => {
    "country": country,
    "region": regionValues.reverse[region],
  };
}

enum Region {
  AFRICA,
  ANTARCTIC,
  ASIA,
  CENTRAL_AMERICA
}

final regionValues = EnumValues({
  "Africa": Region.AFRICA,
  "Antarctic": Region.ANTARCTIC,
  "Asia": Region.ASIA,
  "Central America": Region.CENTRAL_AMERICA
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
