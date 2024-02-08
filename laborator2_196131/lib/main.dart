import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clothing Store 196131',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ClothingListScreen(),
    );
  }
}

class ClothingListScreen extends StatefulWidget {
  @override
  _ClothingListScreenState createState() => _ClothingListScreenState();
}

class _ClothingListScreenState extends State<ClothingListScreen> {
  List<String> clothingList = [
    'Trousers',
    'Skirts',
    'Hats',
  ];

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clothes Shopping 196131'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: clothingList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    clothingList[index],
                    style: const TextStyle(color: Colors.green),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        child: TextButton(
                          onPressed: () {
                            _showDeleteConfirmationDialog(index);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Delete'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Edit Clothing'),
                                content: TextField(
                                  controller: TextEditingController(
                                    text: clothingList[index],
                                  ),
                                  onChanged: (value) {
                                    controller.text=value;
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        clothingList[index] = controller.text;
                                      });
                                      Navigator.pop(context);
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      backgroundColor: Colors.green,
                                    ),
                                    child: const Text('Edit'),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Edit'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter Clothing Name',
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if(controller.text.isNotEmpty){
                          clothingList.add(controller.text);
                          controller.clear();
                        }
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.green,
                      ),
                    ),
                    child: const Text(
                      'Add Item',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(int index) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation', style: TextStyle(color: Colors.red)),
          content: const Text('Are you sure you want to delete this clothing item?', style: TextStyle(color: Colors.blue)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: const Text('Cancel', style: TextStyle(color: Colors.red, )),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  clothingList.removeAt(index);
                });
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: const Text('Delete', style: TextStyle(color: Colors.red, )),
            ),
          ],
        );
      },
    );
  }
}
