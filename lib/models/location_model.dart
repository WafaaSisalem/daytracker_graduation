import 'package:equatable/equatable.dart';

class LocationModel extends Equatable {
  const LocationModel(this.lat, this.lng, this.address);
  final double lat;
  final double lng;
  final String address;

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
      'address': address,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      map['lat']?.toDouble() ?? 0.0,
      map['lng']?.toDouble() ?? 0.0,
      map['address'] ?? '',
    );
  }

  @override
  List<Object?> get props => [address];
}
