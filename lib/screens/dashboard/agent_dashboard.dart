import 'package:flutter/material.dart';

class AgentDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agent Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Handle logout
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Agent!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Your tasks for today:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.business),
                    title: Text('Manage Establishments'),
                    subtitle: Text('View and update establishment information'),
                    onTap: () {
                      Navigator.pushNamed(context, '/establishment-list');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.assignment),
                    title: Text('Pending Requests'),
                    subtitle: Text('Review and process pending requests'),
                    onTap: () {
                      // Navigate to pending requests screen
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Notifications'),
                    subtitle: Text('View recent notifications'),
                    onTap: () {
                      // Navigate to notifications screen
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
