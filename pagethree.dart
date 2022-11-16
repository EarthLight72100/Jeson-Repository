import 'dart:collection';
import 'package:flutter/material.dart';
import 'main.dart';
import 'pagetwo.dart';

//Event class used from https://github.com/aleksanderwozniak/table_calendar/blob/master/example/lib/utils.dart
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

class PageThreeState extends State<PageThree>{
<<<<<<< Updated upstream
  final _biggerFont = const TextStyle(fontSize: 18);
  String _value = " ";

  // In this example, the restoration ID for the mixin is passed in through
  // the [StatefulWidget]'s constructor.
  final RestorableDateTime _selectedDate =
  RestorableDateTime(DateTime(2021, 7, 25));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
  RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );
=======
  late final ValueNotifier<List<Event>> _selectedEvents;
  var _value = " ";
  var _calendarFormat = CalendarFormat.month;
  var _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff;
  //events = {}
  var events = new HashMap();
  //events[key] = value;
  var testList = [Event("Eat Pizza"), Event("Sneeze")];

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(GetEventsForDay(_selectedDay!));
  }

  List<Event> GetEventsForDay(DateTime day) {
    events[day] = testList;
    return events[day] ?? [];
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
>>>>>>> Stashed changes

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,)
  {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2021),
          lastDate: DateTime(2022),
        );
      },
    );
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
          'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
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
<<<<<<< Updated upstream
        body: Center(
          child: OutlinedButton(
          onPressed: () {
            _restorableDatePickerRouteFuture.present();
          },
          child: const Text('Open Date Picker'),
        ),
      ),
=======
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
>>>>>>> Stashed changes
    );
  }
}

class PageThree extends StatefulWidget {
  const PageThree({Key? key, required this.title}) : super(key: key);
  final String title;


  @override
  State<PageThree> createState() => PageThreeState();
}