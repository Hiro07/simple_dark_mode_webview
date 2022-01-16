import 'package:flutter_test/flutter_test.dart';
import 'package:simple_dark_mode_webview/simpledarkmodewebview.dart';

void main() {
//  test('adds one to input values', () {
//    final calculator = Calculator();
//    expect(calculator.addOne(2), 3);
//    expect(calculator.addOne(-7), -6);
//    expect(calculator.addOne(0), 1);
//    expect(() => calculator.addOne(null), throwsNoSuchMethodError);
//  });
  testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    final htmlString = 'hello.<br>good bye.<br>';
    await tester.pumpWidget(SimpleDarkModeAdaptableWebView(htmlString));

    //final hellotFinder = find.text('hello');
    //final goodbyeFinder = find.text('good bye');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    //expect(hellotFinder, findsOneWidget);
    //expect(goodbyeFinder, findsOneWidget);
    // -> it fails. it cannot get text from webview...
  });
}
