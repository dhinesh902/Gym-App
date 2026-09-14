import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';

class AssignedDietsTab extends StatelessWidget {
  const AssignedDietsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> assignedDataList = [
      {
        'name': 'Alex Johnson',
        'planName': 'Weight Loss Plan',
        'imageUrl':
            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100',
        'isActive': true,
        'calories': '2100',
        'protein': '140',
        'water': '3.0',
        'startDate': '12 Aug, 2026',
      },
      {
        'name': 'Sarah Smith',
        'planName': 'Muscle Gain Plan',
        'imageUrl':
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
        'isActive': true,
        'calories': '2800',
        'protein': '180',
        'water': '4.0',
        'startDate': '10 Aug, 2026',
      },
      {
        'name': 'Michael Brown',
        'planName': 'Endurance Prep',
        'imageUrl':
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
        'isActive': false,
        'calories': '2400',
        'protein': '120',
        'water': '3.5',
        'startDate': '01 Jul, 2026',
      },
      {
        'name': 'Emily Davis',
        'planName': 'Toning Plan',
        'imageUrl':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
        'isActive': false,
        'calories': '1800',
        'protein': '110',
        'water': '2.5',
        'startDate': '15 Jun, 2026',
      },
    ];

    if (assignedDataList.isEmpty) {
      return const Center(
        child: Text(
          'No assigned diets found.',
          style: TextStyle(color: AppColors.textLight, fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      itemCount: assignedDataList.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final data = assignedDataList[index];
        return _AssignedDietCard(data: data);
      },
    );
  }
}

class _AssignedDietCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _AssignedDietCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final bool isActive = data['isActive'] as bool;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(data['imageUrl']),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data['planName'],
                        style: const TextStyle(
                          color: AppColors.textLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF10B981).withValues(alpha: 0.15)
                        : const Color(0xFFF59E0B).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isActive ? 'ACTIVE' : 'COMPLETED',
                    style: TextStyle(
                      color: isActive
                          ? const Color(0xFF10B981)
                          : const Color(0xFFF59E0B),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: AppColors.border.withValues(alpha: 0.5),
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),

          // Stats Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _StatColumn(
                    icon: Icons.local_fire_department_rounded,
                    label: 'Calories',
                    value: data['calories'],
                    unit: 'kcal',
                    color: AppColors.accent,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
                Expanded(
                  child: _StatColumn(
                    icon: Icons.egg_alt_rounded,
                    label: 'Protein',
                    value: data['protein'],
                    unit: 'g',
                    color: AppColors.primary,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
                Expanded(
                  child: _StatColumn(
                    icon: Icons.water_drop_rounded,
                    label: 'Water',
                    value: data['water'],
                    unit: 'L',
                    color: AppColors.lightBlue,
                  ),
                ),
              ],
            ),
          ),

          // Action Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Started: ${data['startDate']}',
                  style: TextStyle(
                    color: AppColors.textLight.withValues(alpha: 0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit_rounded,
                        color: AppColors.textLight,
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [AppColors.secondary, AppColors.primary],
                          ),
                        ),
                        child: const Text(
                          'View Plan',
                          style: TextStyle(
                            color: AppColors.surface,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _StatColumn({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Flexible(
              child: Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
