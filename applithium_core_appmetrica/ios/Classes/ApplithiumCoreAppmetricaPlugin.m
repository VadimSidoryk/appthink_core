#import "ApplithiumCoreAppmetricaPlugin.h"
#if __has_include(<applithium_core_appmetrica/applithium_core_appmetrica-Swift.h>)
#import <applithium_core_appmetrica/applithium_core_appmetrica-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "applithium_core_appmetrica-Swift.h"
#endif

@implementation ApplithiumCoreAppmetricaPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftApplithiumCoreAppmetricaPlugin registerWithRegistrar:registrar];
}
@end
