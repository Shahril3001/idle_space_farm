import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/daily_reward_model.dart';
import '../providers/game_provider.dart';

class DailyRewardPage extends StatefulWidget {
  const DailyRewardPage({Key? key}) : super(key: key);

  @override
  _DailyRewardPageState createState() => _DailyRewardPageState();
}

class _DailyRewardPageState extends State<DailyRewardPage> {
  bool _isClaiming = false;

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Daily Rewards',
          height: 50,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ImageCacheManager.getImage(
                  'assets/images/ui/dailyreward-bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<List<DailyReward>>(
                  future: gameProvider.getAllDailyRewards(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.amber),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No rewards available',
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(color: Colors.white70),
                        ),
                      );
                    }

                    final rewards = snapshot.data!;
                    rewards.sort((a, b) => a.day.compareTo(b.day));

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildStreakInfo(gameProvider),
                          const SizedBox(height: 24),
                          _buildRewardsGrid(rewards, gameProvider),
                          const SizedBox(height: 24),
                          _buildClaimButton(gameProvider),
                        ],
                      ),
                    );
                  },
                ),
              ),
              _buildBackButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFA12626), //Top color
              const Color(0xFF611818), // Dark red at bottom
            ],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Colors.transparent, // Make button background transparent
            shadowColor: Colors.transparent, // Remove shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          child: Text(
            "Back",
            style: TextStyle(
                color: Colors.white, fontFamily: 'GameFont', fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildStreakInfo(GameProvider gameProvider) {
    final theme = Theme.of(context);

    return FutureBuilder<int>(
      future: gameProvider.getDailyRewardStreak(),
      builder: (context, snapshot) {
        final streak = snapshot.data ?? 0;
        final isMaxStreak = streak >= 7;
        final progressColor = isMaxStreak ? Colors.amber : Colors.green;

        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Current Streak',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 110,
                    height: 110,
                    child: CircularProgressIndicator(
                      value: isMaxStreak ? 1.0 : streak / 7,
                      strokeWidth: 12,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$streak',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '/7 days',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: progressColor.withOpacity(0.5), width: 1),
                ),
                child: Text(
                  isMaxStreak
                      ? 'Maximum streak reached!'
                      : 'Claim daily to increase your streak!',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRewardsGrid(
      List<DailyReward> rewards, GameProvider gameProvider) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity, // Takes full available width
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Center(
            child: Text(
              'Daily Rewards',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.6,
          ),
          itemCount: rewards.length,
          itemBuilder: (context, index) {
            return _buildRewardItem(rewards[index], gameProvider);
          },
        ),
      ],
    );
  }

  Widget _buildRewardItem(DailyReward reward, GameProvider gameProvider) {
    return FutureBuilder(
      future: Future.wait([
        gameProvider.getDailyRewardStreak(),
        gameProvider.getTodaysDailyReward(),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final streak = snapshot.data![0] as int;
        final todayReward = snapshot.data![1] as DailyReward?;

        final isClaimed = reward.isClaimed;
        final isToday = todayReward?.day == reward.day;
        final canClaim = isToday && !isClaimed;
        final isNext = !isClaimed && !isToday && streak + 1 == reward.day;

        Color borderColor = Colors.transparent;
        if (isToday) {
          borderColor = Colors.amber;
        } else if (isNext) {
          borderColor = Colors.blue;
        } else if (isClaimed) {
          borderColor = Colors.green;
        }

        return Tooltip(
          message: _getRewardDescription(reward),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Day ${reward.day}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isToday ? Colors.amber : Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                _getRewardIcon(reward, isClaimed),
                const SizedBox(height: 8),
                if (isClaimed)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Text(
                      'Claimed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                if (canClaim)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.amber,
                          Colors.orange,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Claim Now',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (isNext)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade400,
                          Colors.blue.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getRewardIcon(DailyReward reward, bool isClaimed) {
    final iconColor = isClaimed ? Colors.white.withOpacity(0.5) : Colors.white;

    switch (reward.rewardType) {
      case 'resource':
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Text(
            reward.amount.toInt().toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: iconColor,
            ),
          ),
        );
      case 'equipment':
        return Icon(Icons.shield, size: 32, color: iconColor);
      case 'potion':
        return Icon(Icons.local_drink, size: 32, color: iconColor);
      default:
        return Icon(Icons.card_giftcard, size: 32, color: iconColor);
    }
  }

  String _getRewardDescription(DailyReward reward) {
    switch (reward.rewardType) {
      case 'resource':
        return '${reward.amount.toInt()} ${reward.rewardId}';
      case 'equipment':
        return '${reward.rewardId.replaceAll('_', ' ').capitalize()}';
      case 'potion':
        return '${reward.rewardId.replaceAll('_', ' ').capitalize()}';
      default:
        return 'Unknown reward';
    }
  }

  Widget _buildClaimButton(GameProvider gameProvider) {
    final theme = Theme.of(context);

    return FutureBuilder<bool>(
      future: gameProvider.canClaimDailyReward(),
      builder: (context, snapshot) {
        final canClaim = snapshot.data ?? false;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: canClaim
                    ? [
                        Color(0xFFF39C12), // Top color (gold)
                        Color(0xFFE67E22), // Bottom color (darker gold)
                      ]
                    : [
                        Color(0xFF7F8C8D), // Disabled top color
                        Color(0xFF616A6B), // Disabled bottom color
                      ],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isClaiming || !canClaim
                  ? null
                  : () async {
                      setState(() => _isClaiming = true);
                      final claimed = await gameProvider.claimDailyReward();
                      setState(() => _isClaiming = false);

                      if (claimed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Reward claimed successfully!',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Unable to claim reward at this time'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
              child: _isClaiming
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      canClaim ? 'CLAIM TODAY\'S REWARD' : 'ALREADY CLAIMED',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'GameFont',
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

// Custom App Bar Implementation (same as before)
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.height = 56.0,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.bottom,
  }) : super(key: key);

  @override
  Size get preferredSize =>
      Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/ui/wood-ui.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (bottom == null) Spacer(),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'GameFont',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (bottom == null) Spacer(),
          if (bottom != null) bottom!,
        ],
      ),
    );
  }
}
