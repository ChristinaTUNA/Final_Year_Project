import 'dart:io';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/core/theme/app_typography.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_viewmodel.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _nameController.text = user.displayName ?? '';
      _emailController.text = user.email ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512, // Optimize size
        maxHeight: 512,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          _pickedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Handle permission errors gracefully
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not access gallery')),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    // 1. Hide Keyboard
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      // 2. Update Display Name
      await ref
          .read(profileViewModelProvider.notifier)
          .updateDisplayName(_nameController.text.trim());

      // 3. Handle Image Upload (Placeholder)
      if (_pickedImage != null) {
        // TODO: Implement Firebase Storage Upload here.
        // For now, we just show a message that image upload requires Storage setup.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Note: Image upload requires Firebase Storage setup.')),
          );
        }
      } else if (mounted) {
        // Only name updated
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    }
  }

  Future<void> _sendPasswordReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset email sent to $email'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileViewModelProvider);
    final isLoading = state.isLoading;
    final user = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Edit Profile'),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            // Save Button
            TextButton(
              onPressed: isLoading ? null : _saveProfile,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: AppSpacing.pAllLg,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // --- 1. Avatar Section ---
                Center(
                  child: GestureDetector(
                    onTap: _pickImage, // Tap to change
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.1),
                          // Logic: Show picked image -> Show Network Image -> Show Icon
                          backgroundImage: _pickedImage != null
                              ? FileImage(_pickedImage!)
                              : (user?.photoURL != null
                                  ? NetworkImage(user!.photoURL!)
                                  : null) as ImageProvider?,
                          child:
                              (_pickedImage == null && user?.photoURL == null)
                                  ? const Icon(Icons.person,
                                      size: 60, color: AppColors.primary)
                                  : null,
                        ),
                        // Camera Badge
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt,
                                size: 20, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  "Change Profile Picture",
                  style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.xl),

                // --- 2. Name Field ---
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Display Name',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Name cannot be empty';
                    }
                    if (v.trim().length < 3) {
                      return 'Name must be at least 3 chars';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                // --- 3. Email Field (Read Only) ---
                TextFormField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color(0xFFF5F5F5), // Greyed out
                    suffixIcon:
                        Icon(Icons.lock_outline, size: 18, color: Colors.grey),
                  ),
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: AppSpacing.md),

                // Helper text explaining why email is locked
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      'To change your email, please contact support.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // --- 4. Password Reset Action ---
                // Only show if user signed in with password provider
                if (user?.providerData.any((p) => p.providerId == 'password') ??
                    false)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: _sendPasswordReset,
                      icon: const Icon(Icons.lock_reset),
                      label: const Text('Send Password Reset Email'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textDark,
                        side: const BorderSide(color: AppColors.divider),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
