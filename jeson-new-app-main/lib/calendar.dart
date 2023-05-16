import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'Instructor Screens/edit_screen.dart';
import 'home.dart';
import 'classes.dart';
import 'utils.dart';
import 'singleton.dart';
import 'package:table_calendar/table_calendar.dart';

//Event class used from https://github.com/aleksanderwozniak/table_calendar/blob/master/example/lib/utils.dart
// class Event {
//   final String title;

//   const Event(this.title);

//   @override
//   String toString() => title;
// }

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key, required this.credential}) : super(key: key);
  final String credential;

  @override
  State<CalendarPage> createState() => CalendarState();
}

class CalendarState extends State<CalendarPage> {
  late final ValueNotifier<List<EventMeta>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  LinkedHashMap<DateTime, List<EventMeta>>? entries;

  @override
  void initState() {
    super.initState();
    final _singleton = Singleton();
    // print("TESTING: ${_singleton.classCache}");
    // final _amdreoEvents = { for (var item in _singleton.getEventsFromClasses()) DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5) : List.generate(
    //         item % 4 + 1, (index) => Event('Event $item | ${index + 1}')) };
    List<EventMeta> events = _singleton.getEventsFromClasses();
    Map<DateTime, List<EventMeta>> eventGroups = {};
    for (var item in events) {
      if (eventGroups[item.startDate!] == null) {
        eventGroups[item.startDate!] = [];
      }
      eventGroups[item.startDate!]!.add(item);
    }
    // print("EVENTS: $eventGroups");
    entries = LinkedHashMap<DateTime, List<EventMeta>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(eventGroups);
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<EventMeta> _getEventsForDay(DateTime day) {
    // Implementation example
    
    
    return entries![day] ?? [];
  }

  // List<EventEntry> _getEventsFromClasses() {
  //   final singleton = Singleton();
  //   List<EventEntry> result = [];
  //   for (int i = 0; i < singleton.classCache!.length; i++) {
  //     DataSnapshot item = singleton.classCache![i];
  //     for (final child in item.children) {
  //       if (child.key != "date" && child.key != "description" && child.key != "name") {
  //         print(child.key);
  //       }
  //     }
  //   }
  //   return result;
  // }

  List<EventMeta> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
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

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TableCalendar - Events'),
      ),
      body: Column(
        children: [
          TableCalendar<EventMeta>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<EventMeta>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // late final ValueNotifier<List<Event>> _selectedEvents;
  // var _value = " ";
  // var _calendarFormat = CalendarFormat.month;
  // var _focusedDay = DateTime.now();
  // var _startingDay = DateTime.now();
  // DateTime? _selectedDay;
  // DateTime? _rangeStart;
  // DateTime? _rangeEnd;
  // RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  // //events = {}
  // var _events = new HashMap();
  // //events[key] = value;
  // var testList = [Event("Eat Pizza"), Event("Sneeze")];

  // //the below "getter" allows us to access the private information outside of the class
  // get events {
  //   return this._events;
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _selectedDay = _focusedDay;
  //   int id = GetID(_startingDay);
  //   _events[id] = testList;
  //   _selectedEvents = ValueNotifier(GetEventsForDay(_selectedDay!));
  // }

  // int GetID(DateTime day) {
  //   return day.day * 1000000 + day.month * 10000 + day.year;
  // }

  // List<Event> GetEventsForDay(DateTime day) {
  //   int temp = GetID(day);
  //   return _events[temp] ?? [];
  // }

  // void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
  //   if (!isSameDay(_selectedDay, selectedDay)) {
  //     setState(() {
  //       _selectedDay = selectedDay;
  //       _focusedDay = focusedDay;
  //       _rangeStart = null; // Important to clean those
  //       _rangeEnd = null;
  //       _rangeSelectionMode = RangeSelectionMode.toggledOff;
  //     });

  //     _selectedEvents.value = GetEventsForDay(selectedDay);
  //   }
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       automaticallyImplyLeading: false,
  //       title: DropdownButton<String>(
  //         dropdownColor: const Color(0xFFAB63E7),
  //         value: "Calendar",
  //         items: const <DropdownMenuItem<String>>[
  //           DropdownMenuItem(
  //             value: 'Home',
  //             child: Text('Home',
  //                 style: TextStyle(
  //                     color: Colors.white, fontWeight: FontWeight.bold)),
  //           ),
  //           // DropdownMenuItem(
  //           //     child: const Text('Classes'),
  //           //     value: 'Classes'
  //           // ),
  //           DropdownMenuItem(
  //               value: 'Calendar',
  //               child: Text('Calendar',
  //                   style: TextStyle(
  //                       color: Colors.white, fontWeight: FontWeight.bold))),
  //         ],
  //         onChanged: (String? value) {
  //           setState(() => _value = value!);
  //           if (_value == "Home") {
  //             //TODO - jump to class page; fix the next few lines
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) =>
  //                       const HomeScreen(credential: "98765")),
  //             );
  //           }
  //           // if (_value == "Classes") {
  //           //   Navigator.push(
  //           //     context,
  //           //     MaterialPageRoute(
  //           //         builder: (context) => const PageTwo(credential: "98765")),
  //           //   );
  //           // }
  //         },
  //       ),
  //     ),
  //     body: TableCalendar(
  //       firstDay: DateTime.utc(2000, 01, 01),
  //       lastDay: DateTime.utc(2050, 12, 31),
  //       focusedDay: _focusedDay,
  //       calendarFormat: _calendarFormat,
  //       selectedDayPredicate: (day) {
  //         // Use `selectedDayPredicate` to determine which day is currently selected.
  //         // If this returns true, then `day` will be marked as selected.

  //         // Using `isSameDay` is recommended to disregard
  //         // the time-part of compared DateTime objects.
  //         return isSameDay(_selectedDay, day);
  //       },
  //       onDaySelected: _onDaySelected,
  //       onFormatChanged: (format) {
  //         if (_calendarFormat != format) {
  //           // Call `setState()` when updating calendar format
  //           setState(() {
  //             _calendarFormat = format;
  //           });
  //         }
  //       },
  //       onPageChanged: (focusedDay) {
  //         // No need to call `setState()` here
  //         _focusedDay = focusedDay;
  //       },
  //       eventLoader: (day) {
  //         return GetEventsForDay(day);
  //       },
  //     ),
  //   );
  // }
}
