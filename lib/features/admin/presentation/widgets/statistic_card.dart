import 'package:flutter/material.dart';

class StatisticCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const StatisticCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Column(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(.15),
                child: Icon(icon, color: color),
              ),

              const SizedBox(height: 15),

              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),

              const SizedBox(height: 5),

              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
