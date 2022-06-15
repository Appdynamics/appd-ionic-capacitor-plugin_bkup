import Foundation
import ADEUMInstrumentation
import Capacitor

@objc public class ADEUMMobileCapacitorPlugin: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
    @objc public func pluginInitialize() -> Void {
        //self.keymap = [[NSMutableDictionary alloc] initWithCapacity:0];
        // Load Agent configuration settings from info.plist
        /* NSDictionary *adeumSettings = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"ADEUM_Settings"];
        NSString *appKey = [adeumSettings objectForKey:@"ADEUM_APP_KEY"];
        NSString *collectorUrl = [adeumSettings objectForKey:@"ADEUM_COLLECTOR_URL"];
        NSString *screenshotUrl = [adeumSettings objectForKey:@"ADEUM_SCREENSHOT_URL"];
        NSString *screenshotsEnabled = [adeumSettings objectForKey:@"ADEUM_SCREENSHOTS_ENABLED"];
        NSNumber *loggingLevel = @([[adeumSettings objectForKey:@"ADEUM_LOGGING_LEVEL"] intValue]);
        NSString *reachabilityHost = [adeumSettings objectForKey:@"ADEUM_REACHABILITY_HOST"];
        NSNumber *interactionCaptureMode = @([[adeumSettings objectForKey:@"ADEUM_INTERACTION_CAPTURE_MODE"] intValue]); */
        let appKey = getConfigValue("ADEUM_APP_KEY") as!

        if (appKey) {
            // If appKey malformed this will throw exception.
            self.config = [[ADEumAgentConfiguration alloc] initWithAppKey:appKey];

            if (![self setCollectorUrl:collectorUrl]) {
                NSLog(@"Agent failed to start due to bad COLLECTOR_URL param.");
                return;
            }

            if (![self setLoggingLevel:loggingLevel]) {
                NSLog(@"Agent failed to start due to bad LOGGING_LEVEL param.");
                return;
            }

            if (![self setScreenshotsEnabled:screenshotsEnabled]) {
                NSLog(@"Agent failed to start due to bad SCREENSHOTS_ENABLED param.");
                return;
            }

            if (![self setScreenshotUrl:screenshotUrl]) {
                NSLog(@"Agent failed to start due to bad SCREENSHOT_URL param.");
                return;
            }

            if (![self setInteractionCaptureMode:interactionCaptureMode]) {
                NSLog(@"Agent failed to start due to bad INTERACTION_CAPTURE_MODE param.");
                return;
            }

            if (![self setReachabilityHostName:reachabilityHost]) {
                NSLog(@"Agent failed to start due to bad REACHABILITY_HOST param.");
                return;
            }

            [ADEumInstrumentation initWithConfiguration:_config a:ADEumPluginHybridAgentType b:ADEumPluginHybridAgentVersion];
            // Force generation of "App Start" beacon if API call is available
            SEL gabsSelector = NSSelectorFromString(@"generateAppStartBeacon");
            if ([ADEumInstrumentation respondsToSelector:gabsSelector]) {
                [ADEumInstrumentation performSelector:gabsSelector];
            }
        }
    }
}
