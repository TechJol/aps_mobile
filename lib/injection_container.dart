import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Bloc
  sl.registerFactory(() => MainCubit());

  sl.registerFactory(
    () => CredentialCubit(
      loginUsecase: sl.call(),
      registerUsecase: sl.call(),
      logoutUsecase: sl.call(),
      getUserByIdUsecase: sl.call(),
      deleteUserByIdUsecase: sl.call(),
      getStoredUserIdUsecase: sl.call(),
    ),
  );

  sl.registerLazySingleton(
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
    () => PaymentCubit(
      getPaymentPlansUsecase: sl.call(),
      getPaymentPeriodsUsecase: sl.call(),
      startPaymentUsecase: sl.call(),
      getSubscriptionsUsecase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => MenuCubit(
      getTransactionsUsecase: sl.call(),
      getPartnersUsecase: sl.call(),
      deletePartnerUsecase: sl.call(),
      postPartnerUsecase: sl.call(),
      updatePartnerUsecase: sl.call(),
      getPartnerTypesUsecase: sl.call(),
      deletePartnerTypeUsecase: sl.call(),
      postPartnerTypeUsecase: sl.call(),
      updatePartnerTypeUsecase: sl.call(),
      getAccountsUsecase: sl.call(),
      deleteAccountUsecase: sl.call(),
      updateAccountUsecase: sl.call(),
      deleteTransactionUsecase: sl.call(),
      postAccountUsecase: sl.call(),
      getReasonsUsecase: sl.call(),
      deleteReasonUsecase: sl.call(),
      updateReasonUsecase: sl.call(),
      postReasonUsecase: sl.call(),
      updateTransactionUsecase: sl.call(),
    ),
  );

  //! UseCase
  sl.registerLazySingleton(() => LoginUsecase(authRepository: sl.call()));
  sl.registerLazySingleton(() => RegisterUsecase(authRepository: sl.call()));
  sl.registerLazySingleton(() => GetUserByIdUsecase(authRepository: sl.call()));
  sl.registerLazySingleton(() => LogoutUsecase(authRepository: sl.call()));
  sl.registerLazySingleton(() => IsLoggedInUsecase(authRepository: sl.call()));
  sl.registerLazySingleton(() => AddIncomeUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetAccountUsecase(repository: sl.call()));
  sl.registerLazySingleton(
    () => GetIncomeExpenseReasonUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton(() => GetTransactionsUsecase(repository: sl.call()));
  sl.registerLazySingleton(
    () => UpdateTransactionUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton(
    () => DeleteTransactionUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton(() => GetPartnersUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeletePartnerUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => PostPartnerUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdatePartnerUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetPartnerTypesUsecase(repository: sl.call()));
  sl.registerLazySingleton(
    () => DeletePartnerTypeUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton(() => PostPartnerTypeUsecase(repository: sl.call()));
  sl.registerLazySingleton(
    () => UpdatePartnerTypeUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton(() => GetAccountsUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteAccountUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateAccountUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => PostAccountUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetReasonsUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteReasonUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateReasonUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => PostReasonUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteUserByIdUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetStoredUserIdUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetPaymentPlansUsecase(repository: sl.call()));
  sl.registerLazySingleton(
    () => GetPaymentPeriodsUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton(() => StartPaymentUsecase(repository: sl.call()));
  sl.registerLazySingleton(
    () => GetSubscriptionsUsecase(repository: sl.call()),
  );

  //! Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl.call(),
      authLocalDataSource: sl.call(),
      tokenStorage: sl.call(),
    ),
  );

  sl.registerLazySingleton<IncomeRepository>(
    () => IncomeRepositoryImpl(remoteIncomeDataSource: sl.call()),
  );

  sl.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(remoteMenuDataSource: sl.call()),
  );

  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(remoteDataSource: sl.call()),
  );

  //! Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl.call()),
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

  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(dio: sl.call()),
  );

  //! Network
  sl.registerSingleton<DioClient>(DioClient());

  //! External
  final dio = Dio();
  final storage = FlutterSecureStorage();
  final authTokenStorage = AuthTokenStorage();
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => dio);
  sl.registerLazySingleton(() => storage);
  sl.registerLazySingleton<AuthTokenStorage>(() => authTokenStorage);
  sl.registerLazySingleton<TokenStorage>(() => authTokenStorage);
  sl.registerLazySingleton(() => sharedPreferences);
}
