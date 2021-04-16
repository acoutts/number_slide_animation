import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:number_slide_animation/src/number_col.dart';

void main() {
  test('try initializing with invalid number', () {
    expect(
        () => new NumberCol(
              numberDuration: const Duration(seconds: 1),
              numberCurve: Curves.easeIn,
              textStyle: TextStyle(fontSize: 16.0),
              number: 10,
            ),
        throwsAssertionError);
    expect(
        () => new NumberCol(
              numberDuration: const Duration(seconds: 1),
              numberCurve: Curves.easeIn,
              textStyle: TextStyle(fontSize: 16.0),
              number: -100,
            ),
        throwsAssertionError);
    expect(
        () => new NumberCol(
              numberDuration: const Duration(seconds: 1),
              numberCurve: Curves.easeIn,
              textStyle: TextStyle(fontSize: 16.0),
              number: 100,
            ),
        throwsAssertionError);
  });
}
