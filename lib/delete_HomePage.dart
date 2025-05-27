import 'package:flutter/material.dart';
import 'package:aps_mobile/settings.dart';
import 'package:aps_mobile/navigation_bar/bottom_navigation_bar.dart';

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

  void onItemTapped(int index) => setState(() => selectedIndex = index);
  void selectView(String view) => setState(() => selectedView = view);
  void selectPeriod(String period) => setState(() => selectedPeriod = period);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Привет, Aяна',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, size: 30),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Settings()),
                ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            _buildTopCard(),
            const SizedBox(height: 20),
            _buildViewOptions(),
            const SizedBox(height: 20),
            _buildOperationsHeader(),
            const SizedBox(height: 8),
            const Text(
              'Today --------------------------------------',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: Text(
                  '$selectedView view content goes here',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
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

  Widget _buildTopCard() {
    return Container(
      height: 208,
      width: 325,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPeriodNavigation(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: CustomPaint(
                  size: const Size(100, 100),
                  painter: PieChartPainter(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _LegendItem(color: Colors.purpleAccent, label: 'Rent'),
                    SizedBox(height: 6),
                    _LegendItem(color: Colors.blueAccent, label: 'Payment'),
                    SizedBox(height: 6),
                    _LegendItem(color: Colors.purple, label: 'Other'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                periodOptions.map((period) {
                  return GestureDetector(
                    onTap: () => selectPeriod(period),
                    child: Text(
                      period,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            selectedPeriod == period
                                ? Colors.black
                                : Colors.grey,
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _circleIcon(Icons.arrow_back_ios_rounded),
        Text(
          selectedPeriod,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        _circleIcon(Icons.arrow_forward_ios_rounded),
      ],
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade200,
      ),
      padding: const EdgeInsets.all(5),
      child: Icon(icon, size: 20),
    );
  }

  Widget _buildViewOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          viewOptions.map((view) {
            IconData icon = switch (view) {
              'Spending' => Icons.arrow_back,
              'Incoming' => Icons.arrow_back,
              'All' => Icons.stacked_bar_chart,
              _ => Icons.help_outline,
            };
            bool selected = selectedView == view;

            return Column(
              children: [
                SizedBox(
                  width: 103,
                  height: 43,
                  child: ElevatedButton(
                    onPressed: () => selectView(view),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selected ? Colors.black : Colors.white,
                      foregroundColor: selected ? Colors.white : Colors.black,
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
                    color: selected ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }

  Widget _buildOperationsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          'Operations',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text(
              'view all',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: color, radius: 5),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}

class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final double gap = 0.05;
    final sweeps = [2.0, 2.1, 2.05];
    final colors = [
      Colors.purpleAccent,
      Colors.blueAccent,
      Colors.deepPurpleAccent,
    ];

    double start = 0.0;
    for (int i = 0; i < sweeps.length; i++) {
      paint.color = colors[i];
      canvas.drawArc(rect, start, sweeps[i] - gap, false, paint);
      start += sweeps[i];
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
