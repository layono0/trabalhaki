import '../../models/match.dart';
import '../../models/job.dart';
import 'mock_jobs.dart';
import 'mock_candidates.dart';

class MockData {
  static List<JobMatch> get matches => [
    JobMatch(
      id: 'm1',
      job: MockJobs.all[0],
      candidate: MockCandidates.mainCandidate,
      matchedAt: DateTime.now().subtract(const Duration(hours: 2)),
      status: MatchStatus.active,
      hasUnreadMessage: true,
    ),
    JobMatch(
      id: 'm2',
      job: MockJobs.all[2],
      candidate: MockCandidates.mainCandidate,
      matchedAt: DateTime.now().subtract(const Duration(days: 1)),
      status: MatchStatus.interview,
      hasUnreadMessage: false,
    ),
    JobMatch(
      id: 'm3',
      job: MockJobs.all[4],
      candidate: MockCandidates.mainCandidate,
      matchedAt: DateTime.now().subtract(const Duration(days: 3)),
      status: MatchStatus.active,
      hasUnreadMessage: false,
    ),
  ];

  static List<LikedJob> get likedJobs => [
    LikedJob(
      id: 'l1',
      job: MockJobs.all[0],
      status: LikedStatus.liked,
      likedAt: DateTime.now().subtract(const Duration(hours: 2)),
      processStatus: MatchStatus.active,
    ),
    LikedJob(
      id: 'l2',
      job: MockJobs.all[2],
      status: LikedStatus.liked,
      likedAt: DateTime.now().subtract(const Duration(days: 1)),
      processStatus: MatchStatus.interview,
    ),
    LikedJob(
      id: 'l3',
      job: MockJobs.all[4],
      status: LikedStatus.liked,
      likedAt: DateTime.now().subtract(const Duration(days: 3)),
      processStatus: MatchStatus.active,
    ),
    LikedJob(
      id: 'l4',
      job: MockJobs.all[6],
      status: LikedStatus.liked,
      likedAt: DateTime.now().subtract(const Duration(days: 5)),
      processStatus: MatchStatus.closed,
    ),
    LikedJob(
      id: 'l5',
      job: MockJobs.all[7],
      status: LikedStatus.saved,
      likedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  static List<ChatMessage> getMessages(String matchId) {
    if (matchId == 'm1') {
      return [
        ChatMessage(
          id: 'msg1',
          text: 'Olá, Lucas! Ficamos muito animados com seu perfil. Você tem interesse em conversar sobre a vaga de Desenvolvedor Flutter?',
          isFromCandidate: false,
          sentAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg2',
          text: 'Olá! Claro, tenho muito interesse. A vaga parece perfeita para o meu momento de carreira.',
          isFromCandidate: true,
          sentAt: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg3',
          text: 'Ótimo! Para dar continuidade, podemos agendar uma conversa com nosso time de Pessoas para esta semana. Quarta ou quinta funcionam para você?',
          isFromCandidate: false,
          sentAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg4',
          text: 'Quinta-feira funciona muito bem! A partir das 14h estou disponível.',
          isFromCandidate: true,
          sentAt: DateTime.now().subtract(const Duration(minutes: 30)),
          isRead: false,
        ),
      ];
    }
    if (matchId == 'm2') {
      return [
        ChatMessage(
          id: 'msg10',
          text: 'Oi Lucas, tudo bem? Vi seu perfil e acreditamos que você tem muito a oferecer para o nosso time de Frontend!',
          isFromCandidate: false,
          sentAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg11',
          text: 'Olá! Muito obrigado pelo interesse. Tenho bastante interesse na oportunidade.',
          isFromCandidate: true,
          sentAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg12',
          text: 'Que bom! Já avançamos para a etapa de entrevista técnica. Enviamos um desafio para seu email. Prazo de 3 dias. Pode dar uma olhada?',
          isFromCandidate: false,
          sentAt: DateTime.now().subtract(const Duration(hours: 20)),
          isRead: true,
        ),
      ];
    }
    return [];
  }

  static List<Notification> get notifications => [
    Notification(
      id: 'n1',
      title: 'Novo Match!',
      body: 'Você e Nubank tiveram um match para a vaga de Desenvolvedor Flutter Júnior.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.newMatch,
    ),
    Notification(
      id: 'n2',
      title: 'iFood respondeu',
      body: 'A equipe de iFood enviou uma mensagem sobre sua candidatura.',
      createdAt: DateTime.now().subtract(const Duration(hours: 20)),
      type: NotificationType.message,
      isRead: true,
    ),
    Notification(
      id: 'n3',
      title: 'Nova vaga compatível',
      body: 'Encontramos 3 novas vagas de Flutter que combinam com seu perfil.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.newJob,
      isRead: true,
    ),
    Notification(
      id: 'n4',
      title: 'Atualização de processo',
      body: 'Sua candidatura para Developer Frontend no iFood avançou para a etapa de entrevista técnica!',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.processUpdate,
      isRead: true,
    ),
  ];
}
