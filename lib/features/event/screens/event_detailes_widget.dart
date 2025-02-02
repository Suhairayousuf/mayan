import 'package:flutter/material.dart';
import 'package:mayan/core/pallette/pallete.dart';

import '../../../core/constants/variables.dart';

class EventDetailsPage extends StatefulWidget {
  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.97),

      extendBody: true,
      // extendBodyBehindAppBar: true,
      // backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // Adjusting app bar height
        child: AppBar(
          elevation: 0,
          backgroundColor: primaryColor, // Setting the teal color for the app bar
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Event details',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.calendar_today, color: Colors.white),
              onPressed: () {
                // Calendar action
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          // padding: const EdgeInsets.only(top: 90.0),

        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Title and Date
            Container(
              width: double.infinity,
              height: 100,
              color: primaryColor,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    'Event title here',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '12 August 2024',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Description

            SizedBox(height: 8),
            Card(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Images Section
            // _buildSectionHeader('Images', context),
            SizedBox(height: 8),
            _buildImageRow(),

            SizedBox(height: 24),

            // Videos Section
            // _buildSectionHeader('Videos', context),
            SizedBox(height: 8),
            _buildVideoRow(),

            SizedBox(height: 24),

            // Recordings Section
            // _buildSectionHeader('Recordings', context),
            SizedBox(height: 8),
            _buildRecordingRow(),

            SizedBox(height: 24),

            // Delete and Edit Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Delete action
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                  label: Text(
                    'Delete',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Edit action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  icon: Icon(Icons.edit, color: Colors.white),
                  label: Text(
                    'Edit',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildSectionHeader(String title, BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(
  //         title,
  //         style: TextStyle(
  //           fontFamily: 'Poppins',
  //           fontWeight: FontWeight.bold,
  //           fontSize: 16,
  //           color: Colors.black,
  //         ),
  //       ),
  //       IconButton(
  //         onPressed: () {
  //           // Add new action
  //         },
  //         icon: Icon(Icons.add_circle_outline, color: Colors.grey[600]),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildImageRow() {
    return Card(
      child: Container(
        color: Colors.white,
        height: 150,
        child: Column(
          children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Images',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                // Add new action
              },
              icon: Icon(Icons.add_circle_outline, color: Colors.grey[600]),
            ),
          ],
        ),

            Row(
              children: [
                _buildMediaCard('assets/image1.jpg'),
                SizedBox(width: 8),
                _buildMediaCard('assets/image2.jpg'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoRow() {
    return Card(
      child: Container(
        color: Colors.white,
        height: 150,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Videos',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Add new action
                  },
                  icon: Icon(Icons.add_circle_outline, color: Colors.grey[600]),
                ),
              ],
            ),

            Row(
              children: [
                _buildMediaCard('assets/video1.jpg'),
                SizedBox(width: 8),
                _buildMediaCard('assets/video2.jpg'),
                SizedBox(width: 8),
                _buildMediaCard('assets/video3.jpg'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordingRow() {
    return Card(
      child: Container(
        color: Colors.white,
        height: 150,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Videos',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Add new action
                  },
                  icon: Icon(Icons.add_circle_outline, color: Colors.grey[600]),
                ),
              ],
            ),

            Row(
              children: [

                _buildAudioCard('Audio 1'),
                SizedBox(width: 8),
                _buildAudioCard('Audio 2'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaCard(String assetPath) {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage(assetPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAudioCard(String title) {
    return Container(
      height: 80,
      width: 120,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.audiotrack, color: Colors.teal),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}