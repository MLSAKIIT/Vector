import 'package:flutter/material.dart';

class StepLeaderboard extends StatefulWidget {
  @override
  State<StepLeaderboard> createState() => _StepLeaderboardState();
}

class _StepLeaderboardState extends State<StepLeaderboard> {
  // 1. Track the selected period
  String selectedPeriod = "Week";

  // 2. Data maps for different periods
  final Map<String, List<Map<String, dynamic>>> allData = {
    "Week": [
      {"rank": 1, "name": "User 1", "steps": "16500", "status": "Top-1 for 6 days"},
      {"rank": 2, "name": "User 2", "steps": "16000", "status": "Top-10 for 6 days"},
    ],
    "Month": [
      {"rank": 1, "name": "User 2", "steps": "450,000", "status": "Monthly King"},
      {"rank": 2, "name": "User 5", "steps": "420,000", "status": "Rising Star"},
    ],
    "Year": [
      {"rank": 1, "name": "User 8", "steps": "5,200,000", "status": "All-Time Pro"},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Daily Step Challenge", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSegmentedControl(),
          const SizedBox(height: 10),
          Expanded(child: _buildLeaderboardList()),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _filterTab("Week"),
          _filterTab("Month"),
          _filterTab("Year"),
        ],
      ),
    );
  }

  Widget _filterTab(String label) {
    bool isActive = selectedPeriod == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // 3. Update the state when clicked
          setState(() {
            selectedPeriod = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF6B429C) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboardList() {
    // 4. Get the list based on selection
    final players = allData[selectedPeriod]!;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final user = players[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF8E54D3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text("# ${user['rank']}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(width: 30),
                  Text(user['name'], style: const TextStyle(color: Colors.white, fontSize: 18)),
                  const Spacer(),
                  Text("${user['steps']} steps", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Text(user['status'], style: TextStyle(color: Colors.white.withOpacity(0.8))),
            ],
          ),
        );
      },
    );
  }
}