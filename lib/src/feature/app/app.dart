import 'package:aps_mobile/injection_container.dart' as di;
import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Текущая локаль и список поддерживаемых — прямо из провайдера
    final flutterLocale = TranslationProvider.of(context).flutterLocale;
    // final flutterLocales =
    //     TranslationProvider.of(context).flutterSupportedLocales;

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

        // Ключевые строки: локаль, список локалей и колбэк резолва
        locale: flutterLocale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        localeResolutionCallback: (locale, supported) {
          // Дадим шанс провайдеру отрезолвить, иначе — стандартно
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
        routes: {
          '/': (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return const MainView();
                }
                if (state is UnAuthenticated) {
                  return const LoginPage();
                }
                return const SizedBox.shrink();
              },
            );
          },
        },
      ),
    );
  }
}
