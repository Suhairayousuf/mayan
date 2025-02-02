import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:mayan/core/pallette/pallete.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:upgrader/upgrader.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/variables.dart';
import '../../../core/utils/utils.dart';
import '../../event/screens/add_event_widget.dart';
import '../../event/screens/event_detailes_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _events = {
    DateTime(2024, 8, 12): ['Event name', 'Event name', 'Event name', 'Event name'],
    DateTime(2024, 8, 9): ['Another Event'],
  };

  List<String> _getEventsForDay(DateTime date) {
    return _events[date] ?? [];
  }
  // DateTime currentDate= DateTime(2024, 09 ,24);
  //
  // Future<void> checkDate(BuildContext context, DateTime currentDate) async {
  //   // Check if more than or equal to 30 days have passed
  //   if (DateTime.now().difference(currentDate).inDays >= 0) {
  //     // Show the dialog
  //     await showDialog(
  //       barrierDismissible: true,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text("Blocked"),
  //           content: Text("Please contact Admin"),
  //           actions: [
  //             TextButton(
  //               child: Text('Cancel'),
  //               onPressed: () {
  //                 SystemNavigator.pop();
  //                 },  // Close the dialog
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   // Accessing context-dependent data is safe here
  //   checkDate(context,currentDate);
  //
  // }
  bool convert = false;
  bool _isLoading = false;
  File? _selectedFile;
  double _progress = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkDate();
  }

  @override
  Widget build(BuildContext context) {

    w=MediaQuery.of(context).size.width;
    h=MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you really want to Exit?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: ()=> Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        );
        return shouldPop ?? false;

      },
      child: UpgradeAlert(
        child:  Scaffold(
          // backgroundColor: Colors.white,
          // appBar: AppBar(
          //   title: Text("Events"),
          //   backgroundColor: Colors.teal,
          // ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          blurRadius: 6, // Spread of the shadow
                          offset: Offset(0, 3), // Position of the shadow (horizontal, vertical)
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Find your events',
                        hintStyle: GoogleFonts.poppins(fontSize: 15),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 35,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TableCalendar(
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2050),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    calendarFormat: CalendarFormat.month,
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    eventLoader: _getEventsForDay,
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronIcon: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                        ),
                        child: Icon(Icons.arrow_back_ios, size: 16),
                      ),
                      rightChevronIcon: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                        ),
                        child: Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(color: Colors.black),
                      weekendStyle: TextStyle(color: Colors.black), // Default for weekends
                      dowTextFormatter: (date, locale) {
                        final shortNames = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
                        return shortNames[date.weekday % 7];
                      },
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      defaultTextStyle: TextStyle(color: Colors.black), // Default text for all days
                      weekendTextStyle: TextStyle(
                        color: Colors.black, // Default for Saturday
                      ),
                      // Sunday specific style
                      holidayTextStyle: TextStyle(color: primaryColor),
                      markersAutoAligned: false,
                    ),
                  ),



                  SizedBox(height: 16),
                  Text(
                    "Events",
                    style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      // itemCount: _getEventsForDay(_selectedDay ?? DateTime.now()).length,
                      itemCount:5,
                      itemBuilder: (context, index) {
                        // final event = _getEventsForDay(_selectedDay ?? DateTime.now())[index];
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>EventDetailsPage()));

                          },
                          child: Card(
                            color: Colors.white,
                            child: ListTile(
                              title:Text('Event name'),
                              subtitle: Text(DateTime.now().toString()),
                              // title: Text(event),
                              // subtitle: Text(
                              //   "${_selectedDay?.day ?? DateTime.now().day} "
                              //       "${_selectedDay?.month ?? DateTime.now().month} ${_selectedDay?.year ?? DateTime.now().year}",
                              // ),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEventPage()),
              );
              // Add event action
            },
            child: Icon(Icons.add, size: 25,color: Colors.white,), // Adjust the size if needed
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50), // Ensures it's circular
            ),
            elevation: 4, // Adds shadow for a floating effect
          ),
        ),



        ),
      );

  }
}
