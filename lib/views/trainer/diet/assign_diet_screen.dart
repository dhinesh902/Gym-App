import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/views/widgets/actionbar.dart';
import 'package:gym/views/widgets/custom_text_field.dart';
import 'package:gym/views/widgets/custom_elevated_button.dart';

class AssignDietScreen extends StatelessWidget {
  const AssignDietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Assign Diet Plan'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
                title: 'Select Customer', icon: Icons.person_add_rounded),
            const SizedBox(height: 16),
            const MultiCustomerSelector(),
            const SizedBox(height: 32),

            const SectionHeader(
                title: 'Selected Foods', icon: Icons.restaurant_menu_rounded),
            const SizedBox(height: 16),
            _buildFoodList(),
            const SizedBox(height: 32),

            const SectionHeader(
                title: 'Daily Summary', icon: Icons.analytics_rounded),
            const SizedBox(height: 16),
            _buildSummary(),
            const SizedBox(height: 32),

            const SectionHeader(
                title: 'Trainer Notes', icon: Icons.notes_rounded),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const CustomTextField(
                hintText: 'Add instructions (e.g. Drink 3L water daily, stay hydrated)',
                maxLines: 4,
              ),
            ),
            const SizedBox(height: 48),

            CustomElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Diet plan assigned successfully!'),
                    backgroundColor: const Color(0xFF10B981),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Confirm & Assign Plan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionHeader({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

class MultiCustomerSelector extends StatefulWidget {
  const MultiCustomerSelector({super.key});

  @override
  State<MultiCustomerSelector> createState() => _MultiCustomerSelectorState();
}

class _MultiCustomerSelectorState extends State<MultiCustomerSelector> {
  final List<String> _selectedCustomers = ['Alex Johnson', 'Sarah Smith'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }
              final List<String> _allMembers = [
                'Alex Johnson', 'Sarah Smith', 'Michael Brown', 'Emily Davis', 'Chris Wilson', 'David Clark', 'John Doe'
              ];
              return _allMembers.where((member) =>
                  member.toLowerCase().contains(textEditingValue.text.toLowerCase()) &&
                  !_selectedCustomers.contains(member));
            },
            onSelected: (String selection) {
              setState(() {
                if (!_selectedCustomers.contains(selection)) {
                  _selectedCustomers.add(selection);
                }
              });
            },
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
              return CustomTextField(
                controller: textEditingController,
                focusNode: focusNode,
                hintText: 'Search multiple members to assign...',
                prefixIcon: Icons.search_rounded,
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.surface,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 88,
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: options.length,
                      separatorBuilder: (context, index) => Divider(color: AppColors.border.withValues(alpha: 0.5), height: 1),
                      itemBuilder: (context, index) {
                        final option = options.elementAt(index);
                        return ListTile(
                          title: Text(
                            option,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedCustomers.map((name) {
              return Chip(
                label: Text(name),
                labelStyle: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                side: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.3)),
                deleteIcon: const Icon(
                    Icons.close_rounded, size: 16, color: AppColors.primary),
                onDeleted: () {
                  setState(() {
                    _selectedCustomers.remove(name);
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

Widget _buildFoodList() {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.04),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _mealSessionSection('Morning', '07:30 AM', Icons.wb_sunny_rounded,
            const Color(0xFFF59E0B), [
              _FoodItemRow(name: 'Oats', qty: '50g', calories: '195 kcal'),
              _FoodItemRow(
                  name: 'Boiled Eggs', qty: '2 eggs', calories: '155 kcal'),
            ]),
        Container(height: 1, color: AppColors.border.withValues(alpha: 0.5)),
        _mealSessionSection('Afternoon', '01:00 PM', Icons.lunch_dining_rounded,
            const Color(0xFF10B981), [
              _FoodItemRow(
                  name: 'Grilled Chicken', qty: '150g', calories: '250 kcal'),
            ]),
      ],
    ),
  );
}

Widget _mealSessionSection(String session, String time, IconData icon,
    Color color, List<Widget> items) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              session,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                time,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppColors.textLight,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...items,
      ],
    ),
  );
}

Widget _buildSummary() {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.04),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      children: [
        _SummaryRow(
          label: 'Total Calories',
          value: '600',
          unit: 'kcal',
          icon: Icons.local_fire_department_rounded,
          color: AppColors.accent,
          isTotal: true,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(),
        ),
        _SummaryRow(label: 'Protein',
            value: '58',
            unit: 'g',
            icon: Icons.egg_alt_rounded,
            color: AppColors.primary),
        const SizedBox(height: 16),
        _SummaryRow(label: 'Carbohydrates',
            value: '34',
            unit: 'g',
            icon: Icons.grass_rounded,
            color: AppColors.lightBlue),
        const SizedBox(height: 16),
        _SummaryRow(label: 'Fat',
            value: '16',
            unit: 'g',
            icon: Icons.opacity_rounded,
            color: const Color(0xFFF59E0B)),
      ],
    ),
  );
}

class _FoodItemRow extends StatelessWidget {
  final String name;
  final String qty;
  final String calories;

  const _FoodItemRow(
      {required this.name, required this.qty, required this.calories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Text(
            qty,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 70,
            child: Text(
              calories,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textLight,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(isTotal ? 8 : 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: isTotal ? 18 : 14),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isTotal ? AppColors.textPrimary : AppColors.textLight,
                fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
                fontSize: isTotal ? 16 : 14,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                fontSize: isTotal ? 22 : 16,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textLight,
                fontSize: isTotal ? 14 : 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
