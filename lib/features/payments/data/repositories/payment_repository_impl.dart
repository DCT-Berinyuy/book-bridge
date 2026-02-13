import 'package:book_bridge/core/error/exceptions.dart';
import 'package:book_bridge/core/error/failures.dart';
import 'package:book_bridge/features/payments/data/datasources/campay_data_source.dart';
import 'package:book_bridge/features/payments/domain/repositories/payment_repository.dart';
import 'package:dartz/dartz.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final CamPayDataSource _dataSource;

  PaymentRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, String>> collect({
    required int amount,
    required String phoneNumber,
    required String externalReference,
  }) async {
    try {
      final result = await _dataSource.collect(
        amount: amount,
        phoneNumber: phoneNumber,
        externalReference: externalReference,
      );

      // CamPay returns reference in the response body
      final reference = result['reference'] as String?;
      if (reference != null) {
        return Right(reference);
      } else {
        return const Left(
          ServerFailure(message: 'No reference returned from CamPay'),
        );
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getTransactionStatus(String reference) async {
    try {
      final result = await _dataSource.getTransactionStatus(reference);
      final status = result['status'] as String?;

      if (status != null) {
        return Right(status);
      } else {
        return const Left(
          ServerFailure(message: 'No status returned from CamPay'),
        );
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
