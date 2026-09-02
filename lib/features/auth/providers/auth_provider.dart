import 'package:flutter/foundation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/mock/mock_candidates.dart';
import '../../../models/candidate.dart';
import '../../../models/job.dart';

enum UserType { candidate, company, none }

class AuthProvider extends ChangeNotifier {
  UserType _userType = UserType.none;
  bool _isLoggedIn = false;
  Candidate? _currentCandidate;
  String? _error;
  bool _isLoading = false;

  UserType get userType => _userType;
  bool get isLoggedIn => _isLoggedIn;
  Candidate? get currentCandidate => _currentCandidate;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isCandidate => _userType == UserType.candidate;
  bool get isCompany => _userType == UserType.company;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    if (email == AppConstants.candidateEmail && password == AppConstants.candidatePassword) {
      _isLoggedIn = true;
      _userType = UserType.candidate;
      _currentCandidate = MockCandidates.mainCandidate;
      _isLoading = false;
      notifyListeners();
      return true;
    } else if (email == AppConstants.companyEmail && password == AppConstants.companyPassword) {
      _isLoggedIn = true;
      _userType = UserType.company;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Email ou senha incorretos. Tente candidato@trabalhaki.com / 123456';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> registerCandidate({
    required String name,
    required String email,
    required String password,
    required String desiredRole,
    required String area,
    required ExperienceLevel level,
    required String city,
    required String state,
    required List<JobModality> modalities,
    double? salaryExpectation,
    required List<ContractType> contractTypes,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    _isLoggedIn = true;
    _userType = UserType.candidate;
    _currentCandidate = Candidate(
      id: 'new_cand',
      name: name,
      email: email,
      desiredRole: desiredRole,
      area: area,
      level: level,
      city: city,
      state: state,
      preferredModalities: modalities,
      salaryExpectation: salaryExpectation,
      preferredContractTypes: contractTypes,
      bio: '',
      experiences: const [],
      education: const [],
      skills: const [],
      profileCompleteness: 60,
    );
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> registerCompany({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    _isLoggedIn = true;
    _userType = UserType.company;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _isLoggedIn = false;
    _userType = UserType.none;
    _currentCandidate = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
