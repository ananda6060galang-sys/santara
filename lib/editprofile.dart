import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController =
      TextEditingController(text: "Floyd Miles");

  final TextEditingController _emailController =
      TextEditingController(text: "felicia.reid@example.com");

  final TextEditingController _phoneController =
      TextEditingController(text: "(217) 555–0113");

  final TextEditingController _locationController =
      TextEditingController(text: "Jl. Kenanga Raya 15, Bandung");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 24),

              /// HEADER (BACK DI KIRI, TITLE TETAP CENTER)
              SizedBox(
                height: 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: Color(0xFF8B5A3C),
                        ),
                      ),
                    ),
                    const Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF8B5A3C),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// PROFILE IMAGE
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/profile.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF8B5A3C),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              _buildInputField("Nama", _nameController),
              const SizedBox(height: 20),

              _buildInputField("E-mail", _emailController),
              const SizedBox(height: 20),

              _buildInputField("Nomor", _phoneController),
              const SizedBox(height: 20),

              _buildInputField("Lokasi", _locationController),
              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5A3C),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Simpan Perubahan",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.4,
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

  Widget _buildInputField(
      String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: const Color(0xFF8B5A3C).withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C2C2C),
          ),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 12),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF8B5A3C),
                width: 1,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF8B5A3C),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
