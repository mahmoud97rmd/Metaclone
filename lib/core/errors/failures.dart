import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? message;
  const Failure({this.message});
  
  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Network error occurred'});
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({super.message = 'Server error occurred', this.statusCode});
  
  @override
  List<Object?> get props => [message, statusCode];
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error occurred'});
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({super.message = 'Authentication failed'});
}

class TradingFailure extends Failure {
  final String? errorCode;
  const TradingFailure({super.message = 'Trading operation failed', this.errorCode});
  
  @override
  List<Object?> get props => [message, errorCode];
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Validation error'});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'An unknown error occurred'});
}

class ParsingFailure extends Failure {
  const ParsingFailure({super.message = 'Data parsing failed'});
}
