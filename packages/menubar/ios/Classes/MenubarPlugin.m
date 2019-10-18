#import "MenubarPlugin.h"
#import <menubar/menubar-Swift.h>

@implementation MenubarPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMenubarPlugin registerWithRegistrar:registrar];
}
@end
