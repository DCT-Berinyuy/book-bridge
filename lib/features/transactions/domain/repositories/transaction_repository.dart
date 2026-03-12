import 'package:dartz/dartz.dart';
import 'package:book_bridge/core/error/failures.dart';
import 'package:book_bridge/features/transactions/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  /// Returns all transactions where the user is the buyer.
  Future<Either<Failure, List<TransactionEntity>>> getPurchases(String userId);

  /// Returns all transactions where the user is the seller.
  Future<Either<Failure, List<TransactionEntity>>> getSales(String userId);

  /// Find a transaction by its external reference.
  Future<Either<Failure, TransactionEntity>> getTransactionByExternalRef(
    String externalRef,
  );
}
