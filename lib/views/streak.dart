import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: StreakPage()));

class StreakPage extends StatefulWidget {
  const StreakPage({super.key});

  @override
  State<StreakPage> createState() => _StreakPageState();
}

class _StreakPageState extends State<StreakPage> {
  int streakCount = 40;
  
  int currentStep = 1;

  void _incrementStreak(int index) {
    setState(() {
      currentStep = index;
      //streakCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$streakCount days streak!",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const Text(
                        "This is what consistency looks like",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const Text("🔥", style: TextStyle(fontSize: 30)),
                ],
              ),
              const SizedBox(height: 30),

              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(height: 2, color: Colors.white10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                    children: [
                      _buildStreakNode(0, label: "31\ndec"),
                      _buildStreakNode(1, icon: Icons.directions_run),
                      _buildStreakNode(2, icon: Icons.ice_skating),
                      _buildStreakNode(3, icon: Icons.directions_bike),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreakNode(int index, {String? label, IconData? icon}) {
    bool isCompleted = index <= currentStep;
    bool isFirst = index == 0;

    return GestureDetector(
      onTap: () => _incrementStreak(index),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isFirst 
              ? const Color(0xFF3D5AFE) 
              : (isCompleted ? const Color(0xFF2E7D32) : const Color(0xFF2C2C2E)),
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, color: isCompleted ? Colors.white : Colors.white24, size: 20)
              : Text(
                  label!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}