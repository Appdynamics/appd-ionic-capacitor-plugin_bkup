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
    /*
     - (void)beginCall:(CDVInvokedUrlCommand*)command {
         CDVPluginResult *result;

         @try {
             if ([command.arguments count] != 3) {
                 [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                 NSLog(@"Obj-C beginCall called -- bad command");
             } else {
                 NSString *name = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
                 NSString *selName = [command argumentAtIndex:1 withDefault:nil andClass:[NSString class]];

                 NSInteger additionalArgumentCount = [[command arguments] count] - 2;
                 NSArray *additionalArguments = nil;
                 if (additionalArgumentCount > 0) {
                     additionalArguments = [[command arguments] subarrayWithRange:NSMakeRange(2, additionalArgumentCount)];
                 }

                 // Generate tracking key
                 NSString *key = [self generateKey];
                 NSLog(@"beginCall with key:%@ name:%@ selector:%@", key, name, selName);

                 SEL sel = NSSelectorFromString(selName);

                 if ([name length] > 0 && [selName length] > 0) {
                     id tracker = [ADEumInstrumentation beginCall:name selector:sel withArguments:additionalArguments];
                     self.keymap[key] = tracker;
                     result = [self finalizeSuccessfulResult:key];
                 } else {
                     result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Name or method missing or invalid"];
                 }
             }
         } @catch (NSException *exception) {
             result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
         }

         [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
     }
     */
}
