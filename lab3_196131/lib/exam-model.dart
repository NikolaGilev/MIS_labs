import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExamList extends StatelessWidget {
  final List<Exam> exams;

  ExamList({required this.exams});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        return ExamCard(exam: exams[index], onShowShortestPath: () => _showShortestPath(context, exams[index]));
      },
    );
  }

  void _showShortestPath(BuildContext context, Exam exam) async {
    String apiKey = 'GOOGLE API KEY';
    final PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> polylineCoordinates = [];

    final String origin = '41.6086,21.7453';
    final String destination = '${exam.location.latitude},${exam.location.longitude}';

    String apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      List<PointLatLng> points = polylinePoints.decodePolyline(data['routes'][0]['overview_polyline']['points']);
      polylineCoordinates = points.map((point) => LatLng(point.latitude, point.longitude)).toList();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShortestPathMap(
            origin: LatLng(41.6086, 21.7453),
            destination: exam.location,
            polylineCoordinates: polylineCoordinates,
          ),
        ),
      );
    } else {
      throw Exception('Failed to load directions');
    }
  }
}

class ExamCard extends StatelessWidget {
  final Exam exam;
  final VoidCallback onShowShortestPath;

  ExamCard({required this.exam, required this.onShowShortestPath});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20.0,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exam.subject,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Date and Time: ${exam.dateTime}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Location: ${exam.location}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: onShowShortestPath,
              child: Text('Show Shortest Path'),
            ),
          ],
        ),
      ),
    );
  }
}

class Exam {
  final String subject;
  final DateTime dateTime;
  final LatLng location;

  Exam({required this.subject, required this.dateTime, required this.location});
}

class ShortestPathMap extends StatelessWidget {
  final LatLng origin;
  final LatLng destination;
  final List<LatLng> polylineCoordinates;

  ShortestPathMap({required this.origin, required this.destination, required this.polylineCoordinates});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shortest Path Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: origin, zoom: 12),
        polylines: {
          Polyline(
            polylineId: PolylineId('shortestPath'),
            color: Colors.blue,
            points: polylineCoordinates,
            width: 3,
          ),
        },
      ),
    );
  }
}
