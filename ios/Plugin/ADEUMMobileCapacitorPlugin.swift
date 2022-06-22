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
    
    @objc public func getCorrelationHeaders() -> Any {
        let headers = ADEumServerCorrelationHeaders.generate()
        return headers
    }
    
    @objc public func beginHttpRequest(url: URL) -> ADEumHTTPRequestTracker{
        //may need to just move these to being tracked and stored as instance vars
        //so we just return a key/guid and skip serialization
        return ADEumHTTPRequestTracker.init(url: url)
    }
    
    @objc public func reportDone(tracker: Any){
        //may need to just move these to being tracked and stored as instance vars
        //so we just return a key/guid and skip serialization
        let http_tracker = tracker as! ADEumHTTPRequestTracker
        return http_tracker.reportDone()
    }
    
    
    @objc public func withResponseCode(tracker: Any, statusCode: NSNumber) {
        //may need to just move these to being tracked and stored as instance vars
        //so we just return a key/guid and skip serialization
        let http_tracker = tracker as! ADEumHTTPRequestTracker
        http_tracker.statusCode = statusCode
    }
    
    @objc public func withResponseContentLength(tracker: Any, responseContentLength: NSNumber) {
        //may need to just move these to being tracked and stored as instance vars
        //so we just return a key/guid and skip serialization
        let http_tracker = tracker as! ADEumHTTPRequestTracker
        let tmpHeaders = http_tracker.allHeaderFields as! NSMutableDictionary
        tmpHeaders.setValue(responseContentLength, forKeyPath: "Content-Length")
        http_tracker.allHeaderFields = tmpHeaders as? [AnyHashable : Any]
    }
    
    @objc public func withRequestContentLength(tracker: Any, requestContentLength: NSNumber) {
        //may need to just move these to being tracked and stored as instance vars
        //so we just return a key/guid and skip serialization
        let http_tracker = tracker as! ADEumHTTPRequestTracker
        let tmpHeaders = http_tracker.allRequestHeaderFields as! NSMutableDictionary
        tmpHeaders.setValue(requestContentLength, forKeyPath: "Content-Length")
        http_tracker.allRequestHeaderFields = tmpHeaders as? [AnyHashable : Any]
    }
    
    @objc public func withResponseHeaderFields(tracker: Any, responseHeaders: NSDictionary) {
        //may need to just move these to being tracked and stored as instance vars
        //so we just return a key/guid and skip serialization
        let http_tracker = tracker as! ADEumHTTPRequestTracker
        http_tracker.allHeaderFields = responseHeaders as? [AnyHashable : Any]
    }
    
    @objc public func withRequestHeaderFields(tracker: Any, requestHeaders: NSDictionary) {
        //may need to just move these to being tracked and stored as instance vars
        //so we just return a key/guid and skip serialization
        let http_tracker = tracker as! ADEumHTTPRequestTracker
        http_tracker.allRequestHeaderFields = requestHeaders as? [AnyHashable : Any]
    }
    
    @objc public func withInstrumentationSource(tracker: Any, informationSource: String) {
        //may need to just move these to being tracked and stored as instance vars
        //so we just return a key/guid and skip serialization
        let http_tracker = tracker as! ADEumHTTPRequestTracker
        http_tracker.instrumentationSource = informationSource
    }
    
    /*
     - (void)withInstrumentationSource:(CDVInvokedUrlCommand*)command {
         CDVPluginResult *result;
         @try {
             if ([command.arguments count] != 2) {
                 [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                 NSLog(@"Obj-C withInstrumentationSource called -- bad command");
             } else {
                 NSString *key = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
                 NSString *informationSource = [command argumentAtIndex:1 withDefault:nil andClass:[NSString class]];
                 NSLog(@"key:%@ withInstrumentationSource:%@", key, informationSource);

                 if ([key length] > 0) {
                     if (informationSource) {
                         ADEumHTTPRequestTracker *tracker = [self.keymap objectForKey:key];
                         tracker.instrumentationSource = informationSource;
                         result = [self finalizeSuccessfulResult:key];
                     } else {
                         result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"InformationSource missing or invalid"];
                     }
                 }
             }
         } @catch (NSException *exception) {
             result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
         }
         [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
     }
     */
}
