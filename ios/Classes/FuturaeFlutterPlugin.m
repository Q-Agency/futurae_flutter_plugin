#import "FuturaeFlutterPlugin.h"
#if __has_include(<futurae_flutter_plugin/futurae_flutter_plugin-Swift.h>)
#import <futurae_flutter_plugin/futurae_flutter_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "futurae_flutter_plugin-Swift.h"
#endif

@implementation FuturaeFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFuturaeFlutterPlugin registerWithRegistrar:registrar];
}
@end
