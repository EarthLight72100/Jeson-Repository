import 'package:flutter/material.dart';
import 'main.dart';
import 'pagetwo.dart';
import 'package:table_calendar/table_calendar.dart';

class PageThreeState extends State<PageThree>{
  String _value = " ";
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;


  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
            title: DropdownButton<String>(
              value: "Calendar",
              items: <DropdownMenuItem<String>>[
                DropdownMenuItem(
                  child: const Text('Home'),
                  value: 'Home',
                ),
                DropdownMenuItem(
                    child: const Text('Classes'),
                    value: 'Classes'
                ),
                DropdownMenuItem(
                    child: const Text('Calendar'),
                    value: 'Calendar'
                ),
              ],

              onChanged: (String? value) {
                setState(() => _value = value!);
                if(_value == "Home"){
                  //TODO - jump to class page; fix the next few lines
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RandomWords(title: "Home")),
                  );
                }
                if(_value == "Classes"){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PageTwo(title: "My Classes")),
                  );
                }
              },
            ),
        ),
        body: TableCalendar(
          firstDay: DateTime.utc(2000, 01, 01),
          lastDay: DateTime.utc(2050, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            // Use `selectedDayPredicate` to determine which day is currently selected.
            // If this returns true, then `day` will be marked as selected.

            // Using `isSameDay` is recommended to disregard
            // the time-part of compared DateTime objects.
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              // Call `setState()` when updating the selected day
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            }
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              // Call `setState()` when updating calendar format
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            // No need to call `setState()` here
            _focusedDay = focusedDay;
          },

        )
    );
  }
}

class PageThree extends StatefulWidget {
  const PageThree({Key? key, required this.title}) : super(key: key);
  final String title;


  @override
  State<PageThree> createState() => PageThreeState();
}