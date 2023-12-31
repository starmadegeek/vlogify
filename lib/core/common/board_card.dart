import 'package:flutter/material.dart';
import 'package:vlogify/models/board_model.dart';

class BoardCard extends StatelessWidget {
  final Board board;

  const BoardCard({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: InkWell(
        onTap: () {
          // Handle board tap
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  board.banner), // Assuming 'banner' is the URL of the image
              fit: BoxFit.cover,
            ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 16.0,
                left: 16.0,
                child: Text(
                  board.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 16.0,
                child: Text(
                  board.ownerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
