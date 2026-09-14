import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym/models/auth_models.dart';
import 'package:gym/utils/constants/colors.dart';
import 'package:gym/views/widgets/custom_text_field.dart';
import 'package:gym/views/widgets/custom_dropdown.dart';
import 'package:gym/views/widgets/custom_date_picker.dart';
import 'package:gym/views/widgets/actionbar.dart';
import 'package:gym/views/widgets/custom_elevated_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gym/providers/trainer_profile_provider.dart';
import 'package:gym/utils/snackbar_utils.dart';
import 'package:gym/views/widgets/elegant_gradient_background.dart';

class TrainerEditProfileScreen extends StatefulWidget {
  final TrainerDetailModel? trainer;

  const TrainerEditProfileScreen({super.key, this.trainer});

  @override
  State<TrainerEditProfileScreen> createState() =>
      _TrainerEditProfileScreenState();
}

class _TrainerEditProfileScreenState extends State<TrainerEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullnameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  late TextEditingController _specialityController;
  late TextEditingController _experienceController;
  late TextEditingController _shiftTimingController;
  late TextEditingController _monthlySalaryController;
  late TextEditingController _statusController;

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    final t = widget.trainer;
    _fullnameController = TextEditingController(text: t?.fullname ?? '');
    _emailController = TextEditingController(text: t?.email ?? '');
    _phoneController = TextEditingController(text: t?.phone ?? '');
    _dobController = TextEditingController(text: t?.dateofbirth ?? '');
    _specialityController = TextEditingController(text: t?.speciality ?? '');
    _experienceController = TextEditingController(
      text: t?.experience.toString() ?? '',
    );
    _shiftTimingController = TextEditingController(text: t?.shifttiming ?? '');
    _monthlySalaryController = TextEditingController(
      text: t?.monthlysalary ?? '',
    );
    _statusController = TextEditingController(text: t?.status ?? 'active');
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _specialityController.dispose();
    _experienceController.dispose();
    _shiftTimingController.dispose();
    _monthlySalaryController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now().subtract(
      const Duration(days: 365 * 18),
    );
    if (_dobController.text.isNotEmpty) {
      try {
        initialDate = DateTime.parse(_dobController.text);
      } catch (_) {}
    }

    final pickedDate = await showCustomDatePicker(
      context,
      initialDate: initialDate,
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.trainer == null) return;

    try {
      final request = TrainerUpdateRequest(
        fullname: _fullnameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        dateofbirth: _dobController.text,
        speciality: _specialityController.text,
        experience: _experienceController.text,
        shifttiming: _shiftTimingController.text,
        monthlysalary: _monthlySalaryController.text,
        status: _statusController.text,
        profilephoto: _imageFile,
      );

      await context.read<TrainerProfileProvider>().updateProfile(request);

      if (mounted) {
        SnackBarUtils.showSuccess('Profile updated successfully!');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError('Failed to update: $e');
      }
    }
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.secondary, AppColors.primary],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!) as ImageProvider
                      : (widget.trainer?.profilephoto != null &&
                      !widget.trainer!.profilephoto!.contains('[object'))
                      ? NetworkImage(
                    'http://localhost:3000${widget.trainer!.profilephoto}',
                  )
                      : const NetworkImage(
                    'https://images.unsplash.com/photo-1594381898411-846e7d193883?q=80&w=100&auto=format&fit=crop',
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surface,
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trainerProfileProvider = context.watch<TrainerProfileProvider>();
    final _isLoading = trainerProfileProvider.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Edit Profile'),
      body: ElegantGradientBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildAvatar(),
                const SizedBox(height: 40),
                _buildSectionCard(
                  title: 'Personal Details',
                  icon: Icons.person_outline_rounded,
                  children: [
                    CustomTextField(
                      controller: _fullnameController,
                      labelText: 'Full Name',
                      hintText: 'Enter full name',
                      prefixIcon: Icons.person_outline_rounded,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'Email Address',
                      hintText: 'Enter email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _phoneController,
                      labelText: 'Phone Number',
                      hintText: 'Enter phone number',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: _dobController,
                          labelText: 'Date of Birth',
                          hintText: 'Select Date of Birth',
                          prefixIcon: Icons.cake_outlined,
                          validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ),
                  ],
                ),
                _buildSectionCard(
                  title: 'Professional Details',
                  icon: Icons.work_outline_rounded,
                  children: [
                    CustomDropdown<String>(
                      labelText: 'Speciality',
                      hintText: 'Select Speciality',
                      prefixIcon: Icons.star_outline_rounded,
                      value: _specialityController.text.isNotEmpty
                          ? _specialityController.text
                          : null,
                      items: [
                        'Cardio',
                        'Strength Training',
                        'Yoga',
                        'Pilates',
                        'Zumba',
                        'CrossFit',
                      ]
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _specialityController.text = val);
                      },
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _experienceController,
                      labelText: 'Experience (Years)',
                      hintText: 'Enter experience',
                      prefixIcon: Icons.timeline_rounded,
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomDropdown<String>(
                      labelText: 'Shift Timing',
                      hintText: 'Select Shift',
                      prefixIcon: Icons.schedule_rounded,
                      value: _shiftTimingController.text.isNotEmpty
                          ? _shiftTimingController.text
                          : null,
                      items: ['Morning', 'Evening', 'Full Day']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _shiftTimingController.text = val);
                      },
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _monthlySalaryController,
                      labelText: 'Monthly Salary',
                      hintText: 'Enter salary',
                      prefixIcon: Icons.attach_money_rounded,
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomDropdown<String>(
                      labelText: 'Status',
                      hintText: 'Select Status',
                      prefixIcon: Icons.info_outline_rounded,
                      value: _statusController.text.isNotEmpty
                          ? _statusController.text
                          : null,
                      items: ['active', 'inactive']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _statusController.text = val);
                      },
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
