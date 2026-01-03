/// ═══════════════════════════════════════════════════════════
/// UseCase - Base class for all use cases
/// Clean Architecture Pattern
/// ═══════════════════════════════════════════════════════════

import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Base UseCase with parameters
/// [Type] - نوع البيانات المُرجعة
/// [Params] - معاملات الدخل
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// UseCase بدون معاملات
abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}

/// UseCase يرجع Stream (للبيانات الحية)
abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

/// No parameters class
class NoParams {
  const NoParams();
}
