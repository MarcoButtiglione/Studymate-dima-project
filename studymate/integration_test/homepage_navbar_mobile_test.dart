import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:studymate/main.dart' as app;
import 'package:studymate/screens/Authenticated/Chat/chats_page.dart';
import 'package:studymate/screens/Authenticated/Search/search_page.dart';
import 'package:studymate/screens/Authenticated/authenticated.dart';
import 'package:studymate/screens/Authenticated/createLesson/new_lesson_page.dart';
import 'package:studymate/screens/Authenticated/homepage.dart';
import 'package:studymate/screens/Authenticated/profilePage/own_profile_page.dart';
import 'package:studymate/screens/Login/login.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Clicking on home navbar item smartphone', (tester) async {
    //setup
    app.main();
    //do
    await tester.pumpAndSettle(const Duration(seconds: 5));
    final button = find.byKey(Key('skipButtonVer'));

    expect(button, findsOneWidget);
    await tester.tap(button);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    final buttonStart = find.byKey(Key('startOnBoardingVertical'));
    expect(buttonStart, findsOneWidget);
    await tester.tap(buttonStart);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    //test
    expect(find.byType(Login), findsOneWidget);

    final textFormFieldFinder = find.byKey(Key('emailFieldLogin'));
    expect(textFormFieldFinder, findsOneWidget);
    final passwordFormFieldFinder = find.byKey(Key('passwordFieldLogin'));
    expect(passwordFormFieldFinder, findsOneWidget);
    // Enter valid email text
    final validEmailText = 'karaortega@gmail.com';
    await tester.enterText(textFormFieldFinder, validEmailText);
    await tester.enterText(passwordFormFieldFinder, 'karaortega');
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final buttonLogin = find.byKey(Key('loginButton'));
    await tester.tap(buttonLogin);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.byType(Authenticated), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    
    //test

    expect(find.byType(HomePage), findsOneWidget);
  });
  testWidgets('Clicking on search navbar item smartphone', (tester) async {
    //setup
    app.main();
    //do
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.byType(Authenticated), findsOneWidget);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    //test

    expect(find.byType(SearchPage), findsOneWidget);
  });
  testWidgets('Clicking on add navbar item smartphone', (tester) async {
    //setup
    app.main();
    //do
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byType(Authenticated), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    //test

    expect(find.byType(NewLessonPage), findsOneWidget);
  });
  testWidgets('Clicking on message navbar item smartphone', (tester) async {
    //setup
    app.main();
    //do
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byType(Authenticated), findsOneWidget);

    await tester.tap(find.byIcon(Icons.message));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    //test

    expect(find.byType(ChatsPage), findsOneWidget);
  });
  testWidgets('Clicking on profile navbar item smartphone', (tester) async {
    //setup
    app.main();
    //do
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byType(Authenticated), findsOneWidget);

    await tester.tap(find.byIcon(Icons.account_circle));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    //test

    expect(find.byType(OwnProfilePage), findsOneWidget);
  });
}
