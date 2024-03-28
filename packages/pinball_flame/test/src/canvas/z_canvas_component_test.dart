// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestCircleComponent extends CircleComponent with ZIndex {
  _TestCircleComponent(Color color)
      : super(
          paint: Paint()..color = color,
          radius: 10,
        );
}

class _TestRectangleComponent extends RectangleComponent with ZIndex {
  _TestRectangleComponent(Color color)
      : super(
          paint: Paint()..color = color,
          size: Vector2.all(10),
        );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ZCanvasComponent', () {
    const goldensFilePath = '../goldens/rendering/';

    test('can be instantiated', () {
      expect(
        ZCanvasComponent(),
        isA<ZCanvasComponent>(),
      );
    });

    testWithGame<Forge2DGame>('loads correctly', Forge2DGame.new, (game) async {
      final component = ZCanvasComponent();
      await game.ensureAdd(component);
      expect(game.contains(component), isTrue);
    });

    testGolden(
      'red circle renders behind blue circle',
      (game) async {
        final canvas = ZCanvasComponent(
          children: [
            _TestCircleComponent(Colors.blue)..zIndex = 1,
            _TestRectangleComponent(Colors.red)..zIndex = 0,
          ],
        );
        await game.world.ensureAdd(canvas);
        game.camera.viewfinder
          ..zoom = 1.0
          ..position = Vector2.all(0);
      },
      goldenFile: '${goldensFilePath}red_blue.png',
      game: Forge2DGame(),
    );

    testGolden(
      'red circle renders behind blue circle',
      (game) async {
        final canvas = ZCanvasComponent(
          children: [
            _TestCircleComponent(Colors.blue)..zIndex = 0,
            _TestRectangleComponent(Colors.red)..zIndex = 1,
          ],
        );
        await game.world.ensureAdd(canvas);
        game.camera.viewfinder
          ..zoom = 1.0
          ..position = Vector2.all(0);
      },
      goldenFile: '${goldensFilePath}blue_red.png',
      game: Forge2DGame(),
    );
  });
}
