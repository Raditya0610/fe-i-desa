import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fe_apps_i_desa/presentation/screens/auth/login_screen.dart';
import 'package:fe_apps_i_desa/presentation/screens/auth/register_screen.dart';
import 'package:fe_apps_i_desa/providers/auth_provider.dart';
import 'package:fe_apps_i_desa/data/services/auth_service.dart';
import 'package:forui/forui.dart';

class MockAuthService extends Mock implements AuthService {}
class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockAuthService mockAuthService;
  late MockGoRouter mockGoRouter;
  
  setUp(() {
    mockAuthService = MockAuthService();
    mockGoRouter = MockGoRouter();

    // Default return for authService.isLoggedIn / getUsername
    when(() => mockAuthService.isLoggedIn()).thenAnswer((_) async => false);
    when(() => mockAuthService.getUsername()).thenAnswer((_) async => null);

    // Mock GoRouter
    when(() => mockGoRouter.go(any())).thenReturn(null);
    when(() => mockGoRouter.push(any())).thenAnswer((_) => Future<Object?>.value(null));
    when(() => mockGoRouter.pushReplacement(any())).thenAnswer((_) => Future<Object?>.value(null));
    
    // Ignore RenderFlex overflow during tests
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('RenderFlex')) {
        return;
      }
      FlutterError.presentError(details);
    };
  });

  Widget createLoginTestWidget() {
    return ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(mockAuthService),
      ],
      child: InheritedGoRouter(
        goRouter: mockGoRouter,
        child: const MaterialApp(
          home: Scaffold(body: LoginScreen()),
        ),
      ),
    );
  }

  Widget createRegisterTestWidget() {
    return ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(mockAuthService),
      ],
      child: InheritedGoRouter(
        goRouter: mockGoRouter,
        child: const MaterialApp(
          home: Scaffold(body: RegisterScreen()),
        ),
      ),
    );
  }

  group('Authentication Screens Testing', () {
    testWidgets('FE-01: Render form login tampil dengan benar', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createLoginTestWidget());
      await tester.pumpAndSettle();

      // Verify all components exist
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Masuk'), findsOneWidget);
      expect(find.text('Daftar di sini'), findsOneWidget);
    });

    testWidgets('FE-02: Validasi field username wajib diisi', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createLoginTestWidget());
      await tester.pumpAndSettle();

      // Leave username empty, fill password
      await tester.enterText(find.byType(TextFormField).last, 'password123'); // Password field
      await tester.ensureVisible(find.text('Masuk'));
      await tester.tap(find.text('Masuk'));
      await tester.pumpAndSettle();

      // Verify error text
      expect(find.text('Username harus diisi'), findsOneWidget);
    });

    testWidgets('FE-03: Login', (WidgetTester tester) async {
      when(() => mockAuthService.login(any(), any())).thenAnswer(
        (_) async => {'success': true, 'message': 'Login Successful'},
      );

      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createLoginTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'testuser');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      
      await tester.ensureVisible(find.text('Masuk'));
      await tester.tap(find.text('Masuk'));
      await tester.pumpAndSettle();

      verify(() => mockAuthService.login('testuser', 'password123')).called(1);
      verify(() => mockGoRouter.go('/')).called(1);
    });

    testWidgets('FE-04: Validasi field di register screen wajib diisi', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createRegisterTestWidget());
      await tester.pumpAndSettle();

      // Tap Register without filling anything
      await tester.ensureVisible(find.text('Daftar'));
      await tester.tap(find.text('Daftar'));
      await tester.pumpAndSettle();

      expect(find.text('Username harus diisi'), findsOneWidget);
      expect(find.text('Desa harus dipilih'), findsOneWidget);
      expect(find.text('Password harus diisi'), findsOneWidget);
      expect(find.text('Konfirmasi password harus diisi'), findsOneWidget);
    });

    testWidgets('FE-05: Register', (WidgetTester tester) async {
      when(() => mockAuthService.register(any(), any(), any())).thenAnswer(
        (_) async => {'success': true, 'message': 'Registration Successful'},
      );

      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createRegisterTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'newuser');
      
      // Select Dropdown
      await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Ohoi Iso').last);
      await tester.tap(find.text('Ohoi Iso').last);
      await tester.pumpAndSettle();

      // Passwords
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');

      await tester.ensureVisible(find.text('Daftar'));
      await tester.tap(find.text('Daftar'));
      await tester.pumpAndSettle();

      verify(() => mockAuthService.register('newuser', 'password123', '83eb95cc-e9ac-425f-8cef-2c3db0e0c24a')).called(1);
      verify(() => mockGoRouter.go('/login')).called(1);
    });

    testWidgets('FE-06: Routing screen dari login ke register', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createLoginTestWidget());
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Daftar di sini'));
      await tester.tap(find.text('Daftar di sini'));
      await tester.pumpAndSettle();
      verify(() => mockGoRouter.push('/register')).called(1);
    });

    testWidgets('FE-06: Routing screen dari register ke login', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createRegisterTestWidget());
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Masuk di sini'));
      await tester.tap(find.text('Masuk di sini'));
      await tester.pumpAndSettle();
      verify(() => mockGoRouter.go('/login')).called(1);
    });
  });
}
