class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'Trabalhaki';
  static const String appTagline = 'Encontre oportunidades. Encontre seu match.';
  static const String appVersion = '1.0.0';

  // Mock credentials
  static const String candidateEmail = 'candidato@trabalhaki.com';
  static const String candidatePassword = '123456';
  static const String companyEmail = 'empresa@trabalhaki.com';
  static const String companyPassword = '123456';

  // Animation durations
  static const Duration splashDuration = Duration(milliseconds: 2500);
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
  static const Duration extraLongAnimation = Duration(milliseconds: 800);

  // Card swipe thresholds
  static const double swipeThreshold = 0.3;
  static const double cardRotationAngle = 0.05; // radians

  // Spacing
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Border radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusCard = 28.0;
  static const double radiusCircle = 100.0;

  // Shadows
  static const List<double> shadowOffset = [0, 4];
  static const double shadowBlur = 20.0;
  static const double shadowOpacity = 0.06;

  // Z-index layers
  static const int zBackground = 0;
  static const int zContent = 1;
  static const int zCard = 2;
  static const int zOverlay = 3;
  static const int zModal = 4;
  static const int zToast = 5;

  // Work modalities
  static const List<String> modalities = ['Remoto', 'Híbrido', 'Presencial'];

  // Contract types
  static const List<String> contractTypes = [
    'CLT',
    'PJ',
    'Estágio',
    'Jovem Aprendiz',
    'Temporário',
  ];

  // Experience levels
  static const List<String> experienceLevels = [
    'Estágio',
    'Júnior',
    'Pleno',
    'Sênior',
    'Especialista',
  ];

  // Professional areas
  static const List<String> professionalAreas = [
    'Tecnologia da Informação',
    'Desenvolvimento de Software',
    'Design',
    'Marketing Digital',
    'Dados e Analytics',
    'Infraestrutura / DevOps',
    'Gestão de Projetos',
    'RH / People',
    'Vendas',
    'Suporte Técnico',
    'Financeiro',
    'Jurídico',
    'Operações',
    'Produto',
  ];

  // Company sizes
  static const List<String> companySizes = [
    'Startup (1-10)',
    'Pequena (11-50)',
    'Média (51-200)',
    'Grande (201-1000)',
    'Enterprise (1000+)',
  ];

  // Benefits options
  static const List<String> benefitOptions = [
    'Vale Alimentação',
    'Vale Refeição',
    'Vale Transporte',
    'Plano de Saúde',
    'Plano Odontológico',
    'Seguro de Vida',
    'Auxílio Home Office',
    'Gympass / Wellhub',
    'PLR',
    'Stock Options',
    'Flexibilidade de Horário',
    'Day Off no Aniversário',
    'Bolsa de Estudos',
    'Cursos e Certificações',
    'Equipamento fornecido',
    'Celular corporativo',
  ];

  // Sort options
  static const List<String> sortOptions = [
    'Mais relevantes',
    'Mais recentes',
    'Maior salário',
    'Menor salário',
  ];
}
