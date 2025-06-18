import 'package:flutter/material.dart';

enum AccountType {
  treasurer(name: 'Treasurer'),
  leader(name: 'Leader');

  final String name;
  const AccountType({required this.name});
}

class AccountTypeService extends ChangeNotifier {
  AccountType _accountType = AccountType.treasurer;

  AccountType get accountType => _accountType;

  void setAccountType(AccountType type) {
    _accountType = type;
    notifyListeners();
  }

  String get accountTypeName => _accountType.name;

  bool get isTreasurer => _accountType == AccountType.treasurer;

  bool get isLeader => _accountType == AccountType.leader;
}
