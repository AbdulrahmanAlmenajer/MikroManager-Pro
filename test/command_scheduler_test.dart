import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mikro_manager_pro/core/network/routeros_adapter.dart';
import 'package:mikro_manager_pro/core/network/routeros_command_scheduler.dart';
import 'package:mikro_manager_pro/core/network/routeros_socket_client.dart';

class MockRouterOsAdapter extends Mock implements RouterOsAdapter {}

void main() {
  group('RouterOsCommandScheduler Tests', () {
    late MockRouterOsAdapter mockAdapter;
    late RouterOsCommandScheduler scheduler;

    setUp(() {
      mockAdapter = MockRouterOsAdapter();
      scheduler = RouterOsCommandScheduler(
        adapter: mockAdapter,
        connectionId: 1,
      );
    });

    tearDown(() {
      scheduler.dispose();
    });

    test('De-duplicates concurrent in-flight queries', () async {
      final completer = Completer<RouterOsResponse>();
      when(() => mockAdapter.executeSentence(['/system/resource/print']))
          .thenAnswer((_) => completer.future);

      // Trigger two concurrent requests for the identical sentence
      final future1 = scheduler.execute(['/system/resource/print']);
      final future2 = scheduler.execute(['/system/resource/print']);

      // Complete the sentence once
      completer.complete(RouterOsResponse(
        isSuccess: true,
        data: [
          {'uptime': '1d2h', 'cpu-load': '12'}
        ],
      ));

      final res1 = await future1;
      final res2 = await future2;

      expect(res1.isSuccess, isTrue);
      expect(res2.isSuccess, isTrue);
      expect(res1.data.first['uptime'], '1d2h');
      expect(res2.data.first['uptime'], '1d2h');

      // Verify adapter was invoked only ONCE despite two callers!
      verify(() => mockAdapter.executeSentence(['/system/resource/print']))
          .called(1);
    });

    test('Shared polling stream produces values and handles listeners cleanly',
        () async {
      int fetchCount = 0;
      final stream = scheduler.registerPollingStream<int>(
        key: 'test_counter',
        interval: const Duration(milliseconds: 50),
        fetcher: () async => ++fetchCount,
      );

      final List<int> receivedValues = [];
      final sub = stream.listen((val) {
        receivedValues.add(val);
      });

      // Wait a few cycles
      await Future.delayed(const Duration(milliseconds: 140));
      await sub.cancel();

      expect(receivedValues, isNotEmpty);
      expect(receivedValues.first, equals(1));
    });
  });
}
