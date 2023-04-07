import 'package:flutter/material.dart';
import 'package:jeson_flutter_app/size_config.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a search term',
            ),
          ),
        ),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Container(
                    color: Colors.red,
                    height: SizeConfig.blockSizeVertical! * 20,
                    width: SizeConfig.blockSizeHorizontal! * 100,
                    child: Text("Insert form here"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      height: 54,
                      width: SizeConfig.blockSizeHorizontal! * 80,
                      child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFAB63E7),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(24.0)))),
                          child: const Text(
                          'Create Event',
                          style: TextStyle(fontSize: 24),
                          ),
                      ),
                  ),
                ),
                Container(
                    color: Colors.blue,
                    height: SizeConfig.blockSizeVertical! * 50,
                  child: ListView(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      scrollDirection: Axis.vertical,
                      children: [],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                          SizedBox(
                              height: 54,
                              width: SizeConfig.blockSizeHorizontal! * 40,
                              child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFAB63E7),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(24.0)))),
                                  child: const Text(
                                  'Cancel',
                                  style: TextStyle(fontSize: 24),
                                  ),
                              ),
                          ),
                          SizedBox(
                              height: 54,
                              width: SizeConfig.blockSizeHorizontal! * 40,
                              child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFAB63E7),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(24.0)))),
                                  child: const Text(
                                  'Save',
                                  style: TextStyle(fontSize: 24),
                                  ),
                              ),
                          ),
                      ],
                  ),
                )
                

            ],
        ),
    );
  }
}

class CourseForm extends StatefulWidget {
  const CourseForm({super.key});

  @override
  State<CourseForm> createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}