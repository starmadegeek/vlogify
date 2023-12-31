import 'package:fpdart/fpdart.dart';
import 'package:vlogify/core/utils/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
