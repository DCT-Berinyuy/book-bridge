import 'package:flutter/material.dart';
import 'package:book_bridge/features/transactions/domain/entities/transaction_entity.dart';
import 'package:book_bridge/features/transactions/domain/usecases/get_user_transactions_usecase.dart';

enum TransactionLoadState { idle, loading, loaded, error }

class TransactionHistoryViewModel extends ChangeNotifier {
  final GetUserTransactionsUseCase useCase;

  TransactionHistoryViewModel({required this.useCase});

  TransactionLoadState _state = TransactionLoadState.idle;
  List<TransactionEntity> _purchases = [];
  List<TransactionEntity> _sales = [];
  String? _error;

  TransactionLoadState get state => _state;
  List<TransactionEntity> get purchases => _purchases;
  List<TransactionEntity> get sales => _sales;
  String? get error => _error;

  Future<void> load(String userId) async {
    _state = TransactionLoadState.loading;
    _error = null;
    notifyListeners();

    final purchasesResult = await useCase.purchases(userId);
    final salesResult = await useCase.sales(userId);

    purchasesResult.fold(
      (failure) => _error = failure.message,
      (data) => _purchases = data,
    );

    salesResult.fold(
      (failure) => _error ??= failure.message,
      (data) => _sales = data,
    );

    _state = TransactionLoadState.loaded;
    notifyListeners();
  }
}
