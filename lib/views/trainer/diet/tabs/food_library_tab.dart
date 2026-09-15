import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym/routes/app_routes.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/models/diet_model.dart';
import 'package:gym/views/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:gym/providers/trainer_diet_provider.dart';
import 'package:gym/views/widgets/delete_dialog_widget.dart';
import 'package:gym/views/widgets/no_data_widget.dart';

class FoodLibraryTab extends StatefulWidget {
  const FoodLibraryTab({super.key});

  @override
  State<FoodLibraryTab> createState() => _FoodLibraryTabState();
}

class _FoodLibraryTabState extends State<FoodLibraryTab>
    with SingleTickerProviderStateMixin {
  late TabController _mealSessionController;
  final List<String> _sessions = ['Breakfast', 'Lunch', 'Evening Snack', 'Dinner'];
  final List<DietLibraryModel> _selectedDiets = [];

  @override
  void initState() {
    super.initState();
    _mealSessionController = TabController(length: 4, vsync: this);
    
    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrainerDietProvider>().fetchDiets(_sessions[0]);
    });

    _mealSessionController.addListener(() {
      if (_mealSessionController.indexIsChanging) {
        context.read<TrainerDietProvider>().fetchDiets(_sessions[_mealSessionController.index]);
      }
    });
  }

  @override
  void dispose() {
    _mealSessionController.dispose();
    super.dispose();
  }

  void _toggleSelection(DietLibraryModel diet) {
    setState(() {
      if (_selectedDiets.contains(diet)) {
        _selectedDiets.remove(diet);
      } else {
        _selectedDiets.add(diet);
      }
    });
  }

  void _showDeleteDialog(BuildContext context, int dietId) {
    showDialog(
      context: context,
      builder: (ctx) => DeleteDialogWidget(
        title: 'Delete Food',
        content: 'Are you sure you want to delete this food from your library?',
        onDelete: () {
          context.read<TrainerDietProvider>().deleteDiet(dietId);
        },
      ),
    );
  }

  void _showEditBottomSheet(BuildContext context, DietLibraryModel diet) {
    final TextEditingController _foodNameController = TextEditingController(text: diet.foodName);
    final TextEditingController _amountController = TextEditingController(text: (diet.isQuantity ? diet.quantity : diet.grams).toString());
    final TextEditingController _descriptionController = TextEditingController(text: diet.description);
    bool _isQuantity = diet.isQuantity;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit_rounded, color: AppColors.primary),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Edit Food',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: _foodNameController,
                    hintText: 'Food Name',
                    prefixIcon: Icons.fastfood_rounded,
                  ),
                  const SizedBox(height: 16),
                  Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isQuantity = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isQuantity ? AppColors.primary : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _isQuantity ? AppColors.primary : AppColors.border,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Quantity',
                            style: TextStyle(
                              color: _isQuantity ? AppColors.surface : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isQuantity = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isQuantity ? AppColors.primary : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: !_isQuantity ? AppColors.primary : AppColors.border,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Grams',
                            style: TextStyle(
                              color: !_isQuantity ? AppColors.surface : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _amountController,
                  hintText: _isQuantity ? 'Enter Quantity' : 'Enter Grams',
                  prefixIcon: Icons.numbers_rounded,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _descriptionController,
                  hintText: 'Description',
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: BorderSide(color: AppColors.border.withValues(alpha: 0.8)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final amount = int.tryParse(_amountController.text.trim());
                          if(amount == null) return;
                          final data = {
                            "session": diet.session,
                            "foodName": _foodNameController.text.trim(),
                            "isQuantity": _isQuantity,
                            "isGrams": !_isQuantity,
                            "quantity": _isQuantity ? amount : null,
                            "grams": !_isQuantity ? amount : null,
                            "description": _descriptionController.text.trim()
                          };
                          Navigator.pop(ctx);
                          context.read<TrainerDietProvider>().editDiet(diet.id, data);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.surface,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrainerDietProvider>(
      builder: (context, provider, child) {
        return CustomScrollView(
          key: const PageStorageKey<String>('FoodLibraryTab'),
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Search & Filter (can keep dummy UI for now)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.border.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: 'Search food library...',
                        prefixIcon: Icons.search_rounded,
                        hintColor: AppColors.textLight.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    
            // Sub Tabs for Meal Sessions
            SliverToBoxAdapter(
              child: Container(
                color: AppColors.background,
                child: TabBar(
                  controller: _mealSessionController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textLight,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  tabs: _sessions.map((s) => Tab(text: s)).toList(),
                ),
              ),
            ),
    
            // Food List
            SliverFillRemaining(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.diets.isEmpty
                      ? const NoDataWidget(
                          title: 'No foods found for this session.',
                          icon: Icons.fastfood_outlined,
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                          itemCount: provider.diets.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final diet = provider.diets[index];
                            final isSelected = _selectedDiets.contains(diet);
                            return FoodCard(
                              diet: diet,
                              isSelected: isSelected,
                              onToggle: () => _toggleSelection(diet),
                              onEdit: () => _showEditBottomSheet(context, diet),
                              onDelete: () => _showDeleteDialog(context, diet.id),
                            );
                          },
                        ),
            ),

            if (_selectedDiets.isNotEmpty)
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.06),
                        blurRadius: 24,
                        offset: const Offset(0, -8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${_selectedDiets.length} Selected',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const Text(
                            'Ready to assign',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: WidgetStatePropertyAll(Size(100, 50))
                        ),
                        onPressed: () {
                          context.push(AppRoutes.trainerAssignDiet, extra: _selectedDiets.toList());
                          setState(() {
                            _selectedDiets.clear();
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            'Assign Plan',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class FoodCard extends StatelessWidget {
  final DietLibraryModel diet;
  final bool isSelected;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FoodCard({
    super.key,
    required this.diet,
    required this.isSelected,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.04) : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.8) : AppColors.border.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.restaurant_menu_rounded, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        diet.foodName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected)
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
                      ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: onEdit,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.edit_rounded, size: 14, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: onDelete,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.delete_rounded, size: 14, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  diet.isQuantity ? '${diet.quantity} qty' : '${diet.grams}g',
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  diet.description,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
