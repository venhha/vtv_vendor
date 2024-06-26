import 'package:vtv_common/core.dart';
import 'package:vtv_common/wallet.dart';

import '../../domain/repository/wallet_repository.dart';
import '../datasources/wallet_data_source.dart';

class VendorRepositoryImpl implements VendorRepository {
  VendorRepositoryImpl(this._dataSource);
  final WalletDataSource _dataSource;
  @override
  FRespData<WalletEntity> getWallet() async {
    return handleDataResponseFromDataSource(dataCallback: () => _dataSource.getWallet());
  }
}
