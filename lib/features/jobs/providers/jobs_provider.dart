import 'package:flutter/foundation.dart';

import '../../../data/mock/mock_data.dart';
import '../../../data/mock/mock_jobs.dart';
import '../../../models/candidate.dart';
import '../../../models/job.dart';
import '../../../models/match.dart';

class JobsProvider extends ChangeNotifier {
  List<Job> _allJobs = [];
  List<Job> _swipeJobs = [];
  List<LikedJob> _likedJobs = [];
  List<JobMatch> _matches = [];
  List<Notification> _notifications = [];
  
  // Filters
  String? _filterModality;
  String? _filterLevel;
  String? _filterContract;
  String? _filterArea;
  double? _filterMinSalary;
  double? _filterMaxSalary;
  String _sortBy = 'Mais relevantes';

  bool _isLoading = false;

  List<Job> get swipeJobs => _swipeJobs;
  List<LikedJob> get likedJobs => _likedJobs;
  List<JobMatch> get matches => _matches;
  List<Notification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String get sortBy => _sortBy;
  int get unreadNotifications => _notifications.where((n) => !n.isRead).length;
  int get unreadMatches => _matches.where((m) => m.hasUnreadMessage).length;

  String? get filterModality => _filterModality;
  String? get filterLevel => _filterLevel;
  String? get filterContract => _filterContract;
  String? get filterArea => _filterArea;

  void init() {
    _allJobs = MockJobs.all;
    _swipeJobs = List.from(_allJobs);
    _likedJobs = MockData.likedJobs;
    _matches = MockData.matches;
    _notifications = MockData.notifications;
    notifyListeners();
  }

  void swipeRight(String jobId) {
    final job = _swipeJobs.firstWhere((j) => j.id == jobId, orElse: () => _allJobs.first);
    _swipeJobs.removeWhere((j) => j.id == jobId);
    
    final liked = LikedJob(
      id: 'l_${jobId}_${DateTime.now().millisecondsSinceEpoch}',
      job: job,
      status: LikedStatus.liked,
      likedAt: DateTime.now(),
    );
    _likedJobs.insert(0, liked);
    
    // 30% chance of instant match for demo
    final shouldMatch = _matches.isEmpty || jobId == 'j3';
    if (shouldMatch) {
      _triggerMatch(job);
    }
    
    notifyListeners();
  }

  void swipeLeft(String jobId) {
    _swipeJobs.removeWhere((j) => j.id == jobId);
    notifyListeners();
  }

  void saveMaybe(String jobId) {
    final job = _swipeJobs.firstWhere((j) => j.id == jobId, orElse: () => _allJobs.first);
    _swipeJobs.removeWhere((j) => j.id == jobId);
    
    final liked = LikedJob(
      id: 'ls_${jobId}_${DateTime.now().millisecondsSinceEpoch}',
      job: job,
      status: LikedStatus.saved,
      likedAt: DateTime.now(),
    );
    _likedJobs.insert(0, liked);
    notifyListeners();
  }

  void _triggerMatch(Job job) {
    // Will be handled via callback in the UI
    _pendingMatch = job;
  }

  Job? _pendingMatch;
  Job? get pendingMatch => _pendingMatch;

  void clearPendingMatch() {
    _pendingMatch = null;
    notifyListeners();
  }

  void confirmMatch(Job job) {
    final match = JobMatch(
      id: 'match_${job.id}_${DateTime.now().millisecondsSinceEpoch}',
      job: job,
      candidate: const Candidate(
        id: 'cand1',
        name: 'Lucas Mendes',
        email: '',
        desiredRole: '',
        area: '',
        level: ExperienceLevel.junior,
        city: '',
        state: '',
        preferredModalities: [],
        preferredContractTypes: [],
        bio: '',
        experiences: [],
        education: [],
        skills: [],
        profileCompleteness: 85,
      ),
      matchedAt: DateTime.now(),
    );
    _matches.insert(0, match);
    notifyListeners();
  }

  void resetSwipeJobs() {
    _swipeJobs = List.from(_allJobs);
    notifyListeners();
  }

  void setFilter({
    String? modality,
    String? level,
    String? contract,
    String? area,
    double? minSalary,
    double? maxSalary,
  }) {
    _filterModality = modality;
    _filterLevel = level;
    _filterContract = contract;
    _filterArea = area;
    _filterMinSalary = minSalary;
    _filterMaxSalary = maxSalary;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _filterModality = null;
    _filterLevel = null;
    _filterContract = null;
    _filterArea = null;
    _filterMinSalary = null;
    _filterMaxSalary = null;
    _swipeJobs = List.from(_allJobs);
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    notifyListeners();
  }

  void _applyFilters() {
    _swipeJobs = _allJobs.where((job) {
      if (_filterModality != null) {
        if (job.modality.label != _filterModality) return false;
      }
      if (_filterLevel != null) {
        if (job.level.label != _filterLevel) return false;
      }
      if (_filterContract != null) {
        if (job.contractType.label != _filterContract) return false;
      }
      if (_filterArea != null) {
        if (job.area != _filterArea) return false;
      }
      if (_filterMinSalary != null && job.salaryMin != null) {
        if (job.salaryMin! < _filterMinSalary!) return false;
      }
      return true;
    }).toList();
  }

  void markNotificationsRead() {
    _notifications = _notifications.map((n) => Notification(
      id: n.id,
      title: n.title,
      body: n.body,
      createdAt: n.createdAt,
      isRead: true,
      type: n.type,
    )).toList();
    notifyListeners();
  }

  List<ChatMessage> getMessages(String matchId) {
    return MockData.getMessages(matchId);
  }

  void sendMessage(String matchId, String text) {
    // Mock implementation
  }
}
