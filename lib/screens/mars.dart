import 'package:flutter/material.dart';
import '../services/mars_service.dart';
import '../models/mars_weather.dart';

class Page2Screen extends StatefulWidget {
  @override
  _Page2ScreenState createState() => _Page2ScreenState();
}

class _Page2ScreenState extends State<Page2Screen> {
  final MarsService marsService =
      MarsService('4aOaBvX6w1ezm561gg42cjm4B6kDVNZwnxMHxeku');
  DateTime? selectedDate;
  String? selectedRover;
  List<String> roverImages = [];
  bool isLoading = false;
  MarsWeather? marsWeather;

  final List<String> roverNames = [
    'opportunity',
    'spirit',
    'curiosity',
    'perseverance'
  ];

  @override
  void initState() {
    super.initState();
    fetchMarsWeather();
  }

  Future<void> fetchMarsWeather() async {
    final weather = await marsService.fetchMarsWeather();
    setState(() {
      marsWeather = weather;
    });
  }

  Future<void> fetchRoverImages() async {
    if (selectedDate == null || selectedRover == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Veuillez sélectionner une date et un rover.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      roverImages = [];
    });

    final images =
        await marsService.fetchRoverImages(selectedRover!, selectedDate!);
    setState(() {
      roverImages = images;
      isLoading = false;
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Widget buildMarsWeather() {
    if (marsWeather == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Mars Weather',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Temperature: ${marsWeather!.temperature ?? "N/A"} °C'),
          Text('Pressure: ${marsWeather!.pressure ?? "N/A"} Pa'),
          Text('Wind Speed: ${marsWeather!.windSpeed ?? "N/A"} m/s'),
          Text('Wind Direction: ${marsWeather!.windDirection ?? "N/A"}'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('MARS Weather & Rovers'),
          backgroundColor: Colors.black,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildMarsWeather(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _pickDate(context),
              child: Text(selectedDate == null
                  ? 'Sélectionner une date'
                  : 'Date sélectionnée : ${selectedDate!.toLocal()}'
                      .split(' ')[0]),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedRover,
              hint: const Text('Sélectionner un rover'),
              onChanged: (String? newRover) {
                setState(() {
                  selectedRover = newRover;
                });
              },
              items: roverNames.map((rover) {
                return DropdownMenuItem<String>(
                  value: rover,
                  child: Text(rover),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchRoverImages,
              child: const Text('Afficher les images'),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (roverImages.isNotEmpty)
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: roverImages.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      roverImages[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              )
            else
              const Center(
                  child: Text('Aucune image disponible pour cette date.')),
          ],
        ),
      ),
    );
  }
}
