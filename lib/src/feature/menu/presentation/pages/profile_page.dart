import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: BlocListener<CredentialCubit, CredentialState>(
        listener: (context, state) {
          if (state is CredentialSuccess) {
            Navigator.of(context).pushReplacementNamed('/'); // или '/login'
          }
          if (state is UserFailure) {
            Center(child: Text('Ошибка: ${state.errorMessage}'));
          }
        },
        child: BlocBuilder<CredentialCubit, CredentialState>(
          builder: (context, state) {
            if (state is CredentialLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CredentialFailure) {
              return Center(child: Text('Ошибка: ${state.errorMessage}'));
            }

            if (state is CredentialUserLoaded) {
              final user = state.user;

              return _buildContent(context, user);
            }

            return const SizedBox(); // initial
          },
        ),
      ),
    );
  }

  Column _buildContent(BuildContext context, AuthEntity user) {
    return Column(
      children: [
        const SizedBox(height: 120),

        // Avatar and white background
        Center(
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 90,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                  ),
                ),
              ),
              Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset('assets/icons/profile_user.svg'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        _buildTextField(label: user.username),
        const SizedBox(height: 30),
        _buildTextField(label: user.email ?? ''),
        const SizedBox(height: 32),

        SizedBox(height: 290),

        // Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // Exit button
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    ShowSheet().showDeleteDialog(
                      context,
                      accountName: 'аккаунт',
                      onConfirm: () async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        context.read<CredentialCubit>().deleteUserById();
                        Navigator.of(context).pushReplacementNamed('/');
                        await pref.clear();
                      },
                      title: 'Удалить аккаунт',
                    );
                  },
                  // onPressed:
                  //     () => context.read<CredentialCubit>().deleteUserById(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.blackColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppColors.transparentColor),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Удалить аккаунт',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Next button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF661EFB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Далее',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        readOnly: true,
        controller: controller,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          labelStyle: AppTextStyles.f16w500,
          fillColor: AppColors.backroundColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: AppColors.primaryColorLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              width: 1,
              color: AppColors.backroundColor,
            ),
          ),
          labelText: label,
        ),
      ),
    );
  }
}
