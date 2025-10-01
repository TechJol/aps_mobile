import 'package:aps_mobile/injection_container.dart' as di;
import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/core/network/in_app_date_service.dart';
import 'package:aps_mobile/src/feature/auth/presentation/pages/auth_pager_page.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final flutterLocale = TranslationProvider.of(context).flutterLocale;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<MainCubit>()),
        BlocProvider(create: (context) => di.sl<CredentialCubit>()),
        BlocProvider(create: (context) => di.sl<AuthCubit>()..appStarted()),
        BlocProvider(create: (context) => di.sl<IncomeCubit>()),
        BlocProvider(create: (context) => di.sl<MenuCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aps Mobile',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 147, 90, 246),
          ),
        ),
        locale: flutterLocale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        localeResolutionCallback: (locale, supported) {
          if (locale == null) return flutterLocale;
          for (final s in supported) {
            if (s.languageCode == locale.languageCode) return s;
          }
          return flutterLocale;
        },
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        onGenerateRoute: RouteGenerator.onGenerate,
        initialRoute: '/',

        // ✅ Важно: оборачиваем корневой экран в _UpdateOnce,
        // чтобы один раз за запуск проверить обновление.
        routes: {
          '/':
              (context) => _UpdateOnce(
                child: BlocListener<AuthCubit, AuthState>(
                  listenWhen: (previous, current) => current is UnAuthenticated,
                  listener: (context, state) {
                    context.read<MenuCubit>().reset();
                    context.read<IncomeCubit>().clearAll();
                    context.read<MainCubit>().reset();
                  },
                  child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is Authenticated) return const MainView();
                      if (state is UnAuthenticated) {
                        return const AuthPagerPage();
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
        },
      ),
    );
  }
}

/// Небольшой stateful-хук, который вызывает проверку обновлений один раз.
class _UpdateOnce extends StatefulWidget {
  final Widget child;
  const _UpdateOnce({required this.child});

  @override
  State<_UpdateOnce> createState() => _UpdateOnceState();
}

class _UpdateOnceState extends State<_UpdateOnce> {
  bool _called = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_called) return;
    _called = true;

    // Ждём первый кадр, чтобы context был полностью валиден.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Гибкое обновление (не блокирует UI). Если нужно принудительно — поставь immediate: true.
      InAppUpdateService.checkAndPrompt(context: context, immediate: false);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
