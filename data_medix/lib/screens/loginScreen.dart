import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:data_medix/providers/provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final context2;
  const LoginScreen({super.key, required this.context2});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String profession = "";
  String specialty = "";
  bool _obscureText = true;
  bool _isLoading = false;

  Future<void> _geterror() async {
    try {
      // Wait for the state to be updated
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;

      final error = ref.read(fetchF).errorMessage;
      if (error == null) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(error
                      .split(', ')
                      .last
                      .trim()
                      .replaceAll("errorCode:", "")
                      .replaceAll("_", " ")
                      .replaceAll(")", "") )),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isLogin ? 'Sign In' : 'Sign Up',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ref.watch(colorF).colorsList["praimrytext"],
                ),
              ),
              const SizedBox(height: 32),
              if (!isLogin) ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(
                          color: ref.watch(colorF).colorsList["praimrytext"],
                        ),
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(
                            color:
                                ref.watch(colorF).colorsList["secondarytext"],
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ref
                                  .watch(colorF)
                                  .colorsList["secondarytext"]!,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ref
                                  .watch(colorF)
                                  .colorsList["secondarytext"]!,
                            ),
                          ),
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(
                          color: ref.watch(colorF).colorsList["praimrytext"],
                        ),
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(
                            color:
                                ref.watch(colorF).colorsList["secondarytext"],
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ref
                                  .watch(colorF)
                                  .colorsList["secondarytext"]!,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ref
                                  .watch(colorF)
                                  .colorsList["secondarytext"]!,
                            ),
                          ),
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              TextFormField(
                style: TextStyle(
                  color: ref.watch(colorF).colorsList["praimrytext"],
                ),
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.email,
                    color: ref.watch(colorF).colorsList["secondarytext"],
                  ),
                  labelStyle: TextStyle(
                    color: ref.watch(colorF).colorsList["secondarytext"],
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ref.watch(colorF).colorsList["secondarytext"]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ref.watch(colorF).colorsList["secondarytext"]!,
                    ),
                  ),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter email' : null,
              ),
              if (!isLogin) ...[
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  style: TextStyle(
                    color: ref.watch(colorF).colorsList["praimrytext"],
                  ),
                  decoration: InputDecoration(
                    labelText: 'Profession',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(
                      Icons.work,
                      color: ref.watch(colorF).colorsList["secondarytext"],
                    ),
                    labelStyle: TextStyle(
                      color: ref.watch(colorF).colorsList["secondarytext"],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ref.watch(colorF).colorsList["secondarytext"]!,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ref.watch(colorF).colorsList["secondarytext"]!,
                      ),
                    ),
                  ),
                  items: [
                    'Doctor',
                    'Nurse',
                    'Pharmacist',
                    'Lab Technician',
                    'Other Healthcare Professional'
                  ]
                      .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color:
                                    ref.watch(colorF).colorsList["praimrytext"],
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      profession = newValue!;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select profession' : null,
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  style: TextStyle(
                    color: ref.watch(colorF).colorsList["praimrytext"],
                  ),
                  decoration: InputDecoration(
                    labelText: 'Specialty',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(
                      Icons.psychology,
                      color: ref.watch(colorF).colorsList["secondarytext"],
                    ),
                    labelStyle: TextStyle(
                      color: ref.watch(colorF).colorsList["secondarytext"],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ref.watch(colorF).colorsList["secondarytext"]!,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ref.watch(colorF).colorsList["secondarytext"]!,
                      ),
                    ),
                  ),
                  items: [
                    'Cardiology',
                    'Dermatology',
                    'Emergency Medicine',
                    'Family Medicine',
                    'Internal Medicine',
                    'Neurology',
                    'Obstetrics',
                    'Oncology',
                    'Pediatrics',
                    'Psychiatry',
                    'Surgery',
                    'Other'
                  ]
                      .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color:
                                    ref.watch(colorF).colorsList["praimrytext"],
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      specialty = newValue!;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select specialty' : null,
                ),
              ],
              const SizedBox(height: 24),
              TextFormField(
                onFieldSubmitted: (_) {
                  if (_formKey.currentState!.validate()) {
                    if (isLogin) {
                      ref.read(fetchF).signin(
                          _emailController.text, _passwordController.text);
                      _geterror();
                    } else {
                      ref.read(fetchF).signUp(
                          _emailController.text,
                          _passwordController.text,
                          _firstNameController.text,
                          _lastNameController.text,
                          profession,
                          specialty);
                      _geterror();
                    }
                  }
                },
                style: TextStyle(
                  color: ref.watch(colorF).colorsList["praimrytext"],
                ),
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: ref.watch(colorF).colorsList["secondarytext"],
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  labelStyle: TextStyle(
                    color: ref.watch(colorF).colorsList["secondarytext"],
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ref.watch(colorF).colorsList["secondarytext"]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ref.watch(colorF).colorsList["secondarytext"]!,
                    ),
                  ),
                  helperText:
                      'Min 8 chars, 1 uppercase, 1 number, 1 special char',
                  helperStyle: TextStyle(
                    color: ref.watch(colorF).colorsList["secondaryColor"],
                  ),
                ),
                obscureText: _obscureText,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter password';
                  return null;
                },
              ),
              if (!isLogin) ...[
                const SizedBox(height: 24),
                TextFormField(
                  style: TextStyle(
                    color: ref.watch(colorF).colorsList["praimrytext"],
                  ),
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(
                      Icons.lock,
                      color: ref.watch(colorF).colorsList["secondarytext"],
                    ),
                    labelStyle: TextStyle(
                      color: ref.watch(colorF).colorsList["secondarytext"],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ref.watch(colorF).colorsList["secondarytext"]!,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ref.watch(colorF).colorsList["secondarytext"]!,
                      ),
                    ),
                  ),
                  obscureText: _obscureText,
                  validator: (value) => value != _passwordController.text
                      ? 'Passwords do not match'
                      : null,
                ),
              ],
              const SizedBox(height: 32),
                ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                    ref.watch(colorF).colorsList["frontgroundColor"],
                  foregroundColor:
                    ref.watch(colorF).colorsList["secondarytext"],
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                  if (isLogin) {
                    await ref.read(fetchF).signin(
                      _emailController.text, _passwordController.text);
                    await _geterror();
                  } else {
                    await ref.read(fetchF).signUp(
                      _emailController.text,
                      _passwordController.text,
                      _firstNameController.text,
                      _lastNameController.text,
                      profession,
                      specialty);
                    await _geterror();
                  }
                  setState(() {
                    _isLoading = false;
                  });
                  }
                },
                child: _isLoading
                  ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: ref.watch(colorF).colorsList["backgroundColor"],
                    ),
                    )
                  : Text(
                    isLogin ? 'Sign In' : 'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: ref.watch(colorF).colorsList["backgroundColor"],
                    ),
                    ),
              ),
              Text(
                  ref
                          .watch(fetchF)
                          .errorMessage
                          ?.split(', ')
                          .last
                          .trim()
                          .replaceAll("errorCode:", "")
                          .replaceAll("_", " ")
                          .replaceAll(")", "") ??
                      '',
                  style: TextStyle(color: Colors.red)),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLogin
                      ? 'Don\'t have an account? Sign Up'
                      : 'Already have an account? Sign In',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();

    super.dispose();
  }
}
