import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:fooddelivery/features/order/presentation/blocs/order_bloc.dart';

void main() {
  late OrderBloc orderBloc;

  group('OrderBloc Tests', () {
    setUp(() {
      orderBloc = OrderBloc();
    });

    tearDown(() {
      orderBloc.close();
    });

    test('initial state should be OrderInitial', () {
      expect(orderBloc.state, equals(OrderInitial()));
    });

    // Simple test to verify basic functionality
    blocTest<OrderBloc, OrderState>(
      'should remain in initial state when no events are added',
      build: () => orderBloc,
      expect: () => [],
    );
  });
}
