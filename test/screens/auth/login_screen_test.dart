import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tcl_mobile_app/providers/auth_provider.dart';
import 'package:tcl_mobile_app/screens/auth/login_screen.dart';
import 'package:tcl_mobile_app/models/user_model.dart';
import 'package:tcl_mobile_app/models/user_model.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<AuthProvider>()])
import 'login_screen_test.mocks.dart';

void main() {
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
  });

  Widget createLoginScreen() {
    return MaterialApp(
      home: ChangeNotifierProvider<AuthProvider>.value(
        value: mockAuthProvider,
        child: LoginScreen(),
      ),
    );
  }

  testWidgets('Login screen shows all required elements', (WidgetTester tester) async {
    await tester.pumpWidget(createLoginScreen());

    // Verify that all important widgets are present
    expect(find.text('TCL Mobile App'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Shows error on empty email and password', (WidgetTester tester) async {
    await tester.pumpWidget(createLoginScreen());

    // Tap login button without entering credentials
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Verify error messages are shown
    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });

  testWidgets('Shows error on invalid email format', (WidgetTester tester) async {
    await tester.pumpWidget(createLoginScreen());

    // Enter invalid email
    await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Verify error message is shown
    expect(find.text('Please enter a valid email'), findsOneWidget);
  });

  testWidgets('Calls login method with correct credentials', (WidgetTester tester) async {
    when(mockAuthProvider.login(any, any)).thenAnswer((_) async => true);
    when(mockAuthProvider.user).thenReturn(null);

    await tester.pumpWidget(createLoginScreen());

    // Enter valid credentials
    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    
    // Tap login button
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Verify login method was called with correct credentials
    verify(mockAuthProvider.login('test@example.com', 'password123')).called(1);
  });

  testWidgets('Shows loading state during login', (WidgetTester tester) async {
    // Setup mock to delay the response
    when(mockAuthProvider.login(any, any)).thenAnswer(
      (_) => Future.delayed(Duration(seconds: 1), () => true),
    );
    when(mockAuthProvider.user).thenReturn(null);

    await tester.pumpWidget(createLoginScreen());

    // Enter credentials and tap login
    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Verify loading state
    expect(find.text('Logging in...'), findsOneWidget);
  });

  testWidgets('Shows error message on login failure', (WidgetTester tester) async {
    when(mockAuthProvider.login(any, any)).thenAnswer((_) async => false);

    await tester.pumpWidget(createLoginScreen());

    // Enter credentials and tap login
    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Verify error message is shown
    expect(
      find.text('Login failed. Please check your credentials.'),
      findsOneWidget,
    );
  });

  testWidgets('Navigates to correct dashboard on successful login',
      (WidgetTester tester) async {
    when(mockAuthProvider.login(any, any)).thenAnswer((_) async => true);
    
    // Test admin navigation
    when(mockAuthProvider.user).thenReturn(
      UserModel(
        id: '1',
        email: 'admin@test.com',
        name: 'Admin User',
        role: 'admin',
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AuthProvider>.value(
          value: mockAuthProvider,
          child: LoginScreen(),
        ),
        routes: {
          '/admin-dashboard': (context) => Scaffold(body: Text('Admin Dashboard')),
          '/agent-dashboard': (context) => Scaffold(body: Text('Agent Dashboard')),
        },
      ),
    );

    // Enter credentials and login
    await tester.enterText(find.byType(TextFormField).first, 'admin@test.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Verify navigation to admin dashboard
    expect(find.text('Admin Dashboard'), findsOneWidget);
  });
}
