import 'package:flutter/material.dart';
import '../models/searching_model.dart';
import '../services/searching_service.dart';
import './nasa_image_details_screen.dart';

class Searching extends StatefulWidget {
  @override
  _NasaSearchScreenState createState() => _NasaSearchScreenState();
}

class _NasaSearchScreenState extends State<Searching> {
  final TextEditingController searchController = TextEditingController();
  final NasaApiService apiService = NasaApiService();
  List<NasaImage> searchResults = [];
  bool isLoading = false;

  Future<void> searchImages(String query) async {
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez entrer un mot-clé pour la recherche.'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final results = await apiService.searchImages(query);
      setState(() {
        searchResults = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche NASA'),
        backgroundColor: Colors.black,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ de recherche
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Rechercher',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => searchImages(searchController.text),
                  child: const Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Affichage des résultats
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : searchResults.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final result = searchResults[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: Image.network(
                                  result.imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                                ),
                                title: Text(result.title),
                                onTap: () {
                                  // Ouvrir les détails
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NasaImageDetailsScreen(
                                              result: result),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      )
                    : const Center(child: Text('Aucun résultat trouvé.')),
          ],
        ),
      ),
    );
  }
}
