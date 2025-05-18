import 'package:aps_mobile/src/feature/feature.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Bloc
  sl.registerFactory(() => MainCubit());
}
