import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int i = 1;

  final icons = [
    'assets/icons/Vector.svg',
    'assets/icons/primary.svg',
    'assets/icons/SVGRepo_iconCarrier.svg',
    'assets/icons/Page_1.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Color(0x4D000000),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: List.generate(icons.length, (index) {
              final isActive = index == i;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => i = index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF7527AC)
                          : Colors.transparent,
                      borderRadius: BorderRadius.horizontal(
                        left: index == 0 && isActive
                            ? const Radius.circular(15)
                            : Radius.zero,
                        right: index == icons.length - 1 && isActive
                            ? const Radius.circular(15)
                            : Radius.zero,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        icons[index],
                        width: 22,
                        height: 22,
                        colorFilter: ColorFilter.mode(
                          isActive ? Colors.white : Colors.black,
                          BlendMode.srcIn,
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
