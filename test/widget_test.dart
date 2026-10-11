
import 'package:flutter_test/flutter_test.dart';
import 'package:studynest/app.dart';

void main() {
  testWidgets('StudyNest navigation works', (WidgetTester tester) async {
    await tester.pumpWidget(const StudyNestApp());

    expect(find.text('StudyNest'), findsOneWidget);
    expect(find.text('Subjects'), findsWidgets);
    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Resources'), findsOneWidget);

    await tester.tap(find.text('Subjects').last);
    await tester.pumpAndSettle();

    expect(find.text('Your Subjects'), findsOneWidget);
  });
}
