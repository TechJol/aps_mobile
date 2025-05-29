// ignore_for_file: library_private_types_in_public_api

import 'package:aps_mobile/navigation_bar/add_account.dart';
import 'package:flutter/material.dart';

// Dummy Add Account Page
class AddAccountPage extends StatelessWidget {
  const AddAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Account')),
      body: Center(child: Text('Add Account Page')),
    );
  }
}

// Account Details Page
class AccountDetails extends StatelessWidget {
  final String accountName;

  const AccountDetails({super.key, required this.accountName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$accountName Details')),
      body: Center(child: Text('Details for $accountName')),
    );
  }
}

// Credit Card Widget
class CreditCardWidget extends StatelessWidget {
  final String bankName;
  final String balance;
  final VoidCallback onInfoPressed;

  const CreditCardWidget({
    super.key,
    required this.bankName,
    required this.balance,
    required this.onInfoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bankName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text('Balance', style: TextStyle(color: Colors.white70)),
              Text(
                balance,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: onInfoPressed,
          ),
        ),
      ],
    );
  }
}

// Accounts Page
class AccountsManagementPage extends StatefulWidget {
  const AccountsManagementPage({super.key});

  @override
  _AccountsManagementState createState() => _AccountsManagementState();
}

class _AccountsManagementState extends State<AccountsManagementPage> {
  int selectedIndex = 0;
  String selectedView = 'Spending';
  String selectedPeriod = 'Analytics';

  final List<String> viewOptions = ['Spending', 'Incoming', 'All'];

  void onItemTapped(int index) {
    if (index == 0) return;

    setState(() {
      selectedIndex = index;
      selectedView = viewOptions[index - 1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Accounts Management',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert_rounded, size: 30),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$12,450',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddAccount()),
                    );
                  },
                  icon: Icon(Icons.add, color: Colors.black),
                  label: Text(
                    'Add Account',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),

            // Credit cards
            CreditCardWidget(
              bankName: 'Bank A',
              balance: '\$7,800',
              onInfoPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountDetails(accountName: 'Bank A'),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            CreditCardWidget(
              bankName: 'Bank B',
              balance: '\$4,650',
              onInfoPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountDetails(accountName: 'Bank B'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_rounded),
            label: 'Accounts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_sharp),
            label: 'Spending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_circle_outline_sharp),
            label: 'Incoming',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart),
            label: 'All',
          ),
        ],
      ),
    );
  }
}
