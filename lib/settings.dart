import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool expandOperations = false;
  bool expandReports = false;
  bool expandSettings = false;

  Widget buildMainButton(
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isExpanded = false,
    bool expandable = true,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ??
                (expandable && isExpanded
                    ? const Color(0xFFC7C8FF)
                    : const Color(0xFFF3F4F7)),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            minimumSize: const Size(315, 68),
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          onPressed: onTap,
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 14)),
              ),
              if (expandable)
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_down,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSubButton(
    String title,
    IconData? icon, {
    bool isTop = false,
    bool isBottom = false,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 315,
        minHeight: 58,
      ),
      child: Container(
        margin: EdgeInsets.only(
          left: 38,
          right: 38,
          top: isTop ? 4 : 0,
          bottom: isBottom ? 8 : 0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.vertical(
            top: isTop ? const Radius.circular(12) : Radius.zero,
            bottom: isBottom ? const Radius.circular(12) : Radius.zero,
          ),
        ),
        width: double.infinity,
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 10),
            ],
            Text(title, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: Padding(
          padding: const EdgeInsets.only(left: 35.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Transform.translate(
          offset: const Offset(-60, 0),
          child: const Text('Settings'),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),

          /// All Operations
          buildMainButton(
            'All Operations',
            Icons.dashboard,
            () {
              setState(() => expandOperations = !expandOperations);
            },
            isExpanded: expandOperations,
          ),
          if (expandOperations) ...[
            const SizedBox(height: 10),
            buildSubButton('All Transactions', null, isTop: true),
            buildSubButton('On Agents', null),
            buildSubButton('On Accounts', null, isBottom: true),
          ],

          /// Reports
          buildMainButton(
            'Reports',
            Icons.bar_chart,
            () {
              setState(() => expandReports = !expandReports);
            },
            isExpanded: expandReports,
          ),
          if (expandReports) ...[
            const SizedBox(height: 10),
            buildSubButton('Reports on Articles', null, isTop: true),
            buildSubButton('Total', null),
            buildSubButton('Monthly', null),
            buildSubButton('Indicators', null, isBottom: true),
          ],

          /// Settings
          buildMainButton(
            'Settings',
            Icons.settings,
            () {
              setState(() => expandSettings = !expandSettings);
            },
            isExpanded: expandSettings,
          ),
          if (expandSettings) ...[
            const SizedBox(height: 0),
            buildSubButton('Agents', null, isTop: true),
            buildSubButton('Types of Agents', null),
            buildSubButton('Accounts', null),
            buildSubButton('Articles', null, isBottom: true),
          ],

          /// Exit Button
          buildMainButton(
            'Exit',
            Icons.exit_to_app,
            () => Navigator.pop(context),
            expandable: false,
            color: Colors.grey.shade200,
          ),

          /// Batken Alga Button
          buildMainButton(
            'Batken Alga!!!',
            Icons.person,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserInfoPage(),
                ),
              );
            },
            expandable: false,
            color: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }
}

/// Dummy user info page
class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Information')),
      body: const Center(
        child: Text(
          'User info for Batken Alga goes here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
