import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Bloc
  sl.registerFactory(() => MainCubit());

  sl.registerFactory(
    () => CredentialCubit(
      loginUsecase: sl.call(),
      registerUsecase: sl.call(),
      logoutUsecase: sl.call(),
    ),
  );

  sl.registerFactory(() => AuthCubit(isLoggedInUsecase: sl.call()));

  //! UseCase
  sl.registerLazySingleton(() => LoginUsecase(authRepository: sl.call()));
  sl.registerLazySingleton(() => RegisterUsecase(authRepository: sl.call()));
  sl.registerLazySingleton(() => LogoutUsecase(authRepository: sl.call()));
  sl.registerLazySingleton(() => IsLoggedInUsecase(authRepository: sl.call()));

  //! Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl.call(),
      authLocalDataSource: sl.call(),
    ),
  );

  //! Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl.call()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  //! Network
  sl.registerSingleton<DioClient>(DioClient());

  //! External
  final dio = Dio();
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => dio);
  sl.registerLazySingleton(() => sharedPreferences);
}
