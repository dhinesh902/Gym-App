import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gym/utils/constants/colors.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final double expandedHeight;

  const CustomSliverAppBar({
    super.key,
    required this.title,
    this.actions,
    this.expandedHeight = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.background.withValues(alpha: 0.9),
                  AppColors.surface.withValues(alpha: 0.8),
                ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.surface.withValues(alpha: 0.1),
                  width: 1.0,
                ),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -30,
                  top: -20,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.15),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ),
                FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      letterSpacing: -0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      leadingWidth: 80,
      // leading: Navigator.canPop(context)
      //     ? Center(
      //         child: ClipRRect(
      //           borderRadius: BorderRadius.circular(16),
      //           child: BackdropFilter(
      //             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      //             child: Container(
      //               margin: const EdgeInsets.only(left: 20),
      //               width: 48,
      //               height: 48,
      //               decoration: BoxDecoration(
      //                 color: AppColors.surface.withValues(alpha: 0.1),
      //                 borderRadius: BorderRadius.circular(16),
      //                 border: Border.all(
      //                   color: AppColors.surface.withValues(alpha: 0.2),
      //                   width: 1.5,
      //                 ),
      //               ),
      //               child: IconButton(
      //                 padding: EdgeInsets.zero,
      //                 onPressed: () => Navigator.maybePop(context),
      //                 icon: const Icon(
      //                   Icons.arrow_back_ios_new_rounded,
      //                   color: AppColors.primary,
      //                   size: 20,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //       )
      //     : null,
      actions: actions != null
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Row(children: actions!),
              ),
            ]
          : null,
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({super.key, this.title = "Shop", this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 70,
      backgroundColor: Colors.transparent,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withValues(alpha: 0.95),
                  AppColors.secondary.withValues(alpha: 0.85),
                ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.surface.withValues(alpha: 0.08),
                  width: 1.0,
                ),
              ),
            ),
          ),
        ),
      ),
      leadingWidth: 80,
      leading: Navigator.canPop(context)
          ? Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.surface.withValues(alpha: 0.15),
                        width: 1.2,
                      ),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_sharp,
                        color: AppColors.surface,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.surface,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
      ),
      actions: actions != null
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Row(children: actions!),
              ),
            ]
          : null,
    );
  }
}
