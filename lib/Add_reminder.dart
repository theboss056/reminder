import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reminder/service/database.dart';
import 'package:random_string/random_string.dart';
import 'homepage.dart';

class addReminder extends StatefulWidget {
  const addReminder({super.key});

  @override
  State<addReminder> createState() => _addReminderState();
}

class _addReminderState extends State<addReminder> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _namecontroller1 = TextEditingController();
  //for date picking in calender
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade100,
        title: Text("Add Reminders"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context, MaterialPageRoute(builder: (context) => Homepage()));
            // Handle menu icon press
          },
        ),
      ),
      body: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.pink.shade100,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(900),
                  bottomLeft: Radius.circular(200),
                  bottomRight: Radius.circular(900),
                  topRight: Radius.circular(200))),
        ),
        Container(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(" Enter Reminder",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      maxLines: null,
                      controller: _namecontroller,
                      decoration: InputDecoration(
                          hintText: "remind me", border: InputBorder.none),
                    )),
                SizedBox(
                  height: 20,
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      maxLines: null,
                      controller: _namecontroller1,
                      decoration: InputDecoration(
                          hintText: "Description", border: InputBorder.none),
                    )),
                SizedBox(
                  height: 20,
                ),
                Text("Time",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: () async {
                      // Show date picker
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (selectedDate != null) {
                        // Show time picker if date is selected
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (selectedTime != null) {
                          // Combine date and time into a DateTime object
                          final DateTime selectedDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );

                          // Update the text field with the selected date and time
                          setState(() {
                            _dateController.text =
                                "${selectedDateTime.toLocal()}".split('.')[0];
                          });
                        }
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Select Date and Time',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      String Id = randomAlphaNumeric(10);
                      // Add functionality here
                      Map<String, dynamic> ReminderInfoMap = {
                        "Id": Id,
                        "Remind": _namecontroller.text,
                        "Description": _namecontroller1.text,
                        "Time": _dateController.text.toString(),
                      };
                      await DatabaseMethods()
                          .addReminderDetails(ReminderInfoMap, Id)
                          .then((value) {
                        Fluttertoast.showToast(
                            msg: "Reminder  has been added successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            // gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black54,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      });
                      Navigator.pop(context,
                          MaterialPageRoute(builder: (context) => Homepage()));
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white60,
                      elevation: 8,
                      // Adjust elevation here
                      shadowColor: Colors.pink.withOpacity(0.5), // Shadow color
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      textStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
