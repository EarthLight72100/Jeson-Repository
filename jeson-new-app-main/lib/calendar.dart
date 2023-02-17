import 'dart:collection';
import 'package:flutter/material.dart';
import 'home.dart';
import 'classes.dart';
import 'package:table_calendar/table_calendar.dart';

//Event class used from https://github.com/aleksanderwozniak/table_calendar/blob/master/example/lib/utils.dart
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

class CalendarState extends State<CalendarPage>{
  late final ValueNotifier<List<Event>> _selectedEvents;
  var _value = " ";
  var _calendarFormat = CalendarFormat.month;
  var _focusedDay = DateTime.now();
  var _startingDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  //events = {}
  var _events = new HashMap();
  //events[key] = value;
  var testList = [Event("Eat Pizza"), Event("Sneeze")];

  //the below "getter" allows us to access the private information outside of the class
  get events{
    return this._events;
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    int id = GetID(_startingDay);
    _events[id] = testList;
    _selectedEvents = ValueNotifier(GetEventsForDay(_selectedDay!));
  }

  int GetID(DateTime day) {
    return day.day * 1000000 + day.month * 10000 + day.year;
  }

  List<Event> GetEventsForDay(DateTime day) {
    int temp = GetID(day);
    return _events[temp] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = GetEventsForDay(selectedDay);
    }
  }
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
                    MaterialPageRoute(builder: (context) => RandomWords(credential: "98765")),
                  );
                }
                if(_value == "Classes"){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PageTwo(credential: "98765")),
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
          onDaySelected: _onDaySelected,
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
          eventLoader: (day){
            return GetEventsForDay(day);
          },
        ),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key, required this.credential}) : super(key: key);
  final String credential;


  @override
  State<CalendarPage> createState() => CalendarState();
}
