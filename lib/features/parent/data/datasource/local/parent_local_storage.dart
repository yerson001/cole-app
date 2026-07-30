import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coleapp/features/parent/data/models/branch_model.dart';

class ParentLocalStorage {
  final String _branchKey = 'parent_branch';

  Future<void> saveBranch(BranchModel branch) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_branchKey, json.encode(branch.toJson()));
  }

  Future<BranchModel?> getBranch() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(_branchKey);
    if (val != null) {
      return BranchModel.fromJson(json.decode(val));
    }
    return null;
  }

  Future<bool> removeBranch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(_branchKey);
  }
}
