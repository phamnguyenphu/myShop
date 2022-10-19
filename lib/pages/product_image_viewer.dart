import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ProductImageViewer extends StatelessWidget {
  final String imageUrl;
  final String title;
  const ProductImageViewer(
      {Key? key, required this.imageUrl, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: PhotoView(
        backgroundDecoration: const BoxDecoration(color: Colors.white),
        heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
        imageProvider: CachedNetworkImageProvider(imageUrl),
      ),
    );
  }
}
