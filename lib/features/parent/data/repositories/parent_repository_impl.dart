import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/datasource/local/parent_local_storage.dart';
import 'package:coleapp/features/parent/data/datasource/remote/parent_service.dart';
import 'package:coleapp/features/parent/data/models/branch_model.dart';
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class ParentRepositoryImpl implements ParentRepository {
  final ParentService _service;
  final ParentLocalStorage _storage;

  ParentRepositoryImpl({
    required ParentService service,
    required ParentLocalStorage storage,
  })  : _service = service,
        _storage = storage;

  @override
  Future<Resource<BranchModel>> getBranch(int id,
      {required String tenantId}) async {
    try {
      final local = await _storage.getBranch();
      if (local != null) {
        final remote = await _service.getBranch(id, tenantId: tenantId);
        await _storage.saveBranch(remote);
        return SuccessResource(remote);
      }
      final remote = await _service.getBranch(id, tenantId: tenantId);
      await _storage.saveBranch(remote);
      return SuccessResource(remote);
    } catch (e) {
      final local = await _storage.getBranch();
      if (local != null) {
        return SuccessResource(local);
      }
      return ErrorResource(e.toString());
    }
  }

  @override
  Future<void> clearBranch() async {
    final branch = await _storage.getBranch();
    if (branch?.urlLogo != null) {
      await DefaultCacheManager().removeFile(branch!.urlLogo!);
    }
    await _storage.removeBranch();
  }
}
