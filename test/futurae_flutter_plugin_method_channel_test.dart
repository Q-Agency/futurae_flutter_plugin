import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futurae_flutter_plugin/futurae_flutter_plugin.dart';

void main() {
  MethodChannelFuturaeFlutterPlugin platform =
      MethodChannelFuturaeFlutterPlugin();
  const MethodChannel channel = MethodChannel('futurae_flutter_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return true;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('sdkIsLaunched', () async {
    expect(await platform.sdkIsLaunched(), true);
  });
}
