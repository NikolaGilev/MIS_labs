import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'exam-model.dart';

class AddExamDialog extends StatefulWidget {
  final Function(Exam) onExamAdded;

  AddExamDialog({required this.onExamAdded});

  @override
  _AddExamDialogState createState() => _AddExamDialogState();
}

class _AddExamDialogState extends State<AddExamDialog> {
  TextEditingController subjectController = TextEditingController();
  LatLng? selectedLocation;
  DateTime selectedDateTime = DateTime.now();
  late GoogleMapController mapController;

  Set<Polyline> polylines = {};


  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _showShortestPath(BuildContext context) {
    if (selectedLocation != null) {
      LatLng userLocation = LatLng(41.6086, 21.7453);
      List<LatLng> points = [userLocation, selectedLocation!];

      _getPolylinePoints(points).then((List<LatLng> polylinePoints) {
        Polyline polyline = Polyline(
          polylineId: PolylineId('shortestPath'),
          color: Colors.blue,
          points: polylinePoints,
          width: 3,
        );

        setState(() {
          polylines.add(polyline);
        });
      });
    }
  }


  Future<List<LatLng>> _getPolylinePoints(List<LatLng> points) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'GOOGLE API KEY',
      PointLatLng(points[0].latitude, points[0].longitude),
      PointLatLng(points[1].latitude, points[1].longitude),
    );

    List<LatLng> polylineCoordinates = polylinePoints.decodePolyline(result.points as String)
        .map((PointLatLng point) => LatLng(point.latitude, point.longitude))
        .toList();

    return polylineCoordinates;
  }



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Exam'),
      content: Column(
        children: [
          TextField(
            controller: subjectController,
            decoration: const InputDecoration(labelText: 'Subject'),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(41.6086, 21.7453),
                zoom: 15.0,
              ),
              onTap: (LatLng location) {
                setState(() {
                  selectedLocation = location;
                });
              },
              markers: {
                if (selectedLocation != null)
                  Marker(
                    markerId: MarkerId('selectedLocation'),
                    position: selectedLocation!,
                    infoWindow: InfoWindow(title: 'Selected Location'),
                  ),
              },
              polylines: polylines,
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: const Text('Date and Time'),
            subtitle: Text('$selectedDateTime'),
            onTap: () => _selectDateTime(context),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (subjectController.text.isNotEmpty && selectedLocation != null) {
              Exam newExam = Exam(
                subject: subjectController.text,
                dateTime: selectedDateTime,
                location: selectedLocation!,
              );
              widget.onExamAdded(newExam);
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please fill in the subject and select a location.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () {
             _showShortestPath(context);
          },
          child: const Text('Show Shortest Path'),
        ),
      ],
    );
  }
}
