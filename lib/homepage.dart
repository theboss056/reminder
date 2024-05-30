import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Add_reminder.dart';
import 'service/database.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Stream? ReminderStream;

  getontheload() async {
    ReminderStream = await DatabaseMethods().getReminderDetails();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  final user = FirebaseAuth.instance.currentUser;

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

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

  Widget allReminderDetails() {
    return StreamBuilder(
        stream: ReminderStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 5, top: 5),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 15, top: 5, bottom: 5),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white30,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 250,
                                    child: Text(
                                      "🔴  " + ds["Remind"],
                                      style: const TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  Container(
                                    width: 250,
                                    child: Text(
                                      "Description:" + ds["Description"],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  Text(
                                    "Time:" + ds["Time"],
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        //other page for editing

                                        EditReminderDetail(ds["Id"]);
                                        _namecontroller.text = ds["Remind"];
                                        _namecontroller1.text =
                                            ds["Description"];
                                        _dateController.text = ds["Time"];
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        size: 20,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        await DatabaseMethods()
                                            .deleteReminderDetail(ds["Id"]);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: Colors.red,
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : Container(
                  child: Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Add Reminder"),
                      SizedBox(
                        height: 100,
                      ),
                      Container(
                          height: 200, child: Image.asset("assets/arrow.png"))
                    ],
                  )),
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade100,
        title: const Text("List of Reminders "),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Profile'),
                          onTap: () {
                            // Handle Profile option
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.info),
                          title: Text('About'),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(Icons.logout),
                          title: Text('Logout'),
                          onTap: () {
                            signOut();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          //endpopup
        ],
      ),
      // body: Text("${user!.email}"),
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
                  topLeft: Radius.circular(700),
                  bottomLeft: Radius.circular(300),
                  bottomRight: Radius.circular(700),
                  topRight: Radius.circular(300))),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              Expanded(child: allReminderDetails()),
            ],
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //for the animation of slide transition
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return addReminder();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future EditReminderDetail(String Id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
              content: Container(
            child: SingleChildScrollView(
              child: Column(children: [
                Text("Edit Reminder",
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
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic> updateInfo = {
                      "Remind": _namecontroller.text,
                      "Description": _namecontroller1.text,
                      "Time": _dateController.text,
                      "Id": Id,
                    };
                    await DatabaseMethods()
                        .updateReminderDetail(Id, updateInfo)
                        .then((value) {
                      Navigator.pop(context);
                    });
                  },
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    elevation: 8, // Adjust elevation here
                    shadowColor: Colors.blue.withOpacity(0.5), // Shadow color
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                ),
              ]),
            ),
          )));
}
