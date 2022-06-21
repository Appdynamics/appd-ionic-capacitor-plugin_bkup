import Foundation
import ADEUMInstrumentation
import Capacitor

@objc public class ADEUMMobileCapacitorPlugin: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
    @objc public func pluginInitialize(config: ADEumAgentConfiguration) -> Void {
        ADEumInstrumentation.initWith(config)
    }
    @objc public func startTimerWithName(name: String) -> Void {
        ADEumInstrumentation.startTimer(withName: name)
    }
    @objc public func stopTimerWithName(name: String) -> Void {
        ADEumInstrumentation.stopTimer(withName: name)
    }
    @objc public func reportMetricWithName(name: String, value: Int64) -> Void {
        ADEumInstrumentation.reportMetric(withName: name, value: value)
    }
    @objc public func leaveBreadcrumb(name: String?) -> Void {
        ADEumInstrumentation.leaveBreadcrumb(name)
    }
    @objc public func setUserData(key: String, value: String) -> Void {
        ADEumInstrumentation.setUserData(key, value: value)
    }
    @objc public func removeUserData(key: String) -> Void {
        ADEumInstrumentation.removeUserData(key)
    }
    @objc public func takeScreenshot() -> Void {
        ADEumInstrumentation.takeScreenshot()
    }
    /*
     * For the plugin I do not think any ios centric beginCall makes sense
    @objc public func beginCall(receiver: Any, selector: Selector, withArguments: [Any]?) -> Any? {
        //ADEumInstrumentation.beginCall(<#T##receiver: Any##Any#>, selector: <#T##Selector#>)
        return ADEumInstrumentation.beginCall(receiver, selector: selector, withArguments: withArguments)
        
    }*/
    @objc public func beginCall(className: String, methodName: String, withArguments: [Any]) -> Any? {
        return ADEumInstrumentation.beginCall(className, methodName: methodName, withArguments: withArguments)
    }
    
    @objc public func endCall(tracker: Any) -> Void {
        ADEumInstrumentation.endCall(tracker)
    }
    
    @objc public func beginHttpRequest(url: URL) -> ADEumHTTPRequestTracker{
        return ADEumHTTPRequestTracker.init(url: url)
    }
    /*
     - (void)beginHttpRequest:(CDVInvokedUrlCommand*)command {
         CDVPluginResult *result;
         @try {
             if ([command.arguments count] != 1) {
                 [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                 NSLog(@"Obj-C beginHttpRequest called -- bad command");
             } else {
                 NSString *url = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
                 NSLog(@"beginHttpRequest %@", url);

                 // get UUID for key
                 NSString *key = [self generateKey];
                 NSURL *nsurl = [[NSURL alloc] initWithString:url]; // new url from string

                 if ([url length] > 0 && nsurl != nil) {
                     ADEumHTTPRequestTracker *tracker = [ADEumHTTPRequestTracker requestTrackerWithURL:nsurl];
                     self.keymap[key] = tracker;
                     result = [self finalizeSuccessfulResult:key];
                 } else {
                     result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR  messageAsString:@"Missing or invalid URL"];
                 }
             }
         } @catch (NSException *exception) {
             result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
         }
         [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
     }
     */
}
