import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';
import 'package:runmates/features/main/program/program_day.dart';
import 'package:runmates/providers/prgram_provider.dart';

class ProgramWeekPage extends StatefulWidget {
  const ProgramWeekPage({super.key});

  @override
  State<ProgramWeekPage> createState() => _ProgramWeekPageState();
}

class _ProgramWeekPageState extends State<ProgramWeekPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProgramProvider>(context, listen: false).fetchProgramWeeks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.textSecondary,
        title: Text(
          'Program Latihan',
          style: AppTextStyles.heading4(
            weight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: AppColors.textSecondary),
        ),
      ),
      body: Container(
        color: AppColors.textSecondary,
        child: Consumer<ProgramProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(provider.errorMessage!, textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => provider.fetchProgramWeeks(),
                      child: const Text("Coba Lagi"),
                    ),
                  ],
                ),
              );
            }

            if (provider.weeks.isEmpty) {
              return const Center(
                child: Text("Belum ada program latihan. Silakan buat profil."),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              itemCount: provider.weeks.length,
              itemBuilder: (context, index) {
                final item = provider.weeks[index];
                final isLastItem = index == provider.weeks.length - 1;

                return Padding(
                  padding: EdgeInsets.only(bottom: isLastItem ? 80.0 : 10.0),
                  child: SizedBox(
                    height: 164,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProgramDayPage(
                              weekNumber: item.weekNumber,
                              totalWeeks: provider.weeks.length,
                              weekId: item.id,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 5,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                item.description ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),

                          if (item.title != null) ...[
                            Text(
                              item.title!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
