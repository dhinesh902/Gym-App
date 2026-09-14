import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/models/diet_model.dart';
import 'package:gym/views/widgets/custom_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:gym/routes/app_routes.dart';

class FoodLibraryTab extends StatefulWidget {
  const FoodLibraryTab({super.key});

  @override
  State<FoodLibraryTab> createState() => _FoodLibraryTabState();
}

class _FoodLibraryTabState extends State<FoodLibraryTab>
    with SingleTickerProviderStateMixin {
  late TabController _mealSessionController;
  final List<Food> _selectedFoods = [];

  // Dummy food data
  final List<Food> _foods = [
    Food(
      id: '1',
      name: 'Oats',
      imageUrl:
          'https://images.unsplash.com/photo-1517673132405-a56a62b18caf?w=200',
      category: 'Carbs',
      recommendedSession: MealSession.morning,
      servingSize: '50g',
      calories: 195,
      protein: 7,
      carbs: 33,
      fat: 3,
      description: 'Healthy whole grain oats',
      benefits: 'High in fiber',
    ),
    Food(
      id: '2',
      name: 'Boiled Eggs',
      imageUrl:
          'https://images.unsplash.com/photo-1587486913049-53fc88980cfc?w=200',
      category: 'Protein',
      recommendedSession: MealSession.morning,
      servingSize: '2 eggs',
      calories: 155,
      protein: 13,
      carbs: 1,
      fat: 11,
      description: 'Hard boiled eggs',
      benefits: 'Great source of protein',
    ),
    Food(
      id: '3',
      name: 'Grilled Chicken',
      imageUrl:
          'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=200',
      category: 'Protein',
      recommendedSession: MealSession.afternoon,
      servingSize: '150g',
      calories: 250,
      protein: 45,
      carbs: 0,
      fat: 5,
      description: 'Lean grilled chicken breast',
      benefits: 'Muscle building',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _mealSessionController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _mealSessionController.dispose();
    super.dispose();
  }

  void _toggleFoodSelection(Food food) {
    setState(() {
      if (_selectedFoods.contains(food)) {
        _selectedFoods.remove(food);
      } else {
        _selectedFoods.add(food);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: const PageStorageKey<String>('FoodLibraryTab'),
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Search & Filter
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
                const SizedBox(width: 12),
                Container(
                  height: 54, // Matches CustomTextField approximate height
                  width: 54,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.tune_rounded,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () {},
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
              tabs: const [
                Tab(text: 'Morning'),
                Tab(text: 'Afternoon'),
                Tab(text: 'Evening'),
                Tab(text: 'Night'),
              ],
            ),
          ),
        ),

        // Food List (TabBarView)
        SliverFillRemaining(
          child: TabBarView(
            controller: _mealSessionController,
            children: [
              _FoodListView(
                session: MealSession.morning,
                foods: _foods,
                selectedFoods: _selectedFoods,
                onToggle: _toggleFoodSelection,
              ),
              _FoodListView(
                session: MealSession.afternoon,
                foods: _foods,
                selectedFoods: _selectedFoods,
                onToggle: _toggleFoodSelection,
              ),
              _FoodListView(
                session: MealSession.evening,
                foods: _foods,
                selectedFoods: _selectedFoods,
                onToggle: _toggleFoodSelection,
              ),
              _FoodListView(
                session: MealSession.night,
                foods: _foods,
                selectedFoods: _selectedFoods,
                onToggle: _toggleFoodSelection,
              ),
            ],
          ),
        ),

        // Bottom Action Bar
        if (_selectedFoods.isNotEmpty)
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
                        '${_selectedFoods.length} Selected',
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
                      context.push(AppRoutes.trainerAssignDiet);
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
  }
}

class _FoodListView extends StatelessWidget {
  final MealSession session;
  final List<Food> foods;
  final List<Food> selectedFoods;
  final void Function(Food) onToggle;

  const _FoodListView({
    required this.session,
    required this.foods,
    required this.selectedFoods,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final sessionFoods =
        foods.where((f) => f.recommendedSession == session).toList();

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      itemCount: sessionFoods.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final food = sessionFoods[index];
        final isSelected = selectedFoods.contains(food);

        return FoodCard(
          food: food,
          isSelected: isSelected,
          onTap: () => onToggle(food),
        );
      },
    );
  }
}

class FoodCard extends StatelessWidget {
  final Food food;
  final bool isSelected;
  final VoidCallback onTap;

  const FoodCard({
    super.key,
    required this.food,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.04)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.8)
                : AppColors.border.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Food Image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  food.imageUrl,
                  width: 85,
                  height: 85,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Food Details
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
                          food.name,
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
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.restaurant_menu_rounded,
                        size: 14,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${food.servingSize} • ',
                        style: const TextStyle(
                          color: AppColors.textLight,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Icon(
                        Icons.local_fire_department_rounded,
                        size: 14,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${food.calories} kcal',
                        style: const TextStyle(
                          color: AppColors.textLight,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      NutrientBadge(
                        label: 'P',
                        value: '${food.protein}g',
                        color: AppColors.primary,
                      ),
                      NutrientBadge(
                        label: 'C',
                        value: '${food.carbs}g',
                        color: AppColors.lightBlue,
                      ),
                      NutrientBadge(
                        label: 'F',
                        value: '${food.fat}g',
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NutrientBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const NutrientBadge({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary.withValues(alpha: 0.8),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
