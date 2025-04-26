class Product {
  final int id;
  final String name;
  final double price;
  final String image;
  final String category;

  Product({required this.id, required this.name, required this.price, required this.image, required this.category});
}

List<Product> demoProducts = [
  Product(id: 1, name: "Smartphone", price: 499.99, image: "assets/smartphone.png", category: "Electronics"),
  Product(id: 2, name: "Shoes", price: 59.99, image: "assets/shoes.png", category: "Fashion"),
  Product(id: 3, name: "Headphones", price: 79.99, image: "assets/headphones.png", category: "Electronics"),
];
