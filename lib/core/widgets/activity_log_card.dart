import 'package:flutter/material.dart';

class ActivityLogCard extends StatelessWidget {
  final String title;
  final String description;
  final String user;
  final String date;
  final String time;
  final String category;
  final String type;

  const ActivityLogCard({
    super.key,
    required this.title,
    required this.description,
    required this.user,
    required this.date,
    required this.time,
    required this.category,
    required this.type,
  });

  Color _getCategoryColor() {
    switch (category.toLowerCase()) {
      case 'warning':
        return Colors.orangeAccent;
      case 'error':
        return Colors.redAccent;
      default:
        return Colors.blueAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _getCategoryColor().withOpacity(0.7),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 6),

          // Description
          Text(
            description,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 10),

          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'By $user',
                style: const TextStyle(color: Colors.black45, fontSize: 12),
              ),
              Text(
                '$date • $time',
                style: const TextStyle(color: Colors.black45, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
