#import "ApplithiumCorePlugin.h"
#if __has_include(<applithium_core/applithium_core-Swift.h>)
#import <applithium_core/applithium_core-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "applithium_core-Swift.h"
#endif

@implementation ApplithiumCorePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftApplithiumCorePlugin registerWithRegistrar:registrar];
}
@end
