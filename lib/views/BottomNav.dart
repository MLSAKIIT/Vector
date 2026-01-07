import 'package:flutter/material.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int selectedIndex = 0;

  final icons = [
    'assets/icons/Vector.png',
    'assets/icons/primary.png',
    'assets/icons/SVGRepo_iconCarrier.png',
    'assets/icons/Page_1.png',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40), // ✅ Figma radius
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(icons.length, (index) {
              final isActive = index == selectedIndex;

              return GestureDetector(
                onTap: () {
                  setState(() => selectedIndex = index);
                },
                child: SizedBox(
                  width: 40,
                  child: Center(
                    child: Container(
                      width: isActive ? 40 : 22,
                      height: isActive ? 36 : 22,
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF7527AC)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          icons[index],
                          width: 20,
                          height: 20,
                          color: isActive ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
