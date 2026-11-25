import 'package:flutter/material.dart';
import '../screens/menu.dart';
import 'portofolio_navigation.dart';

class ItemCard extends StatelessWidget {
  const ItemCard(this.item, {super.key});

  final ItemHomepage item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => openPortfolioMenu(context, item.name),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(item.icon, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.name,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
