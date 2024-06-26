// ignore_for_file: cascade_invocations

import 'package:bloc/bloc.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _FakeCubit extends Fake implements Cubit<Object> {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    'FlameProvider',
    () {
      test('can be instantiated', () {
        expect(
          FlameProvider<bool>.value(true),
          isA<FlameProvider<bool>>(),
        );
      });

      testWithFlameGame('can be loaded', (game) async {
        final component = FlameProvider<bool>.value(true);
        await game.ensureAdd(component);
        expect(game.children, contains(component));
      });

      testWithFlameGame('adds children', (game) async {
        final component = Component();
        final provider = FlameProvider<bool>.value(
          true,
          children: [component],
        );
        await game.ensureAdd(provider);
        expect(provider.children, contains(component));
      });
    },
  );

  group('MultiFlameProvider', () {
    test('can be instantiated', () {
      expect(
        MultiFlameProvider(
          providers: [
            FlameProvider<bool>.value(true),
          ],
        ),
        isA<MultiFlameProvider>(),
      );
    });

    testWithFlameGame('adds multiple providers', (game) async {
      final provider1 = FlameProvider<bool>.value(true);
      final provider2 = FlameProvider<bool>.value(true);
      final providers = MultiFlameProvider(
        providers: [provider1, provider2],
      );
      await game.ensureAdd(providers);
      expect(providers.children, contains(provider1));
      expect(provider1.children, contains(provider2));
    });

    testWithFlameGame('adds children under provider', (game) async {
      final component = Component();
      final provider = FlameProvider<bool>.value(true);
      final providers = MultiFlameProvider(
        providers: [provider],
        children: [component],
      );
      await game.ensureAdd(providers);
      expect(provider.children, contains(component));
    });
  });

  group(
    'ReadFlameProvider',
    () {
      testWithFlameGame('loads provider', (game) async {
        final component = Component();
        final provider = FlameProvider<bool>.value(
          true,
          children: [component],
        );
        await game.ensureAdd(provider);
        expect(component.readProvider<bool>(), isTrue);
      });

      testWithFlameGame(
        'throws assertionError when no provider is found',
        (game) async {
          final component = Component();
          await game.ensureAdd(component);

          expect(
            () => component.readProvider<bool>(),
            throwsAssertionError,
          );
        },
      );
    },
  );

  group(
    'ReadFlameBlocProvider',
    () {
      testWithFlameGame('loads provider', (game) async {
        final component = Component();
        final bloc = _FakeCubit();
        final provider = FlameBlocProvider<_FakeCubit, Object>.value(
          value: bloc,
          children: [component],
        );
        await game.ensureAdd(provider);
        expect(component.readBloc<_FakeCubit, Object>(), equals(bloc));
      });

      testWithFlameGame(
        'throws assertionError when no provider is found',
        (game) async {
          final component = Component();
          await game.ensureAdd(component);

          expect(
            () => component.readBloc<_FakeCubit, Object>(),
            throwsAssertionError,
          );
        },
      );
    },
  );
}
