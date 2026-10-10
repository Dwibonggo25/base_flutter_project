import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import '../../domain/enitities/weather_entity.dart';
import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_event.dart';
import '../bloc/home/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Modular.get<HomeBloc>()..add(GetWeatherEvent()),
      child: const _WeatherScreen(),
    );
  }
}

class _WeatherScreen extends StatelessWidget {
  const _WeatherScreen();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: switch (state) {
                HomeLoaded(:final data) => _WeatherContent(
                  key: ValueKey(data.condition),
                  weather: data,
                ),
                HomeError() => _WeatherError(
                  key: const ValueKey('error'),
                  onRetry: () => BlocProvider.of<HomeBloc>(context).add(GetWeatherEvent()),
                ),
                _ => const _WeatherLoading(key: ValueKey('loading')),
              },
            );
          },
        ),
      ),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  final WeatherEntity weather;

  const _WeatherContent({required this.weather, super.key});

  @override
  Widget build(BuildContext context) {
    final palette = _WeatherPalette.fromCondition(weather.condition);
    final now = DateTime.now();

    return DecoratedBox(
      decoration: BoxDecoration(gradient: palette.background),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            children: [
              _Header(onRefresh: () => BlocProvider.of<HomeBloc>(context).add(GetWeatherEvent())),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Column(
                        children: [
                          _WeatherHero(
                            weather: weather,
                            icon: palette.icon,
                            accent: palette.accent,
                          ),
                          const SizedBox(height: 36),
                          _WeatherSummaryCard(
                            weather: weather,
                            dateLabel: DateFormat('EEEE, d MMMM').format(now),
                            timeLabel: DateFormat('HH:mm').format(now),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tap refresh to get the latest conditions',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.68)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onRefresh;

  const _Header({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: const Icon(Icons.air_rounded, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WEATHER',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.66),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                ),
              ),
              Text(
                'Current conditions',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          onPressed: onRefresh,
          tooltip: 'Refresh weather',
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.16),
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
    );
  }
}

class _WeatherHero extends StatelessWidget {
  final WeatherEntity weather;
  final IconData icon;
  final Color accent;

  const _WeatherHero({required this.weather, required this.icon, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 132,
          height: 132,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            boxShadow: [
              BoxShadow(color: accent.withValues(alpha: 0.30), blurRadius: 48, spreadRadius: 4),
            ],
          ),
          child: Icon(icon, size: 72, color: Colors.white),
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on_rounded, color: Colors.white.withValues(alpha: 0.72), size: 18),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                weather.city,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Semantics(
          label: '${weather.temp.round()} degrees Celsius',
          child: Text(
            '${weather.temp.round()}°',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Colors.white,
              fontSize: 104,
              height: 1,
              fontWeight: FontWeight.w300,
              letterSpacing: -6,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          weather.condition,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.90),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _WeatherSummaryCard extends StatelessWidget {
  final WeatherEntity weather;
  final String dateLabel;
  final String timeLabel;

  const _WeatherSummaryCard({
    required this.weather,
    required this.dateLabel,
    required this.timeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  icon: Icons.thermostat_rounded,
                  label: 'Temperature',
                  value: '${weather.temp.toStringAsFixed(1)}°C',
                ),
              ),
              Container(width: 1, height: 48, color: Colors.white.withValues(alpha: 0.18)),
              Expanded(
                child: _SummaryItem(
                  icon: Icons.cloud_outlined,
                  label: 'Condition',
                  value: weather.condition,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.14)),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                color: Colors.white.withValues(alpha: 0.72),
                size: 17,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  dateLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Updated $timeLabel',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: Colors.white.withValues(alpha: 0.62)),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _WeatherLoading extends StatelessWidget {
  const _WeatherLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StateBackground(
      colors: [Color(0xFF182848), Color(0xFF4B6CB7)],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 38,
            height: 38,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
          ),
          SizedBox(height: 20),
          Text(
            'Checking the weather…',
            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _WeatherError extends StatelessWidget {
  final VoidCallback onRetry;

  const _WeatherError({required this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    return _StateBackground(
      colors: const [Color(0xFF351C4D), Color(0xFF7B345B)],
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.14),
              ),
              child: const Icon(Icons.cloud_off_rounded, color: Colors.white, size: 44),
            ),
            const SizedBox(height: 24),
            Text(
              'Weather unavailable',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              'We could not load the latest conditions. Check your connection and try again.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.72),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF351C4D),
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StateBackground extends StatelessWidget {
  final List<Color> colors;
  final Widget child;

  const _StateBackground({required this.colors, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(padding: const EdgeInsets.all(24), child: child),
        ),
      ),
    );
  }
}

class _WeatherPalette {
  final LinearGradient background;
  final Color accent;
  final IconData icon;

  const _WeatherPalette({required this.background, required this.accent, required this.icon});

  factory _WeatherPalette.fromCondition(String condition) {
    final normalized = condition.toLowerCase();

    if (normalized.contains('clear')) {
      return const _WeatherPalette(
        background: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3157C8), Color(0xFF6E6EE8), Color(0xFFF18B7C)],
        ),
        accent: Color(0xFFFFD166),
        icon: Icons.wb_sunny_rounded,
      );
    }

    if (normalized.contains('rain') || normalized.contains('drizzle')) {
      return const _WeatherPalette(
        background: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF142F4C), Color(0xFF286A8C), Color(0xFF56A7B8)],
        ),
        accent: Color(0xFF76D7EA),
        icon: Icons.water_drop_rounded,
      );
    }

    if (normalized.contains('thunder')) {
      return const _WeatherPalette(
        background: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF18122B), Color(0xFF393053), Color(0xFF635985)],
        ),
        accent: Color(0xFFFFD166),
        icon: Icons.thunderstorm_rounded,
      );
    }

    if (normalized.contains('snow')) {
      return const _WeatherPalette(
        background: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF416788), Color(0xFF6FA3BA), Color(0xFFA9D6E5)],
        ),
        accent: Color(0xFFEAF8FF),
        icon: Icons.ac_unit_rounded,
      );
    }

    return const _WeatherPalette(
      background: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1B2845), Color(0xFF405B82), Color(0xFF6C8EAD)],
      ),
      accent: Color(0xFFB8D8E8),
      icon: Icons.cloud_rounded,
    );
  }
}
