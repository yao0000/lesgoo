import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel/services/firebase_service.dart';
import 'package:travel/route/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  //upload();
  runApp(const MyApp());
}

final List<Map<String, dynamic>> restaurants = [
  {
    'name': 'Cloud Nine Grill',
    'price': 45,
    'rating': 4.7,
    'about': 'Panoramic views of LAX with Californian fusion cuisine.',
    'address': '201 World Way, Los Angeles, CA 90045',
    'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSFus8zWqptbVTI1Kdn8efnEvnlROcNPUZzXg&s'
  },
  {
    'name': 'Miami Spice Harbor',
    'price': 50,
    'rating': 4.4,
    'about': 'Fresh seafood and Cuban-inspired dishes near Miami Airport.',
    'address': '3500 NW 21st St, Miami, FL 33142',
    'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqj6LtDOZm-APHiUFuSE2Cr1In65Vvjzr3w8Z8QE2QvyQvgY-MhZVkXD68g5lQe156DP4&usqp=CAU'
  },
];

final List<Map<String, dynamic>> hotels = [
  {
    "name": "Waikiki Beach Resort",
    "price": 250,
    "rating": 4.7,
    "about":
        "A luxurious beachfront resort with stunning ocean views and top-notch amenities.",
    "address": "2335 Kalakaua Ave, Honolulu, HI 96815",
  },
  {
    "name": "Chicago Grand Plaza",
    "price": 180,
    "rating": 4.5,
    "about":
        "A modern hotel in downtown Chicago, close to shopping and entertainment.",
    "address": "540 N Michigan Ave, Chicago, IL 60611",
  },
  /*{
    "name": "LAX Skyview Hotel",
    "price": 150,
    "rating": 4.3,
    "about":
        "Conveniently located near LAX, offering comfortable rooms and great service.",
    "address": "5985 W Century Blvd, Los Angeles, CA 90045",
  },
  {
    "name": "Sydney Harbour Suites",
    "price": 220,
    "rating": 4.6,
    "about":
        "Overlooking the Sydney Opera House, perfect for tourists and business travelers.",
    "address": "93 Macquarie St, Sydney NSW 2000, Australia",
  },
  {
    "name": "Tokyo Imperial Stay",
    "price": 270,
    "rating": 4.8,
    "about":
        "A high-end hotel in central Tokyo with traditional and modern luxury.",
    "address": "1-1-1 Chiyoda, Tokyo 100-0001, Japan",
  },
  {
    "name": "London Royal Inn",
    "price": 200,
    "rating": 4.4,
    "about":
        "A classic British-style hotel with easy access to landmarks like Big Ben.",
    "address": "22-28 Broadway, London SW1H 0BH, UK",
  },
  {
    "name": "Paris Eiffel Suites",
    "price": 300,
    "rating": 4.7,
    "about":
        "Elegant suites with Eiffel Tower views, ideal for a romantic getaway.",
    "address": "12 Rue de la Tour, 75007 Paris, France",
  },
  {
    "name": "New York Skyline Hotel",
    "price": 320,
    "rating": 4.9,
    "about":
        "Located in Times Square, offering breathtaking views and luxurious rooms.",
    "address": "350 W 42nd St, New York, NY 10036",
  },
  {
    "name": "Dubai Luxury Resort",
    "price": 400,
    "rating": 5.0,
    "about":
        "A premium 5-star resort with world-class service and beachfront access.",
    "address": "The Palm Jumeirah, Dubai, UAE",
  },
  {
    "name": "Rome Colosseum Hotel",
    "price": 190,
    "rating": 4.5,
    "about": "A historic hotel in the heart of Rome, close to the Colosseum.",
    "address": "Via dei Fori Imperiali, 00184 Roma RM, Italy",
  },
  {
    "name": "Seoul Grand Palace",
    "price": 210,
    "rating": 4.6,
    "about":
        "Modern luxury in the city center, near shopping districts and cultural sites.",
    "address": "105 Namsan Rd, Seoul, South Korea",
  },
  {
    "name": "Berlin Central Hotel",
    "price": 180,
    "rating": 4.3,
    "about":
        "A contemporary stay with easy access to Berlin’s top attractions.",
    "address": "Friedrichstr. 99, 10117 Berlin, Germany",
  },
  {
    "name": "Bangkok Riverside Inn",
    "price": 140,
    "rating": 4.2,
    "about": "A cozy riverside hotel offering authentic Thai hospitality.",
    "address": "23 Charoenkrung Rd, Bangkok, Thailand",
  },
  {
    "name": "Hong Kong Bay Suites",
    "price": 250,
    "rating": 4.7,
    "about": "Stunning Victoria Harbour views and world-class dining.",
    "address": "18 Salisbury Rd, Tsim Sha Tsui, Hong Kong",
  },
  {
    "name": "Toronto Maple Inn",
    "price": 175,
    "rating": 4.4,
    "about": "A stylish hotel in downtown Toronto, near major attractions.",
    "address": "100 Queen St W, Toronto, ON M5H 2N2, Canada",
  },
  {
    "name": "Melbourne City Stay",
    "price": 160,
    "rating": 4.2,
    "about": "A comfortable hotel in Melbourne’s bustling city center.",
    "address": "270 Flinders St, Melbourne VIC 3000, Australia",
  },
  {
    "name": "Amsterdam Canal View",
    "price": 230,
    "rating": 4.6,
    "about": "A picturesque hotel with scenic canal views.",
    "address": "Prinsengracht 587, 1016 HT Amsterdam, Netherlands",
  },
  {
    "name": "Madrid Royal Suites",
    "price": 210,
    "rating": 4.5,
    "about": "A blend of classic Spanish charm and modern luxury.",
    "address": "Calle Gran Vía, 28013 Madrid, Spain",
  },
  {
    "name": "Rio de Janeiro Beachfront",
    "price": 220,
    "rating": 4.7,
    "about": "A lively hotel near Copacabana Beach with vibrant nightlife.",
    "address": "Av. Atlântica, 22070-011 Rio de Janeiro, Brazil",
  },
  {
    "name": "Singapore Marina Bay",
    "price": 280,
    "rating": 4.8,
    "about": "A stunning high-rise hotel overlooking Marina Bay Sands.",
    "address": "10 Bayfront Ave, Singapore 018956",
  },
  {
    "name": "Bali Sunset Resort",
    "price": 170,
    "rating": 4.5,
    "about": "A relaxing beachfront hotel with stunning sunset views.",
    "address": "Jalan Pantai Kuta, Bali 80361, Indonesia",
  },
  {
    "name": "Cape Town Oceanfront",
    "price": 190,
    "rating": 4.6,
    "about": "A modern hotel with stunning ocean views and excellent service.",
    "address": "Victoria Rd, Camps Bay, Cape Town 8005, South Africa",
  },
  {
    "name": "Athens Acropolis Inn",
    "price": 160,
    "rating": 4.3,
    "about": "A charming boutique hotel with easy access to ancient ruins.",
    "address": "Dionysiou Areopagitou, Athens 11742, Greece",
  },
  {
    "name": "Istanbul Grand Hotel",
    "price": 200,
    "rating": 4.5,
    "about":
        "A luxurious hotel with a mix of European and Middle Eastern design.",
    "address": "Sultanahmet, 34122 Istanbul, Turkey",
  },
  {
    "name": "Los Angeles Sunset Lodge",
    "price": 220,
    "rating": 4.6,
    "about": "A Hollywood-style stay with easy access to entertainment hubs.",
    "address": "1755 N Highland Ave, Los Angeles, CA 90028",
  },
  {
    "name": "San Francisco Bayview Hotel",
    "price": 250,
    "rating": 4.7,
    "about": "A scenic hotel with Golden Gate Bridge views.",
    "address": "333 O'Farrell St, San Francisco, CA 94102",
  },*/
];

final List<Map<String, dynamic>> cars = [
  {
    'name': "Toyota Corolla",
    'price': 50.0,
    'seats': 5,

  }
];

void upload() async {
  for (var item in hotels) {
    await FirebaseFirestore.instance.collection('hotels').add(item);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
