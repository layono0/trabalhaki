import 'job.dart';
import 'candidate.dart';
import 'company.dart';

enum MatchStatus { active, interview, closed, rejected }
enum LikedStatus { liked, passed, saved }

class JobMatch {
  final String id;
  final Job job;
  final Candidate candidate;
  final DateTime matchedAt;
  final MatchStatus status;
  final bool hasUnreadMessage;

  const JobMatch({
    required this.id,
    required this.job,
    required this.candidate,
    required this.matchedAt,
    this.status = MatchStatus.active,
    this.hasUnreadMessage = false,
  });
}

class LikedJob {
  final String id;
  final Job job;
  final LikedStatus status;
  final DateTime likedAt;
  final MatchStatus? processStatus;

  const LikedJob({
    required this.id,
    required this.job,
    required this.status,
    required this.likedAt,
    this.processStatus,
  });
}

class ChatMessage {
  final String id;
  final String text;
  final bool isFromCandidate;
  final DateTime sentAt;
  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isFromCandidate,
    required this.sentAt,
    this.isRead = false,
  });
}

class Notification {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final NotificationType type;

  const Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    required this.type,
  });
}

enum NotificationType { newMatch, message, newJob, processUpdate }

extension NotificationTypeExt on NotificationType {
  String get icon {
    switch (this) {
      case NotificationType.newMatch: return '🎉';
      case NotificationType.message: return '💬';
      case NotificationType.newJob: return '✨';
      case NotificationType.processUpdate: return '📋';
    }
  }
}
