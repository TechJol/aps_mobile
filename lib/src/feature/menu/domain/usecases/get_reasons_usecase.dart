import 'package:aps_mobile/src/feature/menu/menu.dart';
import 'package:dartz/dartz.dart';

class GetReasonsUsecase {
  GetReasonsUsecase({required this.repository});

  final MenuRepository repository;

  Future<Either> call() async => await repository.getReasons();
}
