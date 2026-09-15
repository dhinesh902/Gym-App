import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/utils/snackbar_utils.dart';
import 'package:gym/views/widgets/actionbar.dart';
import 'package:gym/views/widgets/custom_text_field.dart';
import 'package:gym/views/widgets/custom_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym/service/trainer_service.dart';
import 'package:gym/models/diet_model.dart';

import 'package:gym/models/auth_models.dart';

class AssignDietScreen extends StatefulWidget {
  final List<DietLibraryModel>? selectedDiets;

  const AssignDietScreen({super.key, this.selectedDiets});

  @override
  State<AssignDietScreen> createState() => _AssignDietScreenState();
}

class _AssignDietScreenState extends State<AssignDietScreen> {
  MemberSearchModel? _selectedMember;
  bool _isSearchingMember = false;
  final TextEditingController _notesController = TextEditingController();
  TextEditingController? _internalMemberController;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<List<MemberSearchModel>> _searchMembers(String query) async {
    setState(() => _isSearchingMember = true);
    try {
      return await TrainerService().searchCustomers(query);
    } catch (e) {
      return [];
    } finally {
      setState(() => _isSearchingMember = false);
    }
  }

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
              title: 'Select Customer',
              icon: Icons.person_add_rounded,
            ),
            const SizedBox(height: 16),
            Autocomplete<MemberSearchModel>(
              displayStringForOption: (option) => option.fullname,
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<MemberSearchModel>.empty();
                }
                return await _searchMembers(textEditingValue.text);
              },
              onSelected: (MemberSearchModel selection) {
                setState(() {
                  _selectedMember = selection;
                });
                Future.microtask(() {
                  _internalMemberController?.clear();
                });
              },
              fieldViewBuilder:
                  (
                    context,
                    textEditingController,
                    focusNode,
                    onFieldSubmitted,
                  ) {
                    _internalMemberController = textEditingController;
                    return CustomTextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      hintText: 'Search member to assign...',
                      prefixIcon: Icons.search_rounded,
                      suffixIcon: _isSearchingMember
                          ? const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : null,
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
                        separatorBuilder: (context, index) => Divider(
                          color: AppColors.border.withValues(alpha: 0.5),
                          height: 1,
                        ),
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                option.profilephoto ??
                                    'https://ui-avatars.com/api/?name=${option.fullname}',
                              ),
                            ),
                            title: Text(
                              option.fullname,
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
            if (_selectedMember != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(
                            _selectedMember!.profilephoto ??
                                'https://ui-avatars.com/api/?name=${_selectedMember!.fullname}',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _selectedMember!.fullname,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedMember = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 32),

            const SectionHeader(
              title: 'Selected Foods',
              icon: Icons.restaurant_menu_rounded,
            ),
            const SizedBox(height: 16),
            _buildFoodList(widget.selectedDiets),
            const SizedBox(height: 32),

            const SectionHeader(
              title: 'Trainer Notes',
              icon: Icons.notes_rounded,
            ),
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
              child: CustomTextField(
                controller: _notesController,
                hintText:
                    'Add instructions (e.g. Drink 3L water daily, stay hydrated)',
                maxLines: 4,
              ),
            ),
            const SizedBox(height: 48),

            CustomElevatedButton(
              onPressed: () async {
                try {
                  final prefs = await SharedPreferences.getInstance();
                  final trainerId = prefs.getInt('userId') ?? 10;

                  if (_selectedMember == null) {
                    if (context.mounted)
                      SnackBarUtils.showError('Please select a member');
                    return;
                  }

                  final dietsPayload =
                      widget.selectedDiets?.map((d) {
                        return DietAssignmentItem(
                          dietId: d.id,
                          scheduledDate: DateTime.now().toString().split(
                            ' ',
                          )[0],
                          status: 'pending',
                          notes: _notesController.text.isNotEmpty
                              ? _notesController.text
                              : 'Assigned by Trainer',
                        );
                      }).toList() ??
                      [];

                  final request = AssignDietRequestModel(
                    memberId: _selectedMember!.id,
                    trainerId: trainerId,
                    diets: dietsPayload,
                  );

                  await TrainerService().assignDiets(request);

                  if (context.mounted) {
                    SnackBarUtils.showSuccess(
                      'Diet plan assigned successfully!',
                    );
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    SnackBarUtils.showError(e.toString());
                  }
                }
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
  final List<String> _selectedCustomers = [];

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
              final List<String> allMembers = [
                'Alex Johnson',
                'Sarah Smith',
                'Michael Brown',
                'Emily Davis',
                'Chris Wilson',
                'David Clark',
                'John Doe',
              ];
              return allMembers.where(
                (member) =>
                    member.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    ) &&
                    !_selectedCustomers.contains(member),
              );
            },
            onSelected: (String selection) {
              setState(() {
                if (!_selectedCustomers.contains(selection)) {
                  _selectedCustomers.add(selection);
                }
              });
            },
            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) {
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
                      separatorBuilder: (context, index) => Divider(
                        color: AppColors.border.withValues(alpha: 0.5),
                        height: 1,
                      ),
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
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
                deleteIcon: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
                onDeleted: () {
                  setState(() {
                    _selectedCustomers.remove(name);
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

Widget _buildFoodList(List<DietLibraryModel>? diets) {
  if (diets == null || diets.isEmpty) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'No foods selected.',
        style: TextStyle(color: AppColors.textLight),
      ),
    );
  }

  // Group by session
  final Map<String, List<DietLibraryModel>> groupedDiets = {};
  for (var diet in diets) {
    groupedDiets.putIfAbsent(diet.session, () => []).add(diet);
  }

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
      children: groupedDiets.entries.map((entry) {
        final session = entry.key;
        final items = entry.value;

        final icon =
            session.toLowerCase().contains('morning') ||
                session.toLowerCase().contains('breakfast')
            ? Icons.wb_sunny_rounded
            : session.toLowerCase().contains('dinner') ||
                  session.toLowerCase().contains('evening')
            ? Icons.nights_stay_rounded
            : Icons.lunch_dining_rounded;

        final color =
            session.toLowerCase().contains('morning') ||
                session.toLowerCase().contains('breakfast')
            ? const Color(0xFFF59E0B)
            : session.toLowerCase().contains('dinner') ||
                  session.toLowerCase().contains('evening')
            ? const Color(0xFF3B82F6)
            : const Color(0xFF10B981);

        return _mealSessionSection(
          session,
          'Anytime',
          icon,
          color,
          items.map((item) {
            return _FoodItemRow(
              name: item.foodName,
              qty: item.isQuantity ? '${item.quantity} qty' : '${item.grams}g',
            );
          }).toList(),
        );
      }).toList(),
    ),
  );
}

Widget _mealSessionSection(
  String session,
  String time,
  IconData icon,
  Color color,
  List<Widget> items,
) {
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

class _FoodItemRow extends StatelessWidget {
  final String name;
  final String qty;

  const _FoodItemRow({required this.name, required this.qty});

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
        ],
      ),
    );
  }
}
