import 'package:restaurant_app/data/remote/models/response/restaurant.dart';
import 'package:restaurant_app/data/remote/models/response/restaurant_list.dart';

class MockRestaurant {
  static final List<Restaurant> sampleRestaurants = [
    Restaurant(
      id: "1",
      name: "Warung Makan Sederhana",
      description: "Tempat makan murah meriah dengan makanan khas Indonesia.",
      pictureId: "https://example.com/image1.jpg",
      city: "Jakarta",
      rating: 4.5,
    ),
    Restaurant(
      id: "2",
      name: "Bakso Pak Kumis",
      description: "Bakso enak dengan kuah kaldu sapi yang gurih.",
      pictureId: "https://example.com/image2.jpg",
      city: "Surabaya",
      rating: 4.2,
    ),
    Restaurant(
      id: "3",
      name: "Sate Ayam Madura",
      description: "Sate ayam dengan bumbu kacang khas Madura.",
      pictureId: "https://example.com/image3.jpg",
      city: "Bandung",
      rating: 4.7,
    ),
  ];

  static final RestaurantList sampleRestaurantList = RestaurantList(
    error: false,
    message: "Success",
    count: sampleRestaurants.length,
    restaurants: sampleRestaurants,
  );
}
