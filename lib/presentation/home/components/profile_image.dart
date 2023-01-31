import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class ProfileImage extends StatelessWidget {
  final String imageUrl;
  final double backgroundSize;
  final double foregroundSize;

  const ProfileImage({
    super.key,
    required this.imageUrl,
    required this.backgroundSize,
    required this.foregroundSize,
  });

  @override
  Widget build(BuildContext context) {
    return imageUrl.isEmpty
        ? const Icon(Feather.user)
        : Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.red,
                      Colors.orange,
                      Colors.amber,
                      Colors.green,
                      Colors.blue,
                    ],
                  ),
                ),
                width: backgroundSize,
                height: backgroundSize,
              ),
              CircleAvatar(
                radius: foregroundSize,
                foregroundImage: NetworkImage(imageUrl),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
            ],
          );
  }
}
