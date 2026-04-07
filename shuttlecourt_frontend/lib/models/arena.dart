class Arena {
  final int id;
  final String name;
  final String location;
  final String? description;
  final double price;
  final String? image;
  final int ownerId;

  Arena({
    required this.id,
    required this.name,
    required this.location,
    this.description,
    required this.price,
    this.image,
    required this.ownerId,
  });

  factory Arena.fromJson(Map<String, dynamic> json) {
    return Arena(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      image: json['image'],
      ownerId: json['owner_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'location': location,
        'description': description,
        'price': price,
        'image': image,
      };
}
