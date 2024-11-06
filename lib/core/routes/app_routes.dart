import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/services/frontend/contract_service.dart';
import 'package:speakmobilemvp/features/profile/screens/profile_main_screen.dart';
import 'package:speakmobilemvp/features/home/home_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/edit_profile_screen.dart';
import 'package:speakmobilemvp/features/misc/screens/not_found_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/profile_analytics_screen.dart';
import 'package:speakmobilemvp/features/splash/screens/splash_screen.dart';
import 'package:speakmobilemvp/features/vocal_nfts/screens/record_screen.dart';
import 'package:speakmobilemvp/features/nft_collection/screens/nft_detail_screen.dart';
import 'package:speakmobilemvp/features/nft_collection/screens/create_nft_screen.dart';
import 'package:speakmobilemvp/features/nft_collection/screens/mint_nft_screen.dart';
import 'package:speakmobilemvp/features/transactions/screens/transaction_detail_screen.dart';
import 'package:speakmobilemvp/features/transactions/screens/wallet_screen.dart';
import 'package:speakmobilemvp/features/admin/screens/admin_dashboard.dart';
import 'package:speakmobilemvp/features/admin/screens/user_management_screen.dart';
import 'package:speakmobilemvp/features/admin/screens/analytics_screen.dart';
import 'package:speakmobilemvp/features/vocal_nfts/screens/preview_screen.dart';
import 'package:speakmobilemvp/features/discover/screens/discover_screen.dart';
import 'package:speakmobilemvp/features/about/screens/about_screen.dart';
import 'package:speakmobilemvp/features/about/screens/roadmap_screen.dart';
import 'package:speakmobilemvp/features/about/screens/terms_screen.dart';
import 'package:speakmobilemvp/features/about/screens/privacy_policy_screen.dart';
import 'package:speakmobilemvp/features/nft_collection/screens/collection_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/profile_settings_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/notification_settings_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/profile_verification_screen.dart';
import 'package:speakmobilemvp/features/vocal_nfts/screens/voice_nft_list_screen.dart';
import 'package:speakmobilemvp/features/vocal_nfts/screens/edit_audio_screen.dart';
import 'package:speakmobilemvp/features/nft_collection/screens/collection_analytics_screen.dart';
import 'package:speakmobilemvp/features/nft_collection/screens/import_screen.dart';

import '../services/analytics/analytics_service.dart';
import '../services/frontend/recording_service.dart';
import 'package:speakmobilemvp/features/profile/screens/privacy/voice_fingerprint_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/privacy/usage_restrictions_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/preferences/language_settings_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/preferences/default_pricing_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/preferences/content_categories_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/preferences/appearance_settings_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/preferences/accessibility_settings_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/security/authentication_settings_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/security/wallet_security_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/privacy/voice_privacy_settings_screen.dart';

class AppRoutes {
  static final contractService = ContractService();

  // Main Tab Routes
  static const String home = '/';
  static const String discover = '/discover';
  static const String recordTab = '/record-tab';
  static const String collection = '/collection';
  static const String profile = '/profile';

  // Profile Section
  static const String editProfile = '/profile/edit';
  static const String settings = '/profile/settings';
  static const String profileSettings = '/profile/settings';
  static const String notifications = '/profile/notifications';
  static const String notificationSettings = '/profile/notification-settings';
  static const String verification = '/profile/verification';
  static const String profileInfo = '/profile/info';
  static const String voiceAssets = '/profile/voice-assets';
  static const String profileVisibilitySettings = '/profile/settings/visibility';
  static const String voicePrivacySettings = '/profile/settings/privacy';
  static const String voiceIdentitySettings = '/profile/settings/identity';
  static const String blockedUsers = '/profile/settings/blocked-users';
  static const String dataUsageSettings = '/profile/settings/data-usage';
  static const String authenticationSettings = '/profile/settings/authentication';
  static const String walletSecurity = '/profile/settings/wallet-security';
  static const String identityVerification = '/profile/settings/identity-verification';
  static const String loginActivity = '/profile/settings/login-activity';
  static const String recoveryOptions = '/profile/settings/recovery-options';
  static const String notificationPreferences = '/profile/settings/notifications';
  static const String languageSettings = '/profile/settings/language';
  static const String defaultPricing = '/profile/settings/default-pricing';
  static const String contentCategories = '/profile/settings/content-categories';
  static const String appearanceSettings = '/profile/settings/appearance';
  static const String accessibilitySettings = '/profile/settings/accessibility';

  // NFT Collection
  static const String nftDetail = '/collection/detail';
  static const String createNft = '/collection/create';
  static const String mintNft = '/collection/mint';

  // Transactions
  static const String transactionDetail = '/transactions/detail';
  static const String wallet = '/transactions/wallet';

  // Admin
  static const String adminDashboard = '/admin';
  static const String userManagement = '/admin/users';
  static const String analytics = '/admin/analytics';

  // About
  static const String about = '/about';
  static const String roadmap = '/about/roadmap';
  static const String terms = '/about/terms';
  static const String privacy = '/about/privacy';

  // Profile Analytics
  static const String profileAnalytics = '/profile/analytics';

  // Voice NFT List
  static const String voiceNftListTab = '/voice-nft/list';

  // New route for splash screen
  static const String splash = '/splash';

  // Voice NFT Section
  static const String editAudio = '/voice-nft/edit-audio';

  // Vocal NFTs Section
  static const String preview = '/vocal-nfts/preview';
  static const String record = '/vocal-nfts/record';
  static const String voiceNftList = '/vocal-nfts/list';

  // Collection Analytics
  static const String collectionAnalytics = '/collection/analytics';

  // Import route
  static const String import = '/collection/import';

  static const String initial = splash;

  static const String voiceFingerprint = '/profile/settings/voice-fingerprint';
  static const String usageRestrictions = '/profile/settings/usage-restrictions';

  static Map<String, Widget Function(BuildContext)> get routes {
    return {
      splash: (context) => const SplashScreen(),
      home: (context) => const HomeScreen(),
      record: (context) => RecordScreen(recorderController: RecorderController()),
      profile: (context) => const ProfileMainScreen(),
      editProfile: (context) => const EditProfileScreen(),
      profileAnalytics: (context) => const ProfileAnalyticsScreen(),
      nftDetail: (context) => const NftDetailScreen(),
      createNft: (context) => CreateNftScreen(
        contractService: contractService,
        analytics: AnalyticsService(),
      ),
      mintNft: (context) => const MintNftScreen(),
      transactionDetail: (context) => const TransactionDetailScreen(),
      wallet: (context) => const WalletScreen(),
      adminDashboard: (context) => const AdminDashboard(),
      userManagement: (context) => const UserManagementScreen(),
      analytics: (context) => const AnalyticsScreen(),
      preview: (context) => const PreviewScreen(),
      voiceNftList: (context) => const VocalNftListScreen(),
      discover: (context) => DiscoverScreen(contractService: contractService),
      collection: (context) => const CollectionScreen(),
      settings: (context) => const ProfileSettingsScreen(),
      notifications: (context) => const NotificationSettingsScreen(),
      verification: (context) => const ProfileVerificationScreen(),
      about: (context) => const AboutScreen(),
      roadmap: (context) => const RoadmapScreen(),
      terms: (context) => const TermsScreen(),
      privacy: (context) => const PrivacyPolicyScreen(),
      editAudio: (context) => EditAudioScreen(
        audioPath: '',
        recordingService: RecordingService(),
        onSave: (String path) async {
          if (path.isNotEmpty && context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
      collectionAnalytics: (context) => const CollectionAnalyticsScreen(),
      import: (context) => const ImportScreen(),
      languageSettings: (context) => const LanguageSettingsScreen(),
      defaultPricing: (context) => const DefaultPricingScreen(),
      contentCategories: (context) => const ContentCategoriesScreen(),
      appearanceSettings: (context) => const AppearanceSettingsScreen(),
      accessibilitySettings: (context) => const AccessibilitySettingsScreen(),
      authenticationSettings: (context) => const AuthenticationSettingsScreen(),
      walletSecurity: (context) => const WalletSecurityScreen(),
      voicePrivacySettings: (context) => const VoicePrivacySettingsScreen(),
    };
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case AppRoutes.record:
        return MaterialPageRoute(
          builder: (_) => RecordScreen(recorderController: RecorderController()),
          settings: settings,
        );

      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileMainScreen(),
          settings: settings,
        );

      case AppRoutes.editProfile:
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => const EditProfileScreen(),
          settings: settings,
        );

      case AppRoutes.profileAnalytics:
        return MaterialPageRoute(
          builder: (_) => const ProfileAnalyticsScreen(),
          settings: settings,
        );

      case AppRoutes.editAudio:
        return MaterialPageRoute(
          builder: (context) => EditAudioScreen(
            audioPath: '',
            recordingService: RecordingService(),
            onSave: (String path) async {
              if (path.isNotEmpty && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          settings: settings,
        );

      case AppRoutes.nftDetail:
        return MaterialPageRoute(
          builder: (_) => const NftDetailScreen(),
          settings: settings,
        );

      case AppRoutes.createNft:
        return MaterialPageRoute(
          builder: (_) => CreateNftScreen(
            contractService: contractService,
            analytics: AnalyticsService(),
          ),
          settings: settings,
        );

      case AppRoutes.mintNft:
        return MaterialPageRoute(
          builder: (_) => const MintNftScreen(),
          settings: settings,
        );

      case AppRoutes.transactionDetail:
        return MaterialPageRoute(
          builder: (_) => const TransactionDetailScreen(),
          settings: settings,
        );

      case AppRoutes.wallet:
        return MaterialPageRoute(
          builder: (_) => const WalletScreen(),
          settings: settings,
        );

      case AppRoutes.adminDashboard:
        return MaterialPageRoute(
          builder: (_) => const AdminDashboard(),
          settings: settings,
        );

      case AppRoutes.userManagement:
        return MaterialPageRoute(
          builder: (_) => const UserManagementScreen(),
          settings: settings,
        );

      case AppRoutes.analytics:
        return MaterialPageRoute(
          builder: (_) => const AnalyticsScreen(),
          settings: settings,
        );

      case AppRoutes.preview:
        return MaterialPageRoute(
          builder: (_) => const PreviewScreen(),
          settings: settings,
        );

      case AppRoutes.voiceNftList:
        return MaterialPageRoute(
          builder: (_) => const VocalNftListScreen(),
          settings: settings,
        );

      case AppRoutes.discover:
        return MaterialPageRoute(
          builder: (_) => DiscoverScreen(contractService: contractService),
          settings: settings,
        );

      case AppRoutes.collection:
        return MaterialPageRoute(
          builder: (_) => const CollectionScreen(),
          settings: settings,
        );

      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const ProfileSettingsScreen(),
          settings: settings,
        );

      case AppRoutes.notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationSettingsScreen(),
          settings: settings,
        );

      case AppRoutes.verification:
        return MaterialPageRoute(
          builder: (_) => const ProfileVerificationScreen(),
          settings: settings,
        );

      case AppRoutes.about:
        return MaterialPageRoute(
          builder: (_) => const AboutScreen(),
          settings: settings,
        );

      case AppRoutes.roadmap:
        return MaterialPageRoute(
          builder: (_) => const RoadmapScreen(),
          settings: settings,
        );

      case AppRoutes.terms:
        return MaterialPageRoute(
          builder: (_) => const TermsScreen(),
          settings: settings,
        );

      case AppRoutes.privacy:
        return MaterialPageRoute(
          builder: (_) => const PrivacyPolicyScreen(),
          settings: settings,
        );

      case AppRoutes.collectionAnalytics:
        return MaterialPageRoute(
          builder: (_) => const CollectionAnalyticsScreen(),
          settings: settings,
        );

      case AppRoutes.import:
        return MaterialPageRoute(
          builder: (_) => const ImportScreen(),
          settings: settings,
        );

      case AppRoutes.voiceFingerprint:
        return MaterialPageRoute(
          builder: (_) => const VoiceFingerprintScreen(),
          settings: settings,
        );

      case AppRoutes.usageRestrictions:
        return MaterialPageRoute(
          builder: (_) => const UsageRestrictionsScreen(),
          settings: settings,
        );

      case AppRoutes.languageSettings:
        return MaterialPageRoute(
          builder: (_) => const LanguageSettingsScreen(),
          settings: settings,
        );

      case AppRoutes.defaultPricing:
        return MaterialPageRoute(
          builder: (_) => const DefaultPricingScreen(),
          settings: settings,
        );

      case AppRoutes.contentCategories:
        return MaterialPageRoute(
          builder: (_) => const ContentCategoriesScreen(),
          settings: settings,
        );

      case AppRoutes.appearanceSettings:
        return MaterialPageRoute(
          builder: (_) => const AppearanceSettingsScreen(),
          settings: settings,
        );

      case AppRoutes.accessibilitySettings:
        return MaterialPageRoute(
          builder: (_) => const AccessibilitySettingsScreen(),
          settings: settings,
        );

      case AppRoutes.authenticationSettings:
        return MaterialPageRoute(
          builder: (_) => const AuthenticationSettingsScreen(),
          settings: settings,
        );

      case AppRoutes.walletSecurity:
        return MaterialPageRoute(
          builder: (_) => const WalletSecurityScreen(),
          settings: settings,
        );

      case AppRoutes.voicePrivacySettings:
        return MaterialPageRoute(
          builder: (_) => const VoicePrivacySettingsScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const NotFoundScreen(),
          settings: settings,
        );
    }
  }

  static String get getNftDetail => nftDetail;
  static String get getCreateNft => createNft;
  static String get getMintNft => mintNft;
}
