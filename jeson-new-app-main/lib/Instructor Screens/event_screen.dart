import 'package:flutter/material.dart';
import 'package:jeson_flutter_app/size_config.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
    DateTime startDate = DateTime.now();
  bool startDirty = false;
  DateTime endDate = DateTime.now();
  bool endDirty = false;

  Future<void> _selectDate(BuildContext context, bool pickStart) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: (pickStart) ? startDate : endDate,
        firstDate: DateTime(2022, 8),
        lastDate: DateTime(2101));
    if (pickStart && picked != null && picked != startDate) {
      setState(() {
        startDirty = true;
        startDate = picked;
      });
    } else if (!pickStart && picked != null && picked != endDate) {
      setState(() {
        endDirty = true;
        endDate = picked;
      });
    }
  }

//   Future<void> _selectTime(BuildContext context, bool pickStart) async {
//     final DateTime? picked = await showTimePicker(
//         context: context,
//         initialTime: (pickStart) ? startDate : endDate,
//         // firstDate: DateTime(2022, 8),
//         // lastDate: DateTime(2101));
//     if (pickStart && picked != null && picked != startDate) {
//       setState(() {
//         startDirty = true;
//         startDate = picked;
//       });
//     } else if (!pickStart && picked != null && picked != endDate) {
//       setState(() {
//         endDirty = true;
//         endDate = picked;
//       });
//     });
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Event Screen")
        ),
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24.0))
                      ),
                      hintText: 'Event Name',
                    ),
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          height: 54,
                          width: SizeConfig.blockSizeHorizontal! * 40,
                          child: ElevatedButton(
                              onPressed: () {
                                _selectDate(context, true);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFAB63E7),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(24.0)))),
                              child: Text(
                              (!startDirty) ? 'Start Date' : "${startDate.month}/${startDate.day}/${startDate.year}",
                              style: const TextStyle(fontSize: 24),
                              ),
                          ),
                      ),
        
                      SizedBox(
                          height: 54,
                          width: SizeConfig.blockSizeHorizontal! * 40,
                          child: ElevatedButton(
                              onPressed: () {
                                _selectDate(context, false);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFAB63E7),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(24.0)))),
                              child: Text(
                              (!endDirty) ? 'End Date': "${endDate.month}/${endDate.day}/${endDate.year}",
                              style: const TextStyle(fontSize: 24),
                              ),
                          ),
                      ),
        
                      // TextButton(onPressed: () {
                      //   _selectDate(context, true);
                      // }, child: Text("Start Date")),
                      // TextButton(onPressed: () {
                      //   _selectDate(context, false);
                      // }, child: Text("End Date"))
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          height: 54,
                          width: SizeConfig.blockSizeHorizontal! * 40,
                          child: ElevatedButton(
                              onPressed: () {
                                _selectDate(context, true);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFAB63E7),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(24.0)))),
                              child: Text(
                              (!startDirty) ? 'Start Time' : "${startDate.month}/${startDate.day}/${startDate.year}",
                              style: const TextStyle(fontSize: 24),
                              ),
                          ),
                      ),
        
                      SizedBox(
                          height: 54,
                          width: SizeConfig.blockSizeHorizontal! * 40,
                          child: ElevatedButton(
                              onPressed: () {
                                _selectDate(context, false);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFAB63E7),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(24.0)))),
                              child: Text(
                              (!endDirty) ? 'End Time': "${endDate.month}/${endDate.day}/${endDate.year}",
                              style: const TextStyle(fontSize: 24),
                              ),
                          ),
                      ),
        
                      // TextButton(onPressed: () {
                      //   _selectDate(context, true);
                      // }, child: Text("Start Date")),
                      // TextButton(onPressed: () {
                      //   _selectDate(context, false);
                      // }, child: Text("End Date"))
                    ],
                  ),
                ],
            )
        ),
    );
  }
}