import 'package:flutter/material.dart';

class PopUpLessonContentWidget extends StatefulWidget {
  final Function(String, String, String, DateTime, TimeOfDay) onUpdate;

  const PopUpLessonContentWidget({Key? key, required this.onUpdate}) : super(key: key);

  @override
  PopUpLessonContentWidgetState createState() => PopUpLessonContentWidgetState();
}

class PopUpLessonContentWidgetState extends State<PopUpLessonContentWidget> {
  var discipline = 'Dressage';
  var place = "Indoor arena";
  var duration = "30 minutes";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField(
            value: discipline,
            onChanged: (String? newValue) {
              setState(() {
                discipline = newValue!;
              });
              widget.onUpdate(discipline, place, duration, selectedDate, selectedTime);
            },
            items: <String>['Dressage', 'Show Jumping', 'Endurance']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 20),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField(
            value: place,
            onChanged: (String? newValue) {
              setState(() {
                place = newValue!;
              });
              widget.onUpdate(discipline, place, duration, selectedDate, selectedTime);
            },
            items: <String>['Indoor arena', 'Outdoor arena']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 20),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField(
            value: duration,
            onChanged: (String? newValue) {
              setState(() {
                duration = newValue!;
              });
              widget.onUpdate(discipline, place, duration, selectedDate, selectedTime);
            },
            items: <String>['30 minutes', '1 hour']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 20),
                ),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                setState(() {
                  selectedDate = pickedDate;
                });
                widget.onUpdate(discipline, place, duration, selectedDate, selectedTime);
              }
            },
            child: Text(
              "Select date: ${selectedDate.toLocal().toString().split(' ')[0]}",
            ),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () async {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: selectedTime,
              );
              if (pickedTime != null) {
                setState(() {
                  selectedTime = pickedTime;
                });
              }
              widget.onUpdate(discipline, place, duration, selectedDate, selectedTime);
            },
            child: Text("Select time: ${selectedTime.format(context)}"),
          ),
        ],
      ),
    );
  }
}