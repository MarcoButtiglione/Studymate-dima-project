class Category {
  final String id;
  final String name;
  final String imageURL;

  Category({
    this.id = '',
    required this.name,
    required this.imageURL,
  });
  
  Map<String,dynamic> toJson()=>{
    'id':id,
    'name': name,
    'imageURL':imageURL
  };

  static Category fromJson(Map<String,dynamic> json)=> Category(
    id:json['id'],
    name:json['name'],
    imageURL:json['imageURL']
  );
}
