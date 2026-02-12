import 'package:flutter/material.dart';

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  String sel = "Week"; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 60),
          _head(),
          _tabs(),
          _podium(),
          _list(),
        ],
      ),
      // Navigation bar property removed from here
    );
  }

  Widget _head() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
        const Text(" Back", style: TextStyle(color: Colors.white)),
        const Expanded(child: Center(child: Text("Leaderboard", 
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)))),
        const SizedBox(width: 60),
      ],
    ),
  );

  Widget _tabs() => Container(
    margin: const EdgeInsets.all(19),
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(color: const Color(0XFF5D4973), borderRadius: BorderRadius.circular(7)),
    child: Row(
      children: ["Week", "Month", "Year"].map((t) => _tabItem(t)).toList(),
    ),
  );

  Widget _tabItem(String t) {
    bool active = sel == t;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => sel = t),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF6A3D91) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(t, textAlign: TextAlign.center, 
            style: TextStyle(color: active ? Colors.white : Colors.white54, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _podium() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _bar("Sia", "12000", 130, 2),
        _bar("Ria", "13000", 170, 1),
        _bar("Lia", "11000", 110, 3),
      ],
    ),
  );

  Widget _bar(String n, String s, double h, int r) => Expanded(
    child: Column(
      children: [
        const Text("👑", style: TextStyle(fontSize: 20)),
        Text(n, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: const Color(0xFF9F4987).withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
          child: Text(s, style: const TextStyle(color: Colors.white, fontSize: 10)),
        ),
        const SizedBox(height: 8),
        Container(
          height: h, width: double.infinity, margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFAA4FA9).withOpacity(r == 1 ? 1 : 0.7),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          ),
          alignment: Alignment.center,
          child: Text("$r", style: const TextStyle(color: Colors.white24, fontSize: 40, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );

  Widget _list() => Expanded(
    child: Container(
      decoration: const BoxDecoration(color: Color(0xFF1F1135), borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 15,
        itemBuilder: (c, i) => _item(i + 4),
      ),
    ),
  );

  Widget _item(int r) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: const Color(0xFF8E52AE), borderRadius: BorderRadius.circular(15)),
    child: Row(
      children: [
        Text("#$r", style: const TextStyle(color: Colors.white70)),
        const SizedBox(width: 15),
        const Text("Rahul Singh", style: TextStyle(color: Colors.white)),
        const Spacer(),
        const Text("10k steps", style: TextStyle(color: Colors.white54, fontSize: 12)),
        Icon(r % 3 == 0 ? Icons.arrow_drop_down : Icons.arrow_drop_up, color: r % 3 == 0 ? Colors.red : Colors.green),
      ],
    ),
  );
}