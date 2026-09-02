import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/common/app_button.dart';
import '../../../widgets/common/app_text_field.dart';
import '../providers/auth_provider.dart';

class RegisterCompanyScreen extends StatefulWidget {
  const RegisterCompanyScreen({super.key});

  @override
  State<RegisterCompanyScreen> createState() => _RegisterCompanyScreenState();
}

class _RegisterCompanyScreenState extends State<RegisterCompanyScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final _nameController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cityController = TextEditingController();
  String? _selectedState;
  String? _selectedArea;
  String? _selectedSize;
  final _descriptionController = TextEditingController();
  final _websiteController = TextEditingController();
  bool _obscurePassword = true;

  final List<String> _states = ['SP', 'RJ', 'MG', 'RS', 'PR', 'SC', 'BA', 'PE', 'CE', 'DF'];
  final List<String> _areas = [
    'Tecnologia', 'Fintech', 'E-commerce', 'Saúde', 'Educação',
    'Logística', 'Varejo', 'Industria', 'Serviços', 'Outro',
  ];
  final List<String> _sizes = [
    'Startup (1-10)', 'Pequena (11-50)', 'Média (51-200)', 'Grande (201-1000)', 'Enterprise (1000+)',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _cnpjController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.registerCompany(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (mounted && success) {
      context.go('/company-home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_currentPage > 0) {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.pop();
                      }
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const Spacer(),
                  Text(
                    '${_currentPage + 1} de 2',
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [_buildStep1(), _buildStep2()],
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
          const Text(
            'Informações\nda empresa',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.8,
              height: 1.15,
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 32),
          AppTextField(label: 'Nome da empresa', hint: 'Trabalhaki Ltda.', controller: _nameController, textCapitalization: TextCapitalization.words),
          const SizedBox(height: 16),
          AppTextField(label: 'CNPJ', hint: '00.000.000/0001-00', controller: _cnpjController, keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          AppTextField(label: 'Email corporativo', hint: 'contato@empresa.com', controller: _emailController, keyboardType: TextInputType.emailAddress),
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
          AppTextField(label: 'Cidade', hint: 'São Paulo', controller: _cityController, textCapitalization: TextCapitalization.words),
          const SizedBox(height: 32),
          AppButton(
            label: 'Continuar',
            onTap: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
          ),
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
          const Text(
            'Informações\nprofissionais',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.8,
              height: 1.15,
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 32),
          _dropdownField('Área de atuação', 'Selecione', _selectedArea, _areas, (v) => setState(() => _selectedArea = v)),
          const SizedBox(height: 16),
          _dropdownField('Tamanho da empresa', 'Selecione', _selectedSize, _sizes, (v) => setState(() => _selectedSize = v)),
          const SizedBox(height: 16),
          AppTextField(label: 'Descrição da empresa', hint: 'Conte sobre a empresa, cultura e missão...', controller: _descriptionController, maxLines: 4, textCapitalization: TextCapitalization.sentences),
          const SizedBox(height: 16),
          AppTextField(label: 'Website (opcional)', hint: 'https://empresa.com.br', controller: _websiteController, keyboardType: TextInputType.url),
          const SizedBox(height: 32),
          Consumer<AuthProvider>(
            builder: (ctx, auth, _) => AppButton(
              label: 'Criar conta empresarial',
              isLoading: auth.isLoading,
              onTap: _register,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownField(String label, String hint, String? value, List<String> items, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 15, color: AppColors.textTertiary)),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 15, color: AppColors.textPrimary)))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceElevated,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          ),
        ),
      ],
    );
  }
}
