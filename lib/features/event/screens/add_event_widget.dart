import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mayan/core/pallette/pallete.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/variables.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  TextEditingController _dateController = TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
  File? _selectedImage;
bool isSwitched=false;
  // Image picker function
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.97),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add Event',
          style: GoogleFonts.poppins(color: Colors.black,fontSize: 20 ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Name Input
            Card(
              child: TextField(
                autocorrect: false, // Prevents automatic underlining
                enableSuggestions: false,

                style: GoogleFonts.poppins(color: Colors.grey), // Text color and font
                decoration: InputDecoration(

                  focusedBorder: InputBorder.none,

                  labelText: 'Event name*',
                  labelStyle: GoogleFonts.poppins(color: Colors.grey), // Label text color
                  filled: true,
                  fillColor: Colors.white, // Background color (change if needed)
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,

                  ),
                ),
              ),
            )
,
            SizedBox(height: 16),

            // Notes Input
            Card(

              child: TextField(
                decoration: InputDecoration(

                  // border: InputBorder.none, // Removes underline and border
                  focusedBorder: InputBorder.none,

                  labelText: 'Type the note here...',
                  labelStyle: GoogleFonts.poppins(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,

                  ),
                ),
                maxLines: 3,
              ),
            ),
            SizedBox(height: 16),

            // Date Picker Input
            Card(
              child: TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  // Removes underline when inactive
                  focusedBorder: InputBorder.none,
                  labelStyle: GoogleFonts.poppins(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Date',
              
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today, color: Colors.grey),
                    onPressed: () => _selectDate(context),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Location Input
            Card(
              child: TextField(
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  labelStyle: GoogleFonts.poppins(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Add location',
              
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Add Image, Video, and Recording Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Add Image Button
                GestureDetector(
                  onTap: _pickImage,
                  child: Column(
                    children: [
                      Card(
                        child: Container(
                        
                          height: w*0.27,
                          width: w*0.27,
                          decoration: BoxDecoration(
                        
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                        
                            children: [
                              //Icon(Icons.image, color: Colors.blue),
                              Image.asset('assets/images/imagepicker.png', ),
                              Text(
                                'Add image',
                                style: GoogleFonts.poppins(color: Colors.grey,fontSize: w*0.032),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),

                    ],
                  ),
                ),

                // Add Video Button
                Column(
                  children: [
                    Card(
                      child: Container(
                        height: w*0.27,
                        width: w*0.27,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                      
                          children: [
                      
                            Image.asset('assets/images/video.png',height: 25,width: 25,color: Colors.grey, ),
                      
                            Text(
                              'Add video',
                              style: GoogleFonts.poppins(color: Colors.grey,fontSize: w*0.032),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                  ],
                ),

                // Add Recording Button
                Column(
                  children: [
                    Card(
                      child: Container(
                        height: w*0.27,
                        width: w*0.27,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                      
                          children: [
                            Icon(Icons.keyboard_voice_outlined, color: Colors.grey,size: 35,),
                            Text(
                              'Add recording',
                              style: GoogleFonts.poppins(color: Colors.grey,fontSize: w*0.032),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                  ],
                ),
              ],
            ),
            // SizedBox(height: 16),


            // Show selected image preview (if any)
            // if (_selectedImage != null) ...[
            //   SizedBox(height: 16),
            //   Text('Selected Image:'),
            //   SizedBox(height: 8),
            //   ClipRRect(
            //     borderRadius: BorderRadius.circular(12),
            //     child: Image.file(
            //       _selectedImage!,
            //       height: 150,
            //       width: double.infinity,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ],
            // SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                Icon(Icons.add, color: primaryColor),
                Text(
                  'Add new',
                  style: GoogleFonts.poppins(color: primaryColor,fontSize: w*0.032),
                )
              ],
            ),
            // Reminder Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Reminds me', style: GoogleFonts.poppins(color: Colors.black),
      ),
                Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                  thumbColor: MaterialStateProperty.all(Colors.white), // White button (thumb)
                  trackColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return primaryColor; // Change this to your primary color
                    }
                    return Colors.grey.shade300; // Transparent track when inactive
                  }),
                  trackOutlineColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return primaryColor; // Primary color outline when active
                    }
                    return Colors.white; // White outline when inactive
                  }),
                )

              ],
            ),
            SizedBox(height: 16),
            // Create Event Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle create event logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                ),
                child: Text('Create Event', style: GoogleFonts.poppins(fontSize: 16,color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}