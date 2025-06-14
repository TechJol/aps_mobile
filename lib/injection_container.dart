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

  sl.registerFactory(
    () => AuthCubit(isLoggedInUsecase: sl.call(), logoutUsecase: sl.call()),
  );

  sl.registerFactory(
    () => IncomeCubit(
      addIncomeUsecase: sl.call(),
      getAccountUsecase: sl.call(),
      getIncomeExpenseReasonUsecase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => MenuCubit(
      getTransactionsUsecase: sl.call(),
      getPartnersUsecase: sl.call(),
      deletePartnerUsecase: sl.call(),
    ),
  );

  //! UseCase
  sl.registerLazySingleton(() => LoginUsecase(authRepository: sl.call()));
  sl.registerLazySingleton(() => RegisterUsecase(authRepository: sl.call()));
  sl.registerLazySingleton(() => LogoutUsecase(authRepository: sl.call()));
  sl.registerLazySingleton(() => IsLoggedInUsecase(authRepository: sl.call()));
  sl.registerLazySingleton(() => AddIncomeUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetAccountUsecase(repository: sl.call()));
  sl.registerLazySingleton(
    () => GetIncomeExpenseReasonUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton(() => GetTransactionsUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetPartnersUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeletePartnerUsecase(repository: sl.call()));

  //! Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl.call(),
      authLocalDataSource: sl.call(),
    ),
  );

  sl.registerLazySingleton<IncomeRepository>(
    () => IncomeRepositoryImpl(remoteIncomeDataSource: sl.call()),
  );

  sl.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(remoteMenuDataSource: sl.call()),
  );

  //! Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl.call()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<RemoteIncomeDataSource>(
    () => RemoteIncomeDataSourceImpl(dio: sl.call()),
  );

  sl.registerLazySingleton<RemoteMenuDataSource>(
    () => RemoteMenuDataSourceImpl(dio: sl.call()),
  );

  //! Network
  sl.registerSingleton<DioClient>(DioClient());

  //! External
  final dio = Dio();
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => dio);
  sl.registerLazySingleton(() => sharedPreferences);
}
