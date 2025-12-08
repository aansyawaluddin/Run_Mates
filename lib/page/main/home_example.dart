import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runmates/providers/auth_provider.dart';
import 'package:runmates/providers/program_provider.dart';

/// Contoh implementasi HomePage dengan menggunakan ProgramProvider dan AuthProvider
class HomePageExample extends StatefulWidget {
  const HomePageExample({super.key});

  @override
  State<HomePageExample> createState() => _HomePageExampleState();
}

class _HomePageExampleState extends State<HomePageExample> {
  @override
  void initState() {
    super.initState();
    // Fetch programs saat halaman pertama kali load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProgramProvider>().fetchPrograms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header dengan user info
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return FlexibleSpaceBar(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${authProvider.user?.name ?? "User"}!',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ready to run today?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0XFFFF5050),
                          const Color(0XFFFF5050).withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Content dengan list program
          Consumer<ProgramProvider>(
            builder: (context, programProvider, _) {
              if (programProvider.isLoading) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          'Loading programs...',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (programProvider.programs.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_run_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No programs available',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final program = programProvider.programs[index];

                  return GestureDetector(
                    onTap: () {
                      programProvider.selectProgram(program);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selected: ${program.title}')),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header dengan title dan status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    program.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (program.isCompleted)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'Completed',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Description
                            Text(
                              program.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Program details
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Distance
                                Column(
                                  children: [
                                    Icon(
                                      Icons.directions_run,
                                      color: const Color(0XFFFF5050),
                                      size: 24,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${program.distance} km',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),

                                // Duration
                                Column(
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      color: const Color(0XFFFF5050),
                                      size: 24,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${program.totalDuration.inMinutes} min',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),

                                // Days per week
                                Column(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: const Color(0XFFFF5050),
                                      size: 24,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${program.weekSchedule.length}x/week',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Week schedule
                            Text(
                              'Schedule: ${program.weekSchedule.join(", ")}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Action buttons
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      // View details
                                    },
                                    child: const Text('View Details'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: !program.isCompleted
                                        ? () {
                                            programProvider.completeProgram(
                                              program.id,
                                            );
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  '✓ ${program.title} completed!',
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0XFFFF5050),
                                    ),
                                    child: Text(
                                      program.isCompleted
                                          ? 'Completed'
                                          : 'Mark Done',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }, childCount: programProvider.programs.length),
              );
            },
          ),
        ],
      ),
    );
  }
}
