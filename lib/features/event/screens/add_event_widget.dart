import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  File? _selectedImage;

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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add Event',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Name Input
            TextField(
              decoration: InputDecoration(
                labelText: 'Event name*',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Notes Input
            TextField(
              decoration: InputDecoration(
                labelText: 'Type the note here...',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),

            // Date Picker Input
            TextField(
              decoration: InputDecoration(
                labelText: 'Date',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
              ),
            ),
            SizedBox(height: 16),

            // Location Input
            TextField(
              decoration: InputDecoration(
                labelText: 'Add location',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
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
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.image, color: Colors.blue),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add image',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                // Add Video Button
                Column(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.videocam, color: Colors.blue),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add video',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                // Add Recording Button
                Column(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.mic, color: Colors.blue),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add recording',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            // Show selected image preview (if any)
            if (_selectedImage != null) ...[
              SizedBox(height: 16),
              Text('Selected Image:'),
              SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _selectedImage!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            SizedBox(height: 16),

            // Reminder Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Reminds me', style: TextStyle(fontSize: 16)),
                Switch(
                  value: false,
                  onChanged: (value) {
                    // Handle toggle state
                  },
                ),
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
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                ),
                child: Text('Create Event', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}