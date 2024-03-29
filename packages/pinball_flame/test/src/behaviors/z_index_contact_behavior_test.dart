import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestBodyComponent extends BodyComponent {
  @override
  Body createBody() {
    final shape = CircleShape()..radius = 1;
    return world.createBody(BodyDef())..createFixtureFromShape(shape);
  }
}

class _TestZIndexBodyComponent extends _TestBodyComponent with ZIndex {
  _TestZIndexBodyComponent({required int zIndex}) {
    zIndex = zIndex;
  }
}

class _MockContact extends Mock implements Contact {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ZIndexContactBehavior', () {
    test('can be instantiated', () {
      expect(
        ZIndexContactBehavior(zIndex: 0),
        isA<ZIndexContactBehavior>(),
      );
    });

    testWithGame<Forge2DGame>(
      'can be loaded',
      Forge2DGame.new,
      (game) async {
        final behavior = ZIndexContactBehavior(zIndex: 0);
        final parent = _TestBodyComponent();
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);
        expect(parent.children, contains(behavior));
      },
    );

    testWithGame<Forge2DGame>(
      'beginContact changes zIndex',
      Forge2DGame.new,
      (game) async {
        const oldIndex = 0;
        const newIndex = 1;
        final behavior = ZIndexContactBehavior(zIndex: newIndex);
        final parent = _TestBodyComponent();
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);

        final component = _TestZIndexBodyComponent(zIndex: oldIndex);

        behavior.beginContact(component, _MockContact());

        expect(component.zIndex, newIndex);
      },
    );

    testWithGame<Forge2DGame>(
      'endContact changes zIndex',
      Forge2DGame.new,
      (game) async {
        const oldIndex = 0;
        const newIndex = 1;
        final behavior =
            ZIndexContactBehavior(zIndex: newIndex, onBegin: false);
        final parent = _TestBodyComponent();
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);

        final component = _TestZIndexBodyComponent(zIndex: oldIndex);

        behavior.endContact(component, _MockContact());

        expect(component.zIndex, newIndex);
      },
    );
  });
}
