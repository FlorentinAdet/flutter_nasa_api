import 'package:flutter/material.dart';
import '../models/searching_model.dart';

class NasaImageDetailsScreen extends StatelessWidget {
  final NasaImage result;

  const NasaImageDetailsScreen({Key? key, required this.result})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(result.title),
        backgroundColor: Colors.black,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                result.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
              ),
              const SizedBox(height: 16),
              Text(
                'Titre : ${result.title}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Date de création : ${result.dateCreated}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Description : ${result.description}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              if (result.keywords.isNotEmpty)
                Text(
                  'Mots-clés : ${result.keywords.join(', ')}',
                  style: const TextStyle(fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
