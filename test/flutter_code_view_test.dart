import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_code_view/flutter_code_view.dart';

void main() {
  test('adds one to input values', () {
    final flutterCodeView = FlutterCodeView(
      source: '',
    );
    expect(flutterCodeView.input, 1);
  });
}
