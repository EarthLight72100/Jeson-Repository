import 'package:flutter/material.dart';
import 'package:jeson_flutter_app/size_config.dart';
import 'package:jeson_flutter_app/singleton.dart';
import 'edit_screen.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final _singleton = Singleton();

  TextEditingController nameController = TextEditingController();
  String frequency = "Once";

  DateTime startDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  bool startDirty = false;
  bool startTimeDirty = false;

  DateTime endDate = DateTime.now();
  TimeOfDay endTime = TimeOfDay.now();
  bool endDirty = false;
  bool endTimeDirty = false;

  Future<void> _selectDate(BuildContext context, bool pickStart) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: (pickStart) ? startDate : endDate,
        firstDate: DateTime(2022, 8),
        lastDate: DateTime(2101));
    if (pickStart && picked != null && picked != startDate) {
      if (mounted) setState(() {
        startDirty = true;
        startDate = picked;
      });
    } else if (!pickStart && picked != null && picked != endDate) {
      if (mounted) setState(() {
        endDirty = true;
        endDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool pickStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: (pickStart) ? startTime : endTime);
      if (pickStart && picked != null && picked != startTime) {
        if (mounted) setState(() {
          startTimeDirty = true;
          startTime = picked;
        });
      } else if (!pickStart && picked != null && picked != endTime) {
        if (mounted) setState(() {
          endTimeDirty = true;
          endTime = picked;
        });
      };
  }

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
                  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24.0))
                      ),
                      hintText: 'Event Name',
                    ),
                  )),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical! * 2,
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

                  SizedBox(
                    height: SizeConfig.blockSizeVertical! * 3,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          height: 54,
                          width: SizeConfig.blockSizeHorizontal! * 40,
                          child: ElevatedButton(
                              onPressed: () {
                                _selectTime(context, true);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFAB63E7),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(24.0)))),
                              child: Text(
                              (!startDirty) ? 'Start Time' : "${startTime.hour}:${(startTime.minute < 10) ? 0 : ''}${startTime.minute}",
                              style: const TextStyle(fontSize: 24),
                              ),
                          ),
                      ),
        
                      SizedBox(
                          height: 54,
                          width: SizeConfig.blockSizeHorizontal! * 40,
                          child: ElevatedButton(
                              onPressed: () {
                                _selectTime(context, false);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFAB63E7),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(24.0)))),
                              child: Text(
                              (!endDirty) ? 'End Time': "${endTime.hour}:${(endTime.minute < 10) ? 0 : ''}${endTime.minute}",
                              style: const TextStyle(fontSize: 24),
                              ),
                          ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical! * 3,
                  ),
                  Container(
                    width: SizeConfig.blockSizeHorizontal! * 100,
                    // color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        SizeConfig.blockSizeHorizontal! * 40, 
                        0, 
                        SizeConfig.blockSizeHorizontal! * 40,
                        0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        alignment: AlignmentDirectional.center,
                      dropdownColor: Color.fromARGB(255, 235, 235, 235),
                      value: "Once",
                      items: <DropdownMenuItem<String>>[
                        DropdownMenuItem(
                          value: 'Once',
                          child: Text(
                            'Once',
                            style: TextStyle(
                                color: Colors.grey.shade800, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DropdownMenuItem(
                            value: 'Weekly',
                            child: Text('Weekly',
                                style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.bold))),
                        DropdownMenuItem(
                            value: 'Monthly',
                            child: Text('Monthly',
                                style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.bold))),
                      ],
                      onChanged: (String? value) {
                        if (value != null) frequency = value;
                        // if (mounted) setState(() => _value = value!);
                        // // if (_value == "Classes") {
                        // //   Navigator.push(
                        // //     context,
                        // //     MaterialPageRoute(
                        // //         builder: (context) => PageTwo(credential: "98765")),
                        // //   ).then((value) => getCourses());
                        // // }
                        // if (_value == "Calendar") {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             const CalendarPage(credential: "98765")),
                        //   );
                        // }
                      },
                      ),
                    ),
                  ),
                  Container(
                      // color: Colors.red,
                      height: SizeConfig.blockSizeVertical! * 40,
                      width: SizeConfig.blockSizeHorizontal! * 100,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextField(
                          minLines: 15,
                          maxLines: 15,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(24.0))
                            ),
                            hintText: 'Course Description',
                          ),
                        )),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical! * 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: 54,
                        width: SizeConfig.blockSizeHorizontal! * 85,
                        child: ElevatedButton(
                            onPressed: () {
                              // Navigator.pushNamed(context, '/eventScreen');
                              EventEntry event = EventEntry(
                                name: nameController.text,
                                frequency: frequency,
                                startDate: startDate,
                                startTime: startTime,
                                endDate: endDate,
                                endTime: endTime,
                                );
                              _singleton.addEvent(event);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFAB63E7),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(24.0)))),
                            child: const Text(
                            'Done',
                            style: TextStyle(fontSize: 24),
                            ),
                        ),
                    ),
                  ),
                ],
            )
        ),
    );
  }
}