import 'package:speakmobilemvp/core/services/frontend/contract_service.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:speakmobilemvp/features/admin/screens/admin_screen.dart';
import 'package:speakmobilemvp/features/audio_processing/screens/audio_processing_screen.dart';
import 'package:speakmobilemvp/features/auth/screens/auth_screen.dart';
import 'package:speakmobilemvp/features/discover/screens/discover_screen.dart';
import 'package:speakmobilemvp/features/home/home_screen.dart';
import 'package:speakmobilemvp/features/nft_collection/screens/collection_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/profile_main_screen.dart';
import 'package:speakmobilemvp/features/vocal_nfts/screens/record_screen.dart';
import 'package:speakmobilemvp/features/transactions/screens/transaction_detail_screen.dart';
import 'package:speakmobilemvp/features/vocal_nfts/screens/preview_screen.dart';

import '../../features/about/screens/terms_screen.dart';
import '../../features/admin/screens/admin_dashboard.dart';
import '../../features/admin/screens/analytics_screen.dart';
import '../../features/admin/screens/user_management_screen.dart';
import '../../features/nft_collection/screens/create_nft_screen.dart';
import '../../features/nft_collection/screens/mint_nft_screen.dart';
import '../../features/nft_collection/screens/nft_detail_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/transactions/screens/wallet_screen.dart';
import '../../features/vocal_nfts/screens/voice_nft_list_screen.dart';
import '../routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/analytics/analytics_service.dart';

class MainNavigation extends StatefulWidget {
  final ContractService contractService;
  final AnalyticsService analytics;

  const MainNavigation({
    super.key,
    required this.contractService,
    required this.analytics,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late final SupabaseClient _supabase;
  bool isLoggedIn = false;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _supabase = Supabase.instance.client;
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    // Listen to auth state changes
    _supabase.auth.onAuthStateChange.listen((data) {
      final Session? session = data.session;
      
      switch (data.event) {
        case AuthChangeEvent.signedIn:
          setState(() {
            isLoggedIn = true;
            _checkAdminStatus();
          });
          break;
        case AuthChangeEvent.signedOut:
          setState(() {
            isLoggedIn = false;
            isAdmin = false;
          });
          break;
        case AuthChangeEvent.tokenRefreshed:
          setState(() {
            isLoggedIn = session != null;
            if (isLoggedIn) {
              _checkAdminStatus();
            }
          });
          break;
        case AuthChangeEvent.userUpdated:
          _checkAdminStatus();
          break;
        default:
          setState(() {
            isLoggedIn = session != null;
          });
      }
    });

    // Check initial auth state
    final initialSession = _supabase.auth.currentSession;
    setState(() {
      isLoggedIn = initialSession != null;
      if (isLoggedIn) {
        _checkAdminStatus();
      }
    });
  }

  Future<void> _checkAdminStatus() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        setState(() => isAdmin = false);
        return;
      }

      final response = await _supabase
          .from('profiles')
          .select('is_admin')
          .eq('id', userId)
          .single();

      setState(() {
        isAdmin = response['is_admin'] ?? false;
      });
    } catch (e) {
      debugPrint('Error checking admin status: $e');
      setState(() => isAdmin = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // If not logged in, show auth screen
    if (!isLoggedIn) {
      return const AuthScreen();
    }

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Profile',
          ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.mic),
            label: 'Record',
          ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.waveform),
            label: 'Voice NFTs',
          ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.rectangle_grid_2x2),
            label: 'Collection',
          ),
          if (isAdmin) 
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings_solid),
              label: 'Admin',
            ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            // Home tab with discover and about sections
            return CupertinoTabView(
              builder: (context) => const HomeScreen(),
              routes: {
                '/discover': (context) => DiscoverScreen(contractService: widget.contractService),
                '/about': (context) => const AboutScreen(),
                '/terms': (context) => const TermsScreen(),
                '/privacy': (context) => const PrivacyPolicyScreen(),
              },
            );
          
          case 1:
            // Profile tab with settings and verification
            return CupertinoTabView(
              builder: (context) => const ProfileMainScreen(),
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case AppRoutes.editProfile:
                    return CupertinoPageRoute(
                      builder: (_) => const EditProfileScreen(),
                      settings: settings,
                    );
                  default:
                    return CupertinoPageRoute(
                      builder: (_) => const ProfileMainScreen(),
                      settings: settings,
                    );
                }
              },
            );
          
          case 2:
            // Record tab with audio processing and preview
            return CupertinoTabView(
              builder: (context) => RecordScreen(recorderController: RecorderController()),
              routes: {
                '/preview': (context) => const PreviewScreen(),
                '/processing': (context) => const AudioProcessingScreen(),
              },
            );
          
          case 3:
            // Voice NFTs tab with creation and management
            return CupertinoTabView(
              builder: (context) => const VocalNftListScreen(),
              routes: {
                '/create': (context) => CreateNftScreen(
                  contractService: widget.contractService,
                  analytics: widget.analytics,
                ),
                '/mint': (context) => const MintNftScreen(),
                '/detail': (context) => const NftDetailScreen(),
                '/transactions': (context) => const TransactionDetailScreen(),
                '/wallet': (context) => const WalletScreen(),
              },
            );
          case 4:
            // Collection tab with NFT management
            return CupertinoTabView(
              builder: (context) => const CollectionScreen(),
              routes: {
                '/detail': (context) => const NftDetailScreen(),
                '/transactions': (context) => const TransactionDetailScreen(),
              },
            );
          case 5:
            if (isAdmin) {
              return CupertinoTabView(
                builder: (context) => const AdminScreen(),
                routes: {
                  '/dashboard': (context) => const AdminDashboard(),
                  '/users': (context) => const UserManagementScreen(),
                  '/analytics': (context) => const AnalyticsScreen(),
                },
              );
            }
            return CupertinoTabView(
              builder: (context) => const HomeScreen(),
            );
          
          default:
            // Return to home screen instead of NotFoundScreen
            return CupertinoTabView(
              builder: (context) => const HomeScreen(),
            );
        }
      },
    );
  }
}

class DiscoverNavigator extends StatelessWidget {
  const DiscoverNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (context) {
        return CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(
            middle: Text('Discover'),
          ),
          child: Center(
            child: CupertinoButton(
              child: const Text('Go to About'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute<void>(
                    builder: (BuildContext context) => const AboutScreen(),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('About'),
      ),
      child: Center(
        child: CupertinoButton(
          child: const Text('Go to Privacy Policy'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute<void>(
                builder: (BuildContext context) => const PrivacyPolicyScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Privacy Policy'),
      ),
      child: Center(
        child: CupertinoButton(
          child: const Text('Go to Not Found'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute<void>(
                builder: (BuildContext context) => const NotFoundScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Not Found'),
      ),
      child: Center(
        child: Text('Not Found'),
      ),
    );
  }
}

class CollectionNavigator extends StatelessWidget {
  const CollectionNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (context) {
        return const CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('Collection'),
          ),
          child: Center(
            // child: CollectionScreen(),
            child: Text('Collection Screen'),
          ),
        );
      },
    );
  }
}

class RecordNavigator extends StatelessWidget {
  const RecordNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (context) {
        return const CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('Record'),
          ),
          child: Center(
            // child: RecordScreen(),
            child: Text('Record Screen'),
          ),
        );
      },
    );
  }
}

class ProfileNavigator extends StatelessWidget {
  const ProfileNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (context) {
        return const CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('Profile'),
          ),
          child: Center(
            // child: ProfileMainScreen(),
            child: Text('Profile Screen'),
          ),
        );
      },
    );
  }
}
