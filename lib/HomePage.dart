import 'package:aps_mobile/settings.dart';
import 'package:flutter/material.dart';
import 'package:aps_mobile/navigation_bar/BottomNavigationBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String selectedView = 'Spending';
  String selectedPeriod = 'Analytics';

  final List<String> viewOptions = ['Spending', 'Incoming', 'All'];
  final List<String> periodOptions = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void selectView(String view) {
    setState(() {
      selectedView = view;
    });
  }

  void selectPeriod(String period) {
    setState(() {
      selectedPeriod = period;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'La hawla...',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert_rounded, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Settings(),
                ),
              );
              // Navigate to settings
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            // Top Section
            Container(
              height: 208,
              width: 325,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20), // Rounded edges
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Period Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                        ),
                        padding: EdgeInsets.all(5),
                        child: Icon(Icons.arrow_back_ios_rounded, size: 20),
                      ),
                      Text(
                        selectedPeriod,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                        ),
                        padding: EdgeInsets.all(5),
                        child: Icon(Icons.arrow_forward_ios_rounded, size: 20),
                      ),
                    ],
                  ),
                  //SizedBox(height: 10),

                  // Pie Chart with Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25), // Slight shift to right
                        child: CustomPaint(
                          size: Size(100, 100),
                          painter: PieChartPainter(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                    backgroundColor: Colors.purpleAccent,
                                    radius: 5),
                                SizedBox(width: 6),
                                Text('Rent'),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                CircleAvatar(
                                    backgroundColor: Colors.blueAccent,
                                    radius: 5),
                                SizedBox(width: 6),
                                Text('Payment'),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                CircleAvatar(
                                    backgroundColor: Colors.purple, radius: 5),
                                SizedBox(width: 6),
                                Text('Other'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  // Period Filter Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: periodOptions.map((period) {
                      return GestureDetector(
                        onTap: () => selectPeriod(period),
                        child: Text(
                          period,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: selectedPeriod == period
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Operations Section     BOTTOM PART
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header and "View all"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: viewOptions.map((view) {
                      IconData icon;
                      switch (view) {
                        case 'Spending':
                          icon = Icons.arrow_back;
                          //icon = Icons.arrow_right;
                          break;
                        case 'Incoming':
                          icon = Icons.arrow_back;
                          break;
                        case 'All':
                          icon = Icons.stacked_bar_chart;
                          break;
                        default:
                          icon = Icons.help_outline;
                      }

                      return Column(
                        children: [
                          SizedBox(
                            width: 103,
                            height: 43,
                            child: ElevatedButton(
                              onPressed: () => selectView(view),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedView == view
                                    ? Colors.black
                                    : Colors.white,
                                foregroundColor: selectedView == view
                                    ? Colors.white
                                    : Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Icon(icon, size: 20),
                            ),
                          ),
                          Text(
                            view,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selectedView == view
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Operations',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'view all',
                            style: TextStyle(
                              fontSize: 15,
                              //color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            //color: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Today --------------------------------------',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Content Display
            Expanded(
              child: Center(
                child: Text(
                  '$selectedView view content goes here',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
      /*  bottomNavigationBar: SizedBox(
        //height: 120,
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: selectedIndex,
            onTap: onItemTapped,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper_rounded), label: 'Accounts'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline_sharp),
                  label: 'Spending'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.remove_circle_outline_sharp),
                  label: 'Incoming'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.stacked_bar_chart), label: 'All'),
            ],
          ),*/
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 12;
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final double gap = 0.05; // small angular gap in radians

    // Define the sweep angles (sum close to 2π = 6.28)
    final double sweep1 = 2.0;
    final double sweep2 = 2.1;
    final double sweep3 = 2.05;

    double currentStart = 0.0;

    // Red Segment
    paint.color = Colors.purpleAccent;
    canvas.drawArc(rect, currentStart, sweep1 - gap, false, paint);
    currentStart += sweep1;

    // Green Segment
    paint.color = Colors.blueAccent;
    canvas.drawArc(rect, currentStart, sweep2 - gap, false, paint);
    currentStart += sweep2;

    // Blue Segment
    paint.color = Colors.deepPurpleAccent;
    canvas.drawArc(rect, currentStart, sweep3 - gap, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
