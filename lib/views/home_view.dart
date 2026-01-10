import 'package:flutter/material.dart';
import '../widgets/home_map_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F), // dark theme base
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ─── Header ─────────────────────────────────────
              const SizedBox(
                height: 60,
                child: Placeholder(color: Colors.purple),
              ),

              const SizedBox(height: 20),

              // ─── Streak Card ─────────────────────────────────
              const SizedBox(
                height: 110,
                child: Placeholder(color: Colors.orange),
              ),

              const SizedBox(height: 24),

              // ─── Weekly Progress ────────────────────────────
              const SizedBox(
                height: 180,
                child: Placeholder(color: Colors.blue),
              ),

              const SizedBox(height: 24),

              // ─── Today's Session Title ──────────────────────
              const SizedBox(
                height: 24,
                child: Placeholder(color: Colors.white),
              ),

              const SizedBox(height: 12),

              // ─── MAP WIDGET (REAL) ──────────────────────────
              const HomeMapWidget(),

              const SizedBox(height: 20),

              // ─── Stats Cards ─────────────────────────────────
              Row(
                children: const [
                  Expanded(
                    child: SizedBox(
                      height: 90,
                      child: Placeholder(color: Colors.teal),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 90,
                      child: Placeholder(color: Colors.lightBlue),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 90,
                      child: Placeholder(color: Colors.pink),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      // ─── Bottom Navigation ────────────────────────────────
      bottomNavigationBar: const SizedBox(
        height: 70,
        child: Placeholder(color: Colors.white24),
      ),
    );
  }
}
