import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Bloc
  sl.registerFactory(() => MainCubit());

  sl.registerFactory(
    () => CredentialCubit(loginUsecase: sl(), registerUsecase: sl()),
  );

  //! UseCase
  sl.registerLazySingleton(() => LoginUsecase(authRepository: sl()));
  sl.registerLazySingleton(() => RegisterUsecase(authRepository: sl()));

  //! Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemoteDataSource: sl.call()),
  );

  //! Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  //! Network
  sl.registerSingleton<DioClient>(DioClient());

  //! External
  final dio = Dio();

  sl.registerLazySingleton(() => dio);
}
