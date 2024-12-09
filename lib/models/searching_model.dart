class NasaImage {
  final String title;
  final String dateCreated;
  final String description;
  final List<String> keywords;
  final String imageUrl;

  NasaImage({
    required this.title,
    required this.dateCreated,
    required this.description,
    required this.keywords,
    required this.imageUrl,
  });

  // Factory pour construire l'objet depuis un JSON
  factory NasaImage.fromJson(Map<String, dynamic> json) {
    return NasaImage(
      title: json['title'] ?? 'Sans titre',
      dateCreated: json['date_created'] ?? 'Inconnu',
      description: json['description'] ?? 'Pas de description.',
      keywords: List<String>.from(json['keywords'] ?? []),
      imageUrl: json['links'] != null &&
              json['links'] is List &&
              json['links'].isNotEmpty
          ? json['links'][0]['href']
          : '',
    );
  }
}
