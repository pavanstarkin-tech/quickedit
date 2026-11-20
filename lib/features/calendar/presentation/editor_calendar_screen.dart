import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class EditorCalendarScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const EditorCalendarScreen({super.key, this.onBack});

  @override
  State<EditorCalendarScreen> createState() => _EditorCalendarScreenState();
}

class _EditorCalendarScreenState extends State<EditorCalendarScreen> {
  int _selectedDayIndex = 3; // Thursday Nov 14 (Screen 10)

  final List<Map<String, dynamic>> _weekDays = [
    {'day': 'Mon', 'date': '11'},
    {'day': 'Tue', 'date': '12'},
    {'day': 'Wed', 'date': '13'},
    {'day': 'Thu', 'date': '14'},
    {'day': 'Fri', 'date': '15'},
    {'day': 'Sat', 'date': '16'},
    {'day': 'Sun', 'date': '17'},
  ];

  final List<Map<String, dynamic>> _hourlySlots = [
    {'time': '09:00 AM', 'title': 'Raw Footage Import & Ingestion', 'type': 'editing', 'color': AppColors.primaryOrange},
    {'time': '10:30 AM', 'title': 'Client Discovery Call — D2C Reel', 'type': 'call', 'color': Color(0xFFD4A373)},
    {'time': '12:00 PM', 'title': 'Lunch Break & Walk', 'type': 'break', 'color': AppColors.mutedGray},
    {'time': '01:30 PM', 'title': 'Podcast Multicam Edit Sync', 'type': 'priority', 'color': AppColors.textDark},
    {'time': '04:00 PM', 'title': 'Color Grading & Audio Mastering', 'type': 'editing', 'color': AppColors.primaryOrange},
    {'time': '05:30 PM', 'title': 'Final Draft Export & Upload to R2', 'type': 'editing', 'color': AppColors.secondaryOrange},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        leading: widget.onBack != null
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack)
            : null,
        title: Text('My Schedule', style: AppTypography.titleLarge()),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.textDark,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Today', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Month header & 7-Day Horizontal Strip (Screen 10)
          Container(
            color: AppColors.surfaceWhite,
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('November 2026', style: AppTypography.titleMedium()),
                      Row(
                        children: [
                          IconButton(icon: const Icon(Icons.chevron_left), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.chevron_right), onPressed: () {}),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_weekDays.length, (idx) {
                    final d = _weekDays[idx];
                    final isSel = _selectedDayIndex == idx;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedDayIndex = idx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.primaryOrange : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            Text(
                              d['day'],
                              style: TextStyle(
                                fontSize: 11,
                                color: isSel ? Colors.white70 : AppColors.mutedGray,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              d['date'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isSel ? Colors.white : AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Hourly Timeline List (Screen 10)
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _hourlySlots.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final slot = _hourlySlots[i];
                final Color slotColor = slot['color'];

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 72,
                      child: Text(
                        slot['time'],
                        style: AppTypography.bodySmall(color: AppColors.mutedGray),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceWhite,
                          borderRadius: BorderRadius.circular(14),
                          border: Border(left: BorderSide(color: slotColor, width: 4)),
                          boxShadow: const [
                            BoxShadow(color: Color(0x06171411), blurRadius: 8, offset: Offset(0, 2)),
                          ],
                        ),
                        child: Text(
                          slot['title'],
                          style: AppTypography.labelLarge(color: AppColors.textDark),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Full-width orange CTA: Set Availability (Screen 10)
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surfaceWhite,
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Availability settings updated!')),
                    );
                  },
                  icon: const Icon(Icons.settings_outlined),
                  label: const Text('Set Working Hours & Availability'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
