import 'package:flutter/material.dart';
import 'main.dart';
import 'pagetwo.dart';

class PageThreeState extends State<PageThree>{
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
        body: Center(
          child: OutlinedButton(
          onPressed: () {
            _restorableDatePickerRouteFuture.present();
          },
          child: const Text('Open Date Picker'),
        ),
      ),
    );
  }
}

class PageThree extends StatefulWidget {
  const PageThree({Key? key, required this.title}) : super(key: key);
  final String title;


  @override
  State<PageThree> createState() => PageThreeState();
}