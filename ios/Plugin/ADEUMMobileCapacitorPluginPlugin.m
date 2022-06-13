#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>
#import <ADEUMInstrumentation/ADEumInstrumentation.h>
#import <ADEUMInstrumentation/ADEumHTTPRequestTracker.h>
#import <ADEUMInstrumentation/ADEumServerCorrelationHeaders.h>
#import <ADEUMInstrumentation/ADEumSessionFrame.h>
#import "ADEUMPluginVersion.h"

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(ADEUMMobileCapacitorPluginPlugin, "ADEUMMobileCapacitorPlugin",
           CAP_PLUGIN_METHOD(echo, CAPPluginReturnPromise);
)
