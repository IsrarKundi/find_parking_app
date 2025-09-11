class Parking {
  final String id;
  final String name;
  final String address;
  final double price;
  final int availableSpots;
  final String hours;
  final double latitude;
  final double longitude;

  Parking({
    required this.id,
    required this.name,
    required this.address,
    required this.price,
    required this.availableSpots,
    required this.hours,
    required this.latitude,
    required this.longitude,
  });
}