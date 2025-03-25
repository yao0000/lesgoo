import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:travel/data/models/function.dart';

class CardObject extends StatelessWidget {
  final dynamic item;
  CardObject({super.key, required this.item});
  final currencyFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/details', extra: item);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                color: Colors.grey[300],
                child: Image.network(
                  getAttribute(item, 'imageUrl'),
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getAttribute(item, 'name'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    getAttribute(item, 'price'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getAttribute(item, 'field3'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    getAttribute(item, 'field4'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
