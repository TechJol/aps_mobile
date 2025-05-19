import 'package:flutter/material.dart';

class LanguageSelection extends StatefulWidget {
  const LanguageSelection({super.key});

  @override
  _LanguageSelectionState createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  String? selectedLanguage;

  void _onLanguageSelected(String language) {
    setState(() {
      selectedLanguage = language;
    });
  }

  Widget _buildLanguageOption(String language, String assetPath) {
    final isSelected = selectedLanguage == language;

    return GestureDetector(
      onTap: () => _onLanguageSelected(language),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Color(0xFF661EFB) : Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Flag icon
            CircleAvatar(radius: 12, backgroundImage: AssetImage(assetPath)),
            SizedBox(width: 12),
            // Language text
            Expanded(
              child: Text(
                language,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Custom radio
            Container(
              width: 17,
              height: 17,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Color(0xFF661EFB) : Colors.grey,
                  width: 1,
                ),
                color: isSelected ? Color(0xFF661EFB) : Colors.transparent,
              ),
              child:
                  isSelected
                      ? Center(
                        child: Container(
                          width: 6.5,
                          height: 6.5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      )
                      : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Выберите язык",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Roboto',
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildLanguageOption("English", 'assets/icons/uk.png'),
            _buildLanguageOption("Русский", 'assets/icons/ru.png'),
            _buildLanguageOption("Кыргызча", 'assets/icons/kg.png'),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    selectedLanguage != null
                        ? () {
                          Navigator.pushNamed(context, '/home');
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF661EFB),
                  disabledBackgroundColor: Color(0xFFC7C8FF),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Далее",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
