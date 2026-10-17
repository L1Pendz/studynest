
import 'package:flutter_test/flutter_test.dart';
import 'package:studynest/app.dart';

void main() {
  testWidgets('StudyNest navigation works', (tester) async {
    await tester.pumpWidget(const StudyNestApp());

    // Check the initial screen.
    expect(find.text('Welcome to StudyNest!'), findsOneWidget);

    // Open Subjects.
    await tester.tap(find.text('Subjects').last);
    await tester.pumpAndSettle();

    expect(find.text('My Subjects'), findsOneWidget);
    expect(find.text('Database Systems'), findsOneWidget);

    // Open Tasks.
    await tester.tap(find.text('Tasks').last);
    await tester.pumpAndSettle();

    expect(find.text('Your Tasks'), findsOneWidget);
  });
}
