import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/screens/family_cards/family_cards_screen.dart';
import '../../presentation/screens/family_cards/family_card_detail_screen.dart';
import '../../presentation/screens/family_cards/add_family_card_screen.dart';
import '../../presentation/screens/sub_dimensions/sub_dimensions_hub_screen.dart';
import '../../presentation/screens/sub_dimensions/pendidikan_form_screen.dart';
import '../../presentation/screens/sub_dimensions/kesehatan_form_screen.dart';
import '../../presentation/screens/sub_dimensions/utilitas_dasar_form_screen.dart';
import '../../presentation/screens/sub_dimensions/aktivitas_form_screen.dart';
import '../../presentation/screens/sub_dimensions/fasilitas_masyarakat_form_screen.dart';
import '../../presentation/screens/sub_dimensions/produksi_desa_form_screen.dart';
import '../../presentation/screens/sub_dimensions/fasilitas_pendukung_ekonomi_form_screen.dart';
import '../../presentation/screens/sub_dimensions/pengelolaan_lingkungan_form_screen.dart';
import '../../presentation/screens/sub_dimensions/penanggulangan_bencana_form_screen.dart';
import '../../presentation/screens/sub_dimensions/kondisi_akses_jalan_form_screen.dart';
import '../../presentation/screens/sub_dimensions/kemudahan_akses_form_screen.dart';
import '../../presentation/screens/sub_dimensions/kelembagaan_pelayanan_desa_form_screen.dart';
import '../../presentation/screens/sub_dimensions/tata_kelola_keuangan_desa_form_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';

// Router Provider
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoading = authState.isLoading;
      final isAuthRoute = state.matchedLocation == '/login' ||
                         state.matchedLocation == '/register';
      final isSplashRoute = state.matchedLocation == '/splash';

      print('[ROUTER] Redirect check - Auth: $isAuthenticated, Loading: $isLoading, Route: ${state.matchedLocation}');

      // While loading auth status, show splash screen
      if (isLoading && !isSplashRoute) {
        print('[ROUTER] Auth loading, redirecting to /splash');
        return '/splash';
      }

      // If done loading and on splash, redirect based on auth status
      if (!isLoading && isSplashRoute) {
        print('[ROUTER] Auth loaded, redirecting from splash to ${isAuthenticated ? '/' : '/login'}');
        return isAuthenticated ? '/' : '/login';
      }

      // If not authenticated and not on auth pages, redirect to login
      if (!isLoading && !isAuthenticated && !isAuthRoute) {
        print('[ROUTER] Not authenticated, redirecting to /login');
        return '/login';
      }

      // If authenticated and on auth pages, redirect to dashboard
      if (!isLoading && isAuthenticated && isAuthRoute) {
        print('[ROUTER] Authenticated on auth page, redirecting to /');
        return '/';
      }

      print('[ROUTER] No redirect needed');
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/family-cards',
        builder: (context, state) => const FamilyCardsScreen(),
      ),
      GoRoute(
        path: '/family-cards/add',
        builder: (context, state) => const AddFamilyCardScreen(),
      ),
      GoRoute(
        path: '/family-cards/:nik',
        builder: (context, state) {
          final nik = state.pathParameters['nik']!;
          return FamilyCardDetailScreen(nik: nik);
        },
      ),
      GoRoute(
        path: '/sub-dimensions',
        builder: (context, state) => const SubDimensionsHubScreen(),
      ),
      GoRoute(
        path: '/sub-dimensions/pendidikan',
        builder: (context, state) => const PendidikanFormScreen(),
      ),
      GoRoute(
        path: '/sub-dimensions/kesehatan',
        builder: (context, state) => const KesehatanFormScreen(),
      ),
      GoRoute(
        path: '/sub-dimensions/utilitas-dasar',
        builder: (context, state) => const UtilitasDasarFormScreen(),
      ),
      GoRoute(
        path: '/sub-dimensions/aktivitas',
        builder: (context, state) => const AktivitasFormScreen(),
      ),
      GoRoute(
        path: '/sub-dimensions/fasilitas-masyarakat',
        builder: (context, state) => const FasilitasMasyarakatFormScreen(),
      ),
      GoRoute(
        path: '/sub-dimensions/produksi-desa',
        builder: (context, state) => const ProduksiDesaFormScreen(),
      ),
      GoRoute(
        path: '/sub-dimensions/fasilitas-ekonomi',
        builder: (context, state) => const FasilitasPendukungEkonomiFormScreen(),
      ),
      GoRoute(
        path: '/sub-dimensions/pengelolaan-lingkungan',
        builder: (context, state) => const PengelolaanLingkunganFormScreen(),
      ),
      GoRoute(
        path: '/sub-dimensions/penanggulangan-bencana',
        builder: (context, state) => const PenanggulanganBencanaFormScreen(),
      ),
      GoRoute(
        path: '/sub-dimensions/kondisi-akses-jalan',
        builder: (context, state) => const KondisiAksesJalanFormScreen(),
      ),
      GoRoute(
        path: '/sub-dimensions/kemudahan-akses',
        builder: (context, state) => const KemudahanAksesFormScreen(),
      ),
      GoRoute(
        path: '/sub-dimensions/kelembagaan-pelayanan',
        builder: (context, state) => const KelembagaanPelayananDesaFormScreen(),
      ),
      GoRoute(
        path: '/sub-dimensions/tata-kelola-keuangan',
        builder: (context, state) => const TataKelolaKeuanganDesaFormScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
});
