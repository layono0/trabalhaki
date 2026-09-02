import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/job.dart';
import '../../../widgets/common/app_button.dart';
import '../../../widgets/common/app_text_field.dart';
import '../providers/auth_provider.dart';

class RegisterCandidateScreen extends StatefulWidget {
  const RegisterCandidateScreen({super.key});

  @override
  State<RegisterCandidateScreen> createState() => _RegisterCandidateScreenState();
}

class _RegisterCandidateScreenState extends State<RegisterCandidateScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  // Step 1
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthDateController = TextEditingController();

  // Step 2
  final _roleController = TextEditingController();
  String? _selectedArea;
  ExperienceLevel? _selectedLevel;
  final _cityController = TextEditingController();
  String? _selectedState;

  // Step 3
  final Set<JobModality> _selectedModalities = {};
  final _salaryController = TextEditingController();
  final Set<ContractType> _selectedContractTypes = {};

  // Step 4
  final _bioController = TextEditingController();

  bool _obscurePassword = true;

  final List<String> _states = ['SP', 'RJ', 'MG', 'RS', 'PR', 'SC', 'BA', 'PE', 'CE', 'DF'];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _birthDateController.dispose();
    _roleController.dispose();
    _cityController.dispose();
    _salaryController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _register();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.pop();
    }
  }

  Future<void> _register() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.registerCandidate(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      desiredRole: _roleController.text.trim(),
      area: _selectedArea ?? 'Tecnologia',
      level: _selectedLevel ?? ExperienceLevel.junior,
      city: _cityController.text.trim(),
      state: _selectedState ?? 'SP',
      modalities: _selectedModalities.toList(),
      salaryExpectation: double.tryParse(
        _salaryController.text.replaceAll('.', '').replaceAll(',', '.'),
      ),
      contractTypes: _selectedContractTypes.toList(),
    );

    if (mounted && success) {
      context.go('/candidate-home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with progress
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: _prevPage,
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const Spacer(),
                      Text(
                        '${_currentPage + 1} de $_totalPages',
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _totalPages,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.border,
                      dotHeight: 6,
                      dotWidth: 6,
                      expansionFactor: 4,
                    ),
                  ),
                ],
              ),
            ),

            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _buildStep1(),
                  _buildStep2(),
                  _buildStep3(),
                  _buildStep4(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _stepHeader('Informações pessoais', 'Vamos começar com o básico.'),
          const SizedBox(height: 32),
          AppTextField(
            label: 'Nome completo',
            hint: 'Lucas Mendes',
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Email',
            hint: 'lucas@email.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Senha',
            hint: 'Mínimo 6 caracteres',
            controller: _passwordController,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 20,
                color: AppColors.textTertiary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Data de nascimento',
            hint: 'dd/mm/aaaa',
            controller: _birthDateController,
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(height: 32),
          AppButton(label: 'Continuar', onTap: _nextPage),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _stepHeader('Perfil profissional', 'Nos conte sobre sua carreira.'),
          const SizedBox(height: 32),
          AppTextField(
            label: 'Cargo desejado',
            hint: 'Desenvolvedor Flutter',
            controller: _roleController,
          ),
          const SizedBox(height: 16),
          _dropdownField(
            label: 'Área profissional',
            hint: 'Selecione uma área',
            value: _selectedArea,
            items: AppConstants.professionalAreas,
            onChanged: (v) => setState(() => _selectedArea = v),
          ),
          const SizedBox(height: 16),
          _labelText('Nível de experiência'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ExperienceLevel.values.map((level) {
              final selected = _selectedLevel == level;
              return GestureDetector(
                onTap: () => setState(() => _selectedLevel = level),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    level.label,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Cidade',
            hint: 'São Paulo',
            controller: _cityController,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          _dropdownField(
            label: 'Estado',
            hint: 'SP',
            value: _selectedState,
            items: _states,
            onChanged: (v) => setState(() => _selectedState = v),
          ),
          const SizedBox(height: 32),
          AppButton(label: 'Continuar', onTap: _nextPage),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _stepHeader('Suas preferências', 'Como você quer trabalhar?'),
          const SizedBox(height: 32),
          _labelText('Modalidade de trabalho'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: JobModality.values.map((m) {
              final selected = _selectedModalities.contains(m);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (selected) {
                      _selectedModalities.remove(m);
                    } else {
                      _selectedModalities.add(m);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.secondary.withOpacity(0.15) : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected ? AppColors.secondary : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    m.label,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          AppTextField(
            label: 'Pretensão salarial (R\$)',
            hint: '5000',
            controller: _salaryController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          _labelText('Tipo de contratação'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ContractType.values.map((c) {
              final selected = _selectedContractTypes.contains(c);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (selected) {
                      _selectedContractTypes.remove(c);
                    } else {
                      _selectedContractTypes.add(c);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    c.label,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          AppButton(label: 'Continuar', onTap: _nextPage),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _stepHeader('Experiência', 'Quase lá! Conte um pouco mais.'),
          const SizedBox(height: 32),
          AppTextField(
            label: 'Bio profissional',
            hint: 'Descreva brevemente seu perfil e objetivos...',
            controller: _bioController,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Você poderá adicionar experiências, formação e habilidades detalhadas no seu perfil após o cadastro.',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Consumer<AuthProvider>(
            builder: (ctx, auth, _) => AppButton(
              label: 'Criar conta',
              isLoading: auth.isLoading,
              onTap: _register,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 15,
            color: AppColors.textSecondary,
          ),
        ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
      ],
    );
  }

  Widget _labelText(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
      ),
    );
  }

  Widget _dropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labelText(label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 15,
              color: AppColors.textTertiary,
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceElevated,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          ),
        ),
      ],
    );
  }
}
