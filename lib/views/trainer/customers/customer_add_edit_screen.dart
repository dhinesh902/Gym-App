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
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gym/providers/trainer_customers_provider.dart';
import 'package:gym/utils/snackbar_utils.dart';
import 'package:gym/views/widgets/elegant_gradient_background.dart';
import 'package:gym/service/member_service.dart';

class CustomerAddEditScreen extends StatefulWidget {
  final MemberDetailModel? customer;

  const CustomerAddEditScreen({super.key, this.customer});

  @override
  State<CustomerAddEditScreen> createState() => _CustomerAddEditScreenState();
}

class _CustomerAddEditScreenState extends State<CustomerAddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final MemberService _memberService = MemberService();

  late TextEditingController _fullnameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  late TextEditingController _genderController;
  late TextEditingController _emergencyController;
  late TextEditingController _addressController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _bloodgroupController;
  late TextEditingController _fitnessgoalController;
  late TextEditingController _assignedtrainerController;
  late TextEditingController _membershipplanidController;
  late TextEditingController _joiningdateController;
  late TextEditingController _statusController;

  File? _imageFile;
  bool _isSaving = false;

  bool get isEditing => widget.customer != null;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    _fullnameController = TextEditingController(text: c?.fullname ?? '');
    _emailController = TextEditingController(text: c?.email ?? '');
    _passwordController = TextEditingController();
    _phoneController = TextEditingController(text: c?.phone ?? '');
    _dobController = TextEditingController(text: c?.dateofbirth ?? '');
    _genderController = TextEditingController(text: c?.gender ?? '');
    _emergencyController = TextEditingController(text: c?.emergency ?? '');
    _addressController = TextEditingController(text: c?.address ?? '');
    _heightController = TextEditingController(text: c?.height.toString() ?? '');
    _weightController = TextEditingController(text: c?.weight.toString() ?? '');
    _bloodgroupController = TextEditingController(text: c?.bloodgroup ?? '');
    _fitnessgoalController = TextEditingController(text: c?.fitnessgoal ?? '');
    _assignedtrainerController = TextEditingController(
      text: c?.assignedtrainer.toString() ?? '',
    );
    _membershipplanidController = TextEditingController(
      text: c?.membershipplanid.toString() ?? '',
    );
    _joiningdateController = TextEditingController(text: c?.joiningdate ?? '');
    _statusController = TextEditingController(text: c?.status ?? 'active');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrainerCustomersProvider>().loadDropdowns();
    });
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _emergencyController.dispose();
    _addressController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bloodgroupController.dispose();
    _fitnessgoalController.dispose();
    _assignedtrainerController.dispose();
    _membershipplanidController.dispose();
    _joiningdateController.dispose();
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

  Future<void> _selectDate(BuildContext context,
      TextEditingController controller, {
      int initialYearsBack = 0,
  }) async {
    DateTime initialDate = DateTime.now().subtract(
      Duration(days: 365 * initialYearsBack),
    );
    if (controller.text.isNotEmpty) {
      try {
        initialDate = DateTime.parse(controller.text);
      } catch (_) {}
    }

    final pickedDate = await showCustomDatePicker(
      context,
      initialDate: initialDate,
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isSaving = true;
    });

    try {
      if (isEditing) {
        final request = MemberUpdateRequest(
          fullname: _fullnameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          dateofbirth: _dobController.text,
          gender: _genderController.text,
          emergency: _emergencyController.text,
          address: _addressController.text,
          height: _heightController.text,
          weight: _weightController.text,
          bloodgroup: _bloodgroupController.text,
          fitnessgoal: _fitnessgoalController.text,
          assignedtrainer: _assignedtrainerController.text,
          membershipplanid: _membershipplanidController.text,
          joiningdate: _joiningdateController.text,
          status: _statusController.text,
          profilephoto: _imageFile,
        );
        await _memberService.updateMember(widget.customer!.id, request);
        SnackBarUtils.showSuccess('Member updated successfully!');
      } else {
        final request = MemberRegisterRequest(
          fullname: _fullnameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          phone: _phoneController.text,
          dateofbirth: _dobController.text,
          gender: _genderController.text,
          emergency: _emergencyController.text,
          address: _addressController.text,
          height: _heightController.text,
          weight: _weightController.text,
          bloodgroup: _bloodgroupController.text,
          fitnessgoal: _fitnessgoalController.text,
          assignedtrainer: _assignedtrainerController.text,
          membershipplanid: _membershipplanidController.text,
          joiningdate: _joiningdateController.text,
          status: _statusController.text,
          profilephoto: _imageFile,
        );
        await _memberService.registerMember(request);
        SnackBarUtils.showSuccess('Member added successfully!');
      }

      if (mounted) {
        // Refresh customer list
        context.read<TrainerCustomersProvider>().loadCustomers();
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError('Failed to save: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
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
                      : (widget.customer?.profilephoto != null &&
                              !widget.customer!.profilephoto!.contains('[object'))
                          ? NetworkImage(
                              'http://localhost:3000${widget.customer!.profilephoto}',
                            )
                          : const NetworkImage(
                              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=500&q=80',
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
    final provider = context.watch<TrainerCustomersProvider>();
    final bool isLoadingDropdowns = provider.isLoadingDropdowns;
    final trainers = provider.trainers;
    final plans = provider.plans;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: isEditing ? 'Edit Member' : 'Add Member'),
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
                    if (!isEditing) ...[
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _passwordController,
                        labelText: 'Password',
                        hintText: 'Enter initial password',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: true,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ],
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
                      onTap: () => _selectDate(
                        context,
                        _dobController,
                        initialYearsBack: 18,
                      ),
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: _dobController,
                          labelText: 'Date of Birth',
                          hintText: 'Select DOB',
                          prefixIcon: Icons.cake_outlined,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomDropdown<String>(
                      labelText: 'Gender',
                      hintText: 'Select Gender',
                      prefixIcon: Icons.transgender_outlined,
                      value: _genderController.text.isNotEmpty
                          ? _genderController.text
                          : null,
                      items: ['Male', 'Female', 'Other']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _genderController.text = val);
                      },
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _emergencyController,
                      labelText: 'Emergency Contact',
                      hintText: 'Name & Phone',
                      prefixIcon: Icons.health_and_safety_outlined,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _addressController,
                      labelText: 'Address',
                      hintText: 'Enter address',
                      prefixIcon: Icons.home_outlined,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ],
                ),
                _buildSectionCard(
                  title: 'Physical Metrics',
                  icon: Icons.monitor_weight_outlined,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _heightController,
                            labelText: 'Height (cm)',
                            hintText: 'e.g. 180',
                            prefixIcon: Icons.height_outlined,
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            controller: _weightController,
                            labelText: 'Weight (kg)',
                            hintText: 'e.g. 75',
                            prefixIcon: Icons.monitor_weight_outlined,
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomDropdown<String>(
                      labelText: 'Blood Group',
                      hintText: 'Select Blood Group',
                      prefixIcon: Icons.bloodtype_outlined,
                      value: _bloodgroupController.text.isNotEmpty
                          ? _bloodgroupController.text
                          : null,
                      items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _bloodgroupController.text = val);
                      },
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomDropdown<String>(
                      labelText: 'Fitness Goal',
                      hintText: 'Select Fitness Goal',
                      prefixIcon: Icons.flag_outlined,
                      value: _fitnessgoalController.text.isNotEmpty
                          ? _fitnessgoalController.text
                          : null,
                      items: [
                        'Muscle Gain',
                        'Weight Loss',
                        'Endurance',
                        'Flexibility',
                        'General Fitness',
                      ]
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _fitnessgoalController.text = val);
                      },
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ],
                ),
                _buildSectionCard(
                  title: 'Membership Details',
                  icon: Icons.card_membership_outlined,
                  children: [
                    CustomDropdown<String>(
                      labelText: 'Assigned Trainer',
                      hintText: isLoadingDropdowns ? 'Loading...' : 'Select Trainer',
                      prefixIcon: Icons.sports,
                      value: _assignedtrainerController.text.isNotEmpty
                          ? _assignedtrainerController.text
                          : null,
                      items: trainers
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id.toString(),
                              child: Text('${e.fullname} (${e.id})'),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _assignedtrainerController.text = val);
                        }
                      },
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomDropdown<String>(
                      labelText: 'Membership Plan',
                      hintText: isLoadingDropdowns ? 'Loading...' : 'Select Plan',
                      prefixIcon: Icons.card_membership_outlined,
                      value: _membershipplanidController.text.isNotEmpty
                          ? _membershipplanidController.text
                          : null,
                      items: plans
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id.toString(),
                              child: Text('${e.name} (\$${e.price ?? 0})'),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _membershipplanidController.text = val);
                        }
                      },
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _selectDate(context, _joiningdateController),
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: _joiningdateController,
                          labelText: 'Joining Date',
                          hintText: 'Select Date',
                          prefixIcon: Icons.event_available_outlined,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
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
                _isSaving
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: CustomElevatedButton(
                          onPressed: _saveCustomer,
                          child: Text(
                            isEditing ? 'Save Changes' : 'Add Member',
                            style: const TextStyle(
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
