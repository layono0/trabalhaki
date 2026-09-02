import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _blobController1;
  late AnimationController _blobController2;
  late AnimationController _blobController3;

  @override
  void initState() {
    super.initState();
    _blobController1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _blobController2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 11),
    )..repeat(reverse: true);

    _blobController3 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blobController1.dispose();
    _blobController2.dispose();
    _blobController3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0A0626),
                  Color(0xFF110A40),
                  Color(0xFF1A0F5E),
                ],
              ),
            ),
          ),

          // Animated blobs
          _AnimatedBlob(
            controller: _blobController1,
            color: AppColors.primary.withOpacity(0.35),
            size: 320,
            offsetX: -80,
            offsetY: -40,
          ),
          _AnimatedBlob(
            controller: _blobController2,
            color: AppColors.accent.withOpacity(0.4),
            size: 260,
            offsetX: 100,
            offsetY: 80,
            rotationOffset: 0.5,
          ),
          _AnimatedBlob(
            controller: _blobController3,
            color: AppColors.secondary.withOpacity(0.15),
            size: 200,
            offsetX: -60,
            offsetY: 200,
            rotationOffset: 1.0,
          ),

          // Noise overlay for texture
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 2),

                  // Logo
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.12),
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'T',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF86E5A1),
                          height: 1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // App name
                  const Text(
                    AppConstants.appName,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -1.5,
                      height: 1.0,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tagline
                  Text(
                    'Encontre oportunidades.\nEncontre seu match.',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.65),
                      height: 1.5,
                      letterSpacing: -0.2,
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Buttons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Primary CTA - Login
                      _PrimaryButton(
                        label: 'Entrar',
                        onTap: () => context.push('/login'),
                      ),

                      const SizedBox(height: 12),

                      // Secondary CTA - Register
                      _SecondaryButton(
                        label: 'Criar conta',
                        onTap: () => context.push('/register-type'),
                      ),

                      const SizedBox(height: 32),

                      // Demo hint
                      Center(
                        child: Text(
                          'candidato@trabalhaki.com · 123456',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedBlob extends StatelessWidget {
  final AnimationController controller;
  final Color color;
  final double size;
  final double offsetX;
  final double offsetY;
  final double rotationOffset;

  const _AnimatedBlob({
    required this.controller,
    required this.color,
    required this.size,
    required this.offsetX,
    required this.offsetY,
    this.rotationOffset = 0,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      left: screenWidth / 2 + offsetX,
      top: screenHeight / 3 + offsetY,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final progress = controller.value;
          final x = math.sin((progress + rotationOffset) * math.pi * 2) * 30;
          final y = math.cos((progress + rotationOffset) * math.pi * 2) * 20;
          return Transform.translate(
            offset: Offset(x, y),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
              letterSpacing: -0.1,
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.25),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
              letterSpacing: -0.1,
            ),
          ),
        ),
      ),
    );
  }
}
