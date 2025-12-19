import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../services/auth_service.dart';
import '../utils/page_transitions.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  final String role;
  
  const SignUpPage({super.key, required this.role});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  String? _selectedGender;
  String? _selectedBloodGroup;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(langProvider.translate('agree_terms_required')),
          backgroundColor: Colors.orange.withOpacity(0.8),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await AuthService.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
      role: widget.role,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (result['success']) {
        Navigator.pushReplacement(
          context,
          SlideRightRoute(
            page: HomePage(role: widget.role),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Sign up failed'),
            backgroundColor: Colors.red.withOpacity(0.8),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0A0A0A),
                  Color(0xFF1A1A1A),
                  Color(0xFF0A0A0A),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Top bar with back button and language toggle
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const Spacer(),
                        _buildLanguageToggle(langProvider),
                      ],
                    ),
                  ),
                  
                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            _buildGlassContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    langProvider.translate('create_account_title'),
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.95),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${langProvider.translate('join_as')} ${_capitalizeRole(widget.role, langProvider)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Personal Information Section
                            Text(
                              langProvider.translate('personal_info'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Full Name
                            _buildTextField(
                              controller: _nameController,
                              label: langProvider.translate('full_name'),
                              hint: langProvider.translate('enter_name'),
                              icon: Icons.person_outline_rounded,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return langProvider.translate('please_enter_name');
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Age and Gender Row
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _ageController,
                                    label: langProvider.translate('age'),
                                    hint: langProvider.translate('enter_age'),
                                    icon: Icons.calendar_today_outlined,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return langProvider.translate('please_enter_age');
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildDropdown(
                                    label: langProvider.translate('gender'),
                                    hint: langProvider.translate('select_gender'),
                                    icon: Icons.wc_outlined,
                                    value: _selectedGender,
                                    items: _genders,
                                    langProvider: langProvider,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedGender = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return langProvider.translate('please_select_gender');
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Blood Group
                            _buildDropdown(
                              label: langProvider.translate('blood_group'),
                              hint: langProvider.translate('select_blood_group'),
                              icon: Icons.bloodtype_outlined,
                              value: _selectedBloodGroup,
                              items: _bloodGroups,
                              langProvider: langProvider,
                              onChanged: (value) {
                                setState(() {
                                  _selectedBloodGroup = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return langProvider.translate('please_select_blood_group');
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            
                            // Contact Information Section
                            Text(
                              langProvider.translate('contact_info'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Mobile Number
                            _buildTextField(
                              controller: _mobileController,
                              label: langProvider.translate('mobile'),
                              hint: langProvider.translate('enter_mobile'),
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return langProvider.translate('please_enter_mobile');
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Email
                            _buildTextField(
                              controller: _emailController,
                              label: langProvider.translate('email'),
                              hint: langProvider.translate('enter_email_address'),
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return langProvider.translate('please_enter_email');
                                }
                                if (!value.contains('@')) {
                                  return langProvider.translate('valid_email');
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Address
                            _buildTextField(
                              controller: _addressController,
                              label: langProvider.translate('address'),
                              hint: langProvider.translate('enter_address'),
                              icon: Icons.location_on_outlined,
                              maxLines: 2,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return langProvider.translate('please_enter_address');
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            
                            // Security Section
                            Text(
                              langProvider.translate('security'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Password
                            _buildTextField(
                              controller: _passwordController,
                              label: langProvider.translate('password'),
                              hint: langProvider.translate('create_password'),
                              icon: Icons.lock_outline_rounded,
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return langProvider.translate('please_enter_password');
                                }
                                if (value.length < 6) {
                                  return langProvider.translate('password_length');
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Confirm Password
                            _buildTextField(
                              controller: _confirmPasswordController,
                              label: langProvider.translate('confirm_password'),
                              hint: langProvider.translate('confirm_password_hint'),
                              icon: Icons.lock_outline_rounded,
                              obscureText: _obscureConfirmPassword,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return langProvider.translate('password_confirm');
                                }
                                if (value != _passwordController.text) {
                                  return langProvider.translate('password_match');
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            
                            // Terms and Conditions
                            _buildGlassContainer(
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: _agreedToTerms,
                                    onChanged: (value) {
                                      setState(() {
                                        _agreedToTerms = value ?? false;
                                      });
                                    },
                                    fillColor: MaterialStateProperty.resolveWith((states) {
                                      if (states.contains(MaterialState.selected)) {
                                        return Colors.white.withOpacity(0.2);
                                      }
                                      return Colors.white.withOpacity(0.05);
                                    }),
                                    checkColor: Colors.white,
                                    side: BorderSide(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      langProvider.translate('agree_terms'),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Sign Up Button
                            _buildGlassButton(
                              onPressed: _isLoading ? null : _signUp,
                              label: _isLoading 
                                  ? langProvider.translate('creating_account')
                                  : langProvider.translate('create_account'),
                              isPrimary: true,
                            ),
                            const SizedBox(height: 24),
                            
                            // Already have account
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    langProvider.translate('have_account'),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Text(
                                      langProvider.translate('sign_in'),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageToggle(LanguageProvider langProvider) {
    return GestureDetector(
      onTap: () => langProvider.toggleLanguage(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language_rounded,
              color: Colors.white.withOpacity(0.9),
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              langProvider.isBangla ? 'বাংলা' : 'EN',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLines: maxLines,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.3),
              ),
              prefixIcon: Icon(
                icon,
                color: Colors.white.withOpacity(0.5),
              ),
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required IconData icon,
    required String? value,
    required List<String> items,
    required LanguageProvider langProvider,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.3),
              ),
              prefixIcon: Icon(
                icon,
                color: Colors.white.withOpacity(0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
            ),
            dropdownColor: const Color(0xFF1A1A1A),
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white.withOpacity(0.5),
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  _translateGender(item, langProvider),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            validator: validator,
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton({
    required VoidCallback? onPressed,
    required String label,
    bool isPrimary = true,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? Colors.white.withOpacity(0.15)
              : Colors.white.withOpacity(0.05),
          foregroundColor: Colors.white.withOpacity(0.95),
          disabledBackgroundColor: Colors.white.withOpacity(0.05),
          disabledForegroundColor: Colors.white.withOpacity(0.3),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isPrimary
                  ? Colors.white.withOpacity(0.2)
                  : Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  String _capitalizeRole(String role, LanguageProvider langProvider) {
    return langProvider.translate(role);
  }

  String _translateGender(String gender, LanguageProvider langProvider) {
    switch (gender.toLowerCase()) {
      case 'male':
        return langProvider.translate('male');
      case 'female':
        return langProvider.translate('female');
      case 'other':
        return langProvider.translate('other');
      default:
        return gender;
    }
  }
}
