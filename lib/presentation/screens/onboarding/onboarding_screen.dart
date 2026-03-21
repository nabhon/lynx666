import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

import '../../../../data/datasources/supabase_client.dart';
import '../../../../domain/providers/profile_providers.dart';
import '../../../../domain/providers/repository_providers.dart';

class UsernameSetupScreen extends ConsumerStatefulWidget {
  const UsernameSetupScreen({super.key});

  @override
  ConsumerState<UsernameSetupScreen> createState() =>
      _UsernameSetupScreenState();
}

class _UsernameSetupScreenState extends ConsumerState<UsernameSetupScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  /// 🖼️ รูปจากเครื่อง (Web)
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isValidUsername(String username) {
    final regex = RegExp(r'^[a-zA-Zก-ฮ0-9]{4,20}$');
    return regex.hasMatch(username);
  }

  /// 📸 เลือกรูป (รองรับ Chrome)
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();

      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  /// 🔥 SnackBar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _submitUsername() async {
    final username = _controller.text.trim();

    if (username.isEmpty) {
      _showError('กรุณากรอกชื่อผู้ใช้');
      return;
    }

    if (!_isValidUsername(username)) {
      _showError('ชื่อผู้ใช้ต้องมี 4-20 ตัวอักษร');
      return;
    }

    setState(() => _isLoading = true);

    try {
      String avatarKey = 'default_avatar';

      // Upload avatar if user selected one
      if (_imageBytes != null) {
        try {
          // Upload avatar using repository directly (doesn't rely on ref after async)
          final userId = SupabaseInit.client.auth.currentUser?.id;
          if (userId == null) throw Exception('Not authenticated');

          final timestamp = DateTime.now().millisecondsSinceEpoch;
          avatarKey = 'avatars/$userId/$timestamp.png';

          final bucket = SupabaseInit.client.storage.from('profile_avatar');
          await bucket.uploadBinary(
            avatarKey,
            _imageBytes!,
            fileOptions: FileOptions(contentType: 'image/png'),
          );
        } catch (uploadError) {
          print('Upload error: $uploadError');
          // Continue with default avatar if upload fails
          avatarKey = 'default_avatar';
        }
      }

      // Check mounted after async gap
      if (!mounted) return;

      // Use repository directly instead of notifier
      final repository = ref.read(profileRepositoryProvider);
      final userId = SupabaseInit.client.auth.currentUser?.id;
      if (userId == null) throw Exception('Not authenticated');

      await repository.completeOnboarding(
        userId: userId,
        username: username,
        avatarKey: avatarKey,
      );

      // Check mounted after async gap before navigation
      if (!mounted) return;

      context.go('/home');
    } catch (e) {
      print('Onboarding error: $e');
      if (mounted) {
        _showError('เกิดข้อผิดพลาด: ${e.toString()}');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFFF8400);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// 🔤 Title
              const Text(
                "ตั้งชื่อผู้ใช้ของคุณ",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 40),

              /// 👤 Avatar (กดเลือกภาพได้)
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: orange, width: 5),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: const Color(0xFFEFEFEF),
                        backgroundImage: _imageBytes != null
                            ? MemoryImage(_imageBytes!)
                            : null,
                        child: _imageBytes == null
                            ? const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.blue,
                              )
                            : null,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: orange,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              const SizedBox(
                height: 50,
                child: Text(
                  "รูปโปรไฟล์",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 62, 62, 62),
                  ),
                ),
              ),

              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: double.infinity),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // ⭐ สำคัญ
                    children: [
                      const Text(
                        "ชื่อผู้ใช้งาน",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 62, 62, 62),
                        ),
                      ),

                      const SizedBox(height: 6),

                      TextField(
                        controller: _controller,
                        enabled: !_isLoading,
                        decoration: InputDecoration(
                          hintText: "กรอกชื่อผู้ใช้",
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 10,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Color(0xFFFF8400),
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Color(0xFFFF8400),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// Helper
              const SizedBox(
                width: 280,
                child: Text(
                  "ใช้ได้เฉพาะ a-z, 0-9, ก-ฮ (4-20 ตัว)",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),

              const Spacer(),

              /// 🚀 Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitUsername,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          "ถัดไป",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
