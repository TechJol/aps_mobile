import 'package:aps_mobile/settings.dart';
import 'package:flutter/material.dart';
import 'package:aps_mobile/navigation_bar/BottomNavigationBar.dart';

class HomePageM extends StatefulWidget {
  const HomePageM({super.key});

  @override
  _HomePageMState createState() => _HomePageMState();
}

class _HomePageMState extends State<HomePageM> {
  int selectedIndex = 0;
  String selectedView = 'Spending';
  String selectedPeriod = 'Аналитика';

  final List<String> viewOptions = ['Расходы', 'Доход', 'Общий'];
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
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert_rounded, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings()),
              );
              // Navigate to settings
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          children: [
            // Top Section
            Container(
              height: 215,
              width: 335,
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
                      Transform.translate(
                        offset: Offset(-25, 70), // x: right (+), y: up (-)
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,
                          ),
                          padding: EdgeInsets.all(5),
                          child: Icon(Icons.arrow_back_ios_rounded, size: 20),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(-110, -13),
                        child: Text(
                          //analytics text
                          selectedPeriod,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(25, 70), // x: right (+), y: up (-)
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,
                          ),
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(height: 10),

                  // Pie Chart with Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Transform.translate(
                        offset: Offset(12, 3), // Slight shift to right
                        child: CustomPaint(
                          size: Size(106, 106),
                          painter: PieChartPainter(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 35),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.purpleAccent,
                                  radius: 5,
                                ),
                                SizedBox(width: 6),
                                Text('Аренда'),
                              ],
                            ),
                            SizedBox(height: 7),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blueAccent,
                                  radius: 5,
                                ),
                                SizedBox(width: 6),
                                Text('Зарплата'),
                              ],
                            ),
                            SizedBox(height: 7),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.purple,
                                  radius: 5,
                                ),
                                SizedBox(width: 6),
                                Text('Прочие расходы'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 18),

                  // Period Filter Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        periodOptions.map((period) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            child: GestureDetector(
                              onTap: () => selectPeriod(period),
                              child: Text(
                                period,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  color:
                                      selectedPeriod == period
                                          ? Colors.black
                                          : Colors.grey,
                                ),
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
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header and "View all"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        viewOptions.map((view) {
                          IconData icon;
                          switch (view) {
                            case 'Расходы': //
                              icon = Icons.arrow_back;
                              //icon = Icons.arrow_right;
                              break;
                            case 'Доход': //
                              icon = Icons.arrow_back;
                              break;
                            case 'Общий': //
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
                                    backgroundColor:
                                        selectedView == view
                                            ? Colors.black
                                            : Colors.white,
                                    foregroundColor:
                                        selectedView == view
                                            ? Colors.white
                                            : Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: Icon(icon, size: 20),
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ), // Add spacing here (adjust as needed)
                              Text(
                                view,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  color:
                                      selectedView == view
                                          ? Colors.black
                                          : Colors.black,
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
    final double strokeWidth = 9;
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Paint paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    final double gap = 0.27; // small angular gap in radians

    // Define the sweep angles (sum close to 2π = 6.28)
    final double sweep1 = 2.0;
    final double sweep2 = 2.1;
    final double sweep3 = 2.18;

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
