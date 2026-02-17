import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: BlocListener<CredentialCubit, CredentialState>(
        listener: (context, state) {
          if (state is CredentialSuccess) {
            // Явно выходим из Auth и отправляем на корневой маршрут
            context.read<AuthCubit>().logout();
            Navigator.of(
              context,
            ).pushReplacementNamed('/'); // покажет LoginPage
          }
          if (state is UserFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${t.menu.error}: ${state.errorMessage}')),
            );
          }
        },
        child: BlocBuilder<CredentialCubit, CredentialState>(
          builder: (context, state) {
            if (state is CredentialLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CredentialFailure) {
              return Center(
                child: Text('${t.menu.error}: ${state.errorMessage}'),
              );
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
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        const SizedBox(height: 120),

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
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                  ),
                ),
              ),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
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

        _buildTextField(context: context, label: user.username),
        const SizedBox(height: 30),
        _buildTextField(context: context, label: user.email ?? ''),
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
                      accountName: t.menu.profile.account,
                      onConfirm: () async {
                        // Только запускаем удаление. Навигацию делает BlocListener.
                        context.read<CredentialCubit>().deleteUserById();
                      },
                      title: t.menu.profile.deleteAccount,
                    );
                  },
                  // onPressed:
                  //     () => context.read<CredentialCubit>().deleteUserById(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.surfaceContainerHighest,
                    foregroundColor: scheme.onSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: scheme.outlineVariant),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    t.menu.profile.deleteAccount,
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
                  child: Text(
                    t.menu.profile.next,
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
    required BuildContext context,
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
          labelStyle: AppTextStyles.f16w500.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: AppColors.primaryColorLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              width: 1,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          labelText: label,
        ),
      ),
    );
  }
}
