import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _MockSpriteAnimationController extends Mock
    implements SpriteAnimationController {}

class _MockSpriteAnimationTicker extends Mock
    implements SpriteAnimationTicker {}

class _MockSprite extends Mock implements Sprite {}

void main() {
  group('PinballSpriteAnimationWidget', () {
    late SpriteAnimationController controller;
    late SpriteAnimationTicker ticker;
    late Sprite sprite;

    setUp(() {
      controller = _MockSpriteAnimationController();
      ticker = _MockSpriteAnimationTicker();
      sprite = _MockSprite();

      when(() => controller.ticker).thenReturn(ticker);
      when(() => ticker.totalDuration()).thenReturn(1);
      when(() => ticker.getSprite()).thenReturn(sprite);
      when(() => sprite.srcSize).thenReturn(Vector2(1, 1));
      when(() => sprite.srcSize).thenReturn(Vector2(1, 1));
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        SpriteAnimationWidget(
          controller: controller,
        ),
      );

      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });

    test('SpriteAnimationController is updating animations', () {
      SpriteAnimationController(
        vsync: const TestVSync(),
        ticker: ticker,
      ).notifyListeners();

      verify(() => ticker.update(any())).called(1);
    });

    testWidgets('SpritePainter shouldRepaint returns true when Sprite changed',
        (tester) async {
      final spritePainter = SpritePainter(
        sprite,
        Anchor.center,
        angle: 45,
      );

      final anotherPainter = SpritePainter(
        sprite,
        Anchor.center,
        angle: 30,
      );

      expect(spritePainter.shouldRepaint(anotherPainter), isTrue);
    });
  });
}
