import 'package:conju_app/constants/color_constant.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Products"),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GridView.builder(
            padding: const EdgeInsets.only(top: 16), // Add padding at the top
            itemCount: demoProducts.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.7,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemBuilder: (context, index) => ProductCard(
              product: demoProducts[index],
              onPress: () {
                // Handle product tap
                // ignore: avoid_print
                print('Tapped on ${demoProducts[index].title}');
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.product,
    required this.onPress,
  });

  final double width, aspectRetio;
  final Product product;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: aspectRetio,
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF979797).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      image: NetworkImage(product.images[0]),
                      fit: BoxFit.cover)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.title,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$${product.price.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF7643),
                ),
              ),
              InkWell(
                onTap: () {
                  launchUrl(Uri.parse(
                      "https://www.dvago.pk/cat/eye-infection?srsltid=AfmBOoo3Tse270n8g2i7C6Y8SLTekUf40xorSMD9kiIEqEMGhNfEjVl4"));
                },
                child: const Text(
                  "Visit Website",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mediumAquarine,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Product {
  final int id;
  final String title, description;
  final List<String> images;
  final List<Color> colors;
  final double rating, price;
  final bool isFavourite, isPopular;

  Product({
    required this.id,
    required this.images,
    required this.colors,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    required this.title,
    required this.price,
    required this.description,
  });
}

// Sample Products Data
List<Product> demoProducts = [
  Product(
    id: 1,
    images: [
      "https://images.ctfassets.net/u4vv676b8z52/3PgTjyAKGu9CGF0v34RKBi/30a74fab35c5f540cfaa7b4f2cdb0766/pink-eye-medicine-hero.jpg?fm=jpg&q=80"
    ],
    colors: [Colors.red, Colors.blue, Colors.green],
    title: "OTC and Prescribed ",
    price: 4.99,
    description: description,
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 2,
    images: [
      "https://4.imimg.com/data4/DV/WJ/MY-9666337/moxifloxacin-0-5-loteprednol-0-5-500x500.jpg"
    ],
    colors: [Colors.orange, Colors.purple],
    title: "Allopathic Moxifloxacin",
    price: 5.5,
    description: description,
    rating: 4.1,
    isPopular: true,
  ),
  Product(
    id: 3,
    images: [
      "https://www.zexuspharma.com/wp-content/uploads/2021/07/WhatsApp-Image-2022-02-12-at-1.01.13-PM-1-291x300.jpeg"
    ],
    colors: [Colors.black, Colors.grey],
    title: "Gatizex Eye Drops",
    price: 7.15,
    description: description,
    rating: 4.1,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 4,
    images: [
      "https://www.zexuspharma.com/wp-content/uploads/2022/03/olopect-1-300x300.jpg"
    ],
    colors: [Colors.white, Colors.brown],
    title: "Olopect Eye Drops",
    price: 6.0,
    description: description,
    rating: 4.0,
    isFavourite: false,
    isPopular: true,
  ),
];

const String description =
    "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";

const heartIcon =
    '''<svg width="18" height="16" viewBox="0 0 18 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M16.5266 8.61383L9.27142 15.8877C9.12207 16.0374 8.87889 16.0374 8.72858 15.8877L1.47343 8.61383C0.523696 7.66069 0 6.39366 0 5.04505C0 3.69644 0.523696 2.42942 1.47343 1.47627C2.45572 0.492411 3.74438 0 5.03399 0C6.3236 0 7.61225 0.492411 8.59454 1.47627C8.81857 1.70088 9.18143 1.70088 9.40641 1.47627C11.3691 -0.491451 14.5629 -0.491451 16.5266 1.47627C17.4763 2.42846 18 3.69548 18 5.04505C18 6.39366 17.4763 7.66165 16.5266 8.61383Z" fill="#DBDEE4"/>
</svg>
''';
