import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/job.dart';
import '../../../features/jobs/providers/jobs_provider.dart';
import '../../../widgets/cards/job_card.dart';
import 'job_detail_screen.dart';
import 'match_screen.dart';

class JobsDiscoveryScreen extends StatefulWidget {
  const JobsDiscoveryScreen({super.key});

  @override
  State<JobsDiscoveryScreen> createState() => _JobsDiscoveryScreenState();
}

class _JobsDiscoveryScreenState extends State<JobsDiscoveryScreen> {
  final CardSwiperController _cardController = CardSwiperController();
  bool _showInterested = false;
  bool _showPass = false;
  Job? _currentCard;

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  void _swipeRight() {
    HapticFeedback.lightImpact();
    _cardController.swipe(CardSwiperDirection.right);
  }

  void _swipeLeft() {
    HapticFeedback.lightImpact();
    _cardController.swipe(CardSwiperDirection.left);
  }

  void _swipeMaybe() {
    HapticFeedback.selectionClick();
    _cardController.swipe(CardSwiperDirection.top);
  }

  Future<void> _onSwiped(int prevIndex, int? currentIndex, CardSwiperDirection direction, List<Job> jobs) async {
    final provider = context.read<JobsProvider>();

    if (prevIndex < jobs.length) {
      final job = jobs[prevIndex];
      if (direction == CardSwiperDirection.right) {
        provider.swipeRight(job.id);
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted && provider.pendingMatch != null) {
          final matchJob = provider.pendingMatch!;
          provider.clearPendingMatch();
          provider.confirmMatch(matchJob);
          if (mounted) {
            await Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    MatchScreen(job: matchJob),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );
          }
        }
      } else if (direction == CardSwiperDirection.left) {
        provider.swipeLeft(job.id);
      } else if (direction == CardSwiperDirection.top) {
        provider.saveMaybe(job.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobsProvider>(
      builder: (ctx, provider, _) {
        final jobs = provider.swipeJobs;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Top bar
                _TopBar(
                  jobCount: jobs.length,
                  onFilterTap: () => _showFilters(context, provider),
                ),

                // Card stack
                Expanded(
                  child: jobs.isEmpty
                      ? _EmptyState(onRefresh: provider.resetSwipeJobs)
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CardSwiper(
                            controller: _cardController,
                            cardsCount: jobs.length,
                            numberOfCardsDisplayed: jobs.length.clamp(1, 3),
                            padding: const EdgeInsets.only(top: 8, bottom: 0),
                            scale: 0.92,
                            allowedSwipeDirection: AllowedSwipeDirection.only(
                              left: true,
                              right: true,
                              up: true,
                            ),
                            onSwipe: (prevIndex, currentIndex, direction) {
                              _onSwiped(prevIndex, currentIndex, direction, jobs);
                              return true;
                            },
                            onTapDisabled: () {},
                            cardBuilder: (context, index, percentX, percentY) {
                              if (index >= jobs.length) return const SizedBox.shrink();
                              final job = jobs[index];
                              final progress = percentX / 100.0;

                              return GestureDetector(
                                onTap: index == 0
                                    ? () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => JobDetailScreen(job: job),
                                          ),
                                        )
                                    : null,
                                child: JobCard(
                                  job: job,
                                  swipeProgress: index == 0 ? progress : 0,
                                ),
                              );
                            },
                          ),
                        ),
                ),

                // Action buttons
                if (jobs.isNotEmpty)
                  _ActionButtons(
                    onPass: _swipeLeft,
                    onMaybe: _swipeMaybe,
                    onInterested: _swipeRight,
                  ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilters(BuildContext context, JobsProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FiltersSheet(provider: provider),
    );
  }
}

class _TopBar extends StatelessWidget {
  final int jobCount;
  final VoidCallback onFilterTap;

  const _TopBar({required this.jobCount, required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vagas para você',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$jobCount vagas disponíveis',
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onPass;
  final VoidCallback onMaybe;
  final VoidCallback onInterested;

  const _ActionButtons({
    required this.onPass,
    required this.onMaybe,
    required this.onInterested,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionButton(
            icon: Icons.close_rounded,
            color: AppColors.swipeLeft,
            size: 52,
            onTap: onPass,
            label: 'Passar',
          ),
          _ActionButton(
            icon: Icons.bookmark_outline_rounded,
            color: AppColors.swipeMaybe,
            size: 44,
            onTap: onMaybe,
            label: 'Talvez',
          ),
          _ActionButton(
            icon: Icons.favorite_rounded,
            color: AppColors.swipeRight,
            size: 52,
            onTap: onInterested,
            label: 'Interesse',
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onTap;
  final String label;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.size,
    required this.onTap,
    required this.label,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animController.forward(),
      onTapUp: (_) {
        _animController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _animController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Column(
          children: [
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.color.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(widget.icon, color: widget.color, size: widget.size * 0.45),
            ),
            const SizedBox(height: 6),
            Text(
              widget.label,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onRefresh;
  const _EmptyState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 48,
                color: AppColors.primary,
              ),
            )
                .animate(onPlay: (c) => c.repeat(period: const Duration(seconds: 3)))
                .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 1500.ms, curve: Curves.easeInOut)
                .then()
                .scale(begin: const Offset(1.05, 1.05), end: const Offset(1, 1), duration: 1500.ms),
            const SizedBox(height: 24),
            const Text(
              'Você viu todas as vagas!',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Você viu todas as vagas disponíveis no momento. Novas oportunidades chegam todos os dias.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: onRefresh,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Text(
                  'Atualizar vagas',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FiltersSheet extends StatefulWidget {
  final JobsProvider provider;
  const _FiltersSheet({required this.provider});

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  String? _modality;
  String? _level;
  String? _contract;

  @override
  void initState() {
    super.initState();
    _modality = widget.provider.filterModality;
    _level = widget.provider.filterLevel;
    _contract = widget.provider.filterContract;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Filtros',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _modality = null;
                        _level = null;
                        _contract = null;
                      });
                      widget.provider.clearFilters();
                    },
                    child: const Text('Limpar', style: TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _filterSection('Modalidade', ['Remoto', 'Híbrido', 'Presencial'], _modality, (v) => setState(() => _modality = v)),
              const SizedBox(height: 16),
              _filterSection('Nível', ['Estágio', 'Júnior', 'Pleno', 'Sênior'], _level, (v) => setState(() => _level = v)),
              const SizedBox(height: 16),
              _filterSection('Contrato', ['CLT', 'PJ', 'Estágio'], _contract, (v) => setState(() => _contract = v)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.provider.setFilter(
                      modality: _modality,
                      level: _level,
                      contract: _contract,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Aplicar filtros',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterSection(String title, List<String> options, String? selected, void Function(String?) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options.map((opt) {
            final isSelected = selected == opt;
            return GestureDetector(
              onTap: () => onSelect(isSelected ? null : opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  opt,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
