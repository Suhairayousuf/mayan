import 'package:flutter/material.dart';

class EventDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // Adjusting app bar height
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.teal, // Setting the teal color for the app bar
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Title and Date
            Text(
              'Event title here',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
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
            SizedBox(height: 24),

            // Description
            Text(
              'Description',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Images Section
            _buildSectionHeader('Images', context),
            SizedBox(height: 8),
            _buildImageRow(),

            SizedBox(height: 24),

            // Videos Section
            _buildSectionHeader('Videos', context),
            SizedBox(height: 8),
            _buildVideoRow(),

            SizedBox(height: 24),

            // Recordings Section
            _buildSectionHeader('Recordings', context),
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

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
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
    );
  }

  Widget _buildImageRow() {
    return Row(
      children: [
        _buildMediaCard('assets/image1.jpg'),
        SizedBox(width: 8),
        _buildMediaCard('assets/image2.jpg'),
      ],
    );
  }

  Widget _buildVideoRow() {
    return Row(
      children: [
        _buildMediaCard('assets/video1.jpg'),
        SizedBox(width: 8),
        _buildMediaCard('assets/video2.jpg'),
        SizedBox(width: 8),
        _buildMediaCard('assets/video3.jpg'),
      ],
    );
  }

  Widget _buildRecordingRow() {
    return Row(
      children: [
        _buildAudioCard('Audio 1'),
        SizedBox(width: 8),
        _buildAudioCard('Audio 2'),
      ],
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