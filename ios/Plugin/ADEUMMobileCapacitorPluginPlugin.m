#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>
#import <ADEUMInstrumentation/ADEumInstrumentation.h>
#import <ADEUMInstrumentation/ADEumHTTPRequestTracker.h>
#import <ADEUMInstrumentation/ADEumServerCorrelationHeaders.h>
#import <ADEUMInstrumentation/ADEumSessionFrame.h>
//#import "ADEUMPluginVersion.h"

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(ADEUMMobileCapacitorPluginPlugin, "ADEUMMobileCapacitorPlugin",
           CAP_PLUGIN_METHOD(echo, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(startTimer, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(stopTimer, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(reportMetricWithName, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(leaveBreadcrumb, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(setUserData, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(removeUserData, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(takeScreenshot, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(beginCall, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(endCall, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(beginHttpRequest, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(reportDone, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(withResponseCode, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(withResponseContentLength, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(withRequestContentLength, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(withResponseHeaderFields, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(withRequestHeaderFields, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(withInstrumentationSource, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(withErrorMessage, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(getCorrelationHeaders, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(startNextSession, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(unblockScreenshots, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(blockScreenshots, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(screenshotsBlocked, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(startSessionFrame, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(endSessionFrame, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(updateSessionFrameName, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getVersion, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(clear, CAPPluginReturnNone);
            //we don't declare load but if this doesn't auto init agent we may need to make our init it's own
            //method and then declare it
           //CAP_PLUGIN_METHOD(load, CAPPluginReturnPromise);
)
