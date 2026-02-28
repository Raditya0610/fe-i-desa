import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:fe_apps_i_desa/presentation/widgets/common/app_sidebar.dart';
import 'package:fe_apps_i_desa/providers/auth_provider.dart';
import 'package:fe_apps_i_desa/data/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;
  late GoRouter router;

  setUp(() {
    mockAuthService = MockAuthService();

    when(() => mockAuthService.isLoggedIn()).thenAnswer((_) async => true);
    when(() => mockAuthService.getUsername()).thenAnswer((_) async => 'admin');
    when(() => mockAuthService.logout()).thenAnswer((_) async => <String, dynamic>{'success': true});
  });

  Widget createSidebarTestWidget({String initialRoute = '/'}) {
    router = GoRouter(
      initialLocation: initialRoute,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: AppSidebar()),
        ),
        GoRoute(
          path: '/family-cards',
          builder: (context, state) => const Scaffold(body: AppSidebar()),
        ),
        GoRoute(
          path: '/sub-dimensions',
          builder: (context, state) => const Scaffold(body: AppSidebar()),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(mockAuthService),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  group('Navigation/Sidebar Tests', () {
    testWidgets('FE-07: Render sidebar components post-login', (WidgetTester tester) async {
      // Set to physical size large enough to avoid any flex overflows in sidebar render
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(createSidebarTestWidget());
      await tester.pumpAndSettle();

      // Verify branding
      expect(find.text('Apps i-Desa'), findsOneWidget);

      // Verify menu items
      expect(find.text('MENU UTAMA'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Data Penduduk'), findsOneWidget);
      expect(find.text('Indikator Desa'), findsOneWidget);

      // Verify user profile
      expect(find.text('Administrator'), findsOneWidget);
      expect(find.text('Online'), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    });

    testWidgets('FE-08: Routing via sidebar menus', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createSidebarTestWidget());
      await tester.pumpAndSettle();

      // Test Dashboard Navigation
      await tester.ensureVisible(find.text('Dashboard'));
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();
      expect(router.routerDelegate.currentConfiguration.uri.toString(), '/');

      // Test Indikator Desa Navigation
      await tester.ensureVisible(find.text('Indikator Desa'));
      await tester.tap(find.text('Indikator Desa'));
      await tester.pumpAndSettle();
      expect(router.routerDelegate.currentConfiguration.uri.toString(), '/sub-dimensions');

      // Expand Data Penduduk
      await tester.ensureVisible(find.text('Data Penduduk'));
      await tester.tap(find.text('Data Penduduk'));
      await tester.pumpAndSettle();
      
      // Should reveal 'Keluarga'
      expect(find.text('Keluarga'), findsOneWidget);
      await tester.ensureVisible(find.text('Keluarga'));
      await tester.tap(find.text('Keluarga'));
      await tester.pumpAndSettle();
      expect(router.routerDelegate.currentConfiguration.uri.toString(), '/family-cards');

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    });
  });
}
