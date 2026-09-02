import '../../models/candidate.dart';
import '../../models/job.dart';

class MockCandidates {
  static final Candidate mainCandidate = Candidate(
    id: 'cand1',
    name: 'Lucas Mendes',
    email: 'candidato@trabalhaki.com',
    photoUrl: 'https://picsum.photos/seed/lucas-dev-profile/300/300',
    desiredRole: 'Desenvolvedor Mobile Flutter',
    area: 'Desenvolvimento de Software',
    level: ExperienceLevel.junior,
    city: 'São Paulo',
    state: 'SP',
    preferredModalities: [JobModality.hybrid, JobModality.remote],
    salaryExpectation: 6000,
    preferredContractTypes: [ContractType.clt],
    bio:
        'Desenvolvedor apaixonado por criar experiências mobile fluidas e intuitivas. Acredito que bom software é aquele que as pessoas mal percebem que estão usando.',
    experiences: const [
      WorkExperience(
        role: 'Estagiário de Desenvolvimento',
        company: 'Boa Compra Tecnologia',
        period: 'Jan 2023 - Dez 2023',
        description:
            'Desenvolvimento de features no app mobile e manutenção de APIs REST em Node.js.',
      ),
      WorkExperience(
        role: 'Freelancer Mobile',
        company: 'Autônomo',
        period: 'Mar 2024 - Presente',
        description:
            'Desenvolvimento de aplicativos Flutter para clientes de pequeno e médio porte.',
      ),
    ],
    education: const [
      Education(
        degree: 'Bacharelado em Ciência da Computação',
        institution: 'USP - Universidade de São Paulo',
        period: '2021 - 2025 (cursando)',
      ),
    ],
    skills: [
      'Flutter',
      'Dart',
      'Firebase',
      'REST APIs',
      'Git',
      'Node.js',
      'JavaScript',
      'UI/UX Design',
    ],
    profileCompleteness: 85,
  );
}
