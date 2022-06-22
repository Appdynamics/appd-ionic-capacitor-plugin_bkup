import Foundation
import Capacitor
import ADEUMInstrumentation



/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(ADEUMMobileCapacitorPluginPlugin)
public class ADEUMMobileCapacitorPluginPlugin: CAPPlugin {
    private let implementation = ADEUMMobileCapacitorPlugin()
    private var config = ADEumAgentConfiguration()
    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }
    @objc func startTimer(_ call: CAPPluginCall) {
        let name = call.getString("name") ?? "generic_timer"
        implementation.startTimerWithName(name: name)
        call.resolve()
    }
    @objc func stopTimer(_ call: CAPPluginCall) {
        let name = call.getString("name") ?? "generic_timer"
        implementation.stopTimerWithName(name: name)
        call.resolve()
    }
    @objc func reportMetricWithName(_ call: CAPPluginCall) {
        let name = call.getString("name") ?? "generic_metric"
        let value = Int64(call.getInt("value", 0))
        implementation.reportMetricWithName(name: name, value: value)
        call.resolve()
    }
    @objc func leaveBreadcrumb(_ call: CAPPluginCall) {
        let name = call.getString("name") ?? nil //will not record nil or empty string
        implementation.leaveBreadcrumb(name: name)
        call.resolve()
    }
    @objc func setUserData(_ call: CAPPluginCall) {
        let key = call.getString("key") ?? nil
        let value = call.getString("value") ?? ""
        //ignore if key is nil
        if key == nil {
            call.resolve()
            return
        }
        
        implementation.setUserData(key: key!, value: value)
        call.resolve()
    }
    @objc func removeUserData(_ call: CAPPluginCall) {
        let key = call.getString("key") ?? nil
        //ignore if key is nil
        if key == nil {
            call.resolve()
            return
        }
        
        implementation.removeUserData(key: key!)
        call.resolve()
    }
    @objc func takeScreenShot(_ call: CAPPluginCall) {
        implementation.takeScreenshot()
        call.resolve()
    }
    @objc func beginCall(_ call: CAPPluginCall) {
        let className = call.getString("className") ?? nil
        let methodName = call.getString("methodName") ?? nil
        let withArguments = call.getArray("withArguments", [])
        
        if className == nil || methodName == nil {
            //do nothing and return nothing
            call.resolve()
            return
        }
        call.resolve([
            "call_tracker": implementation.beginCall(className: className!, methodName: methodName!, withArguments: withArguments) as Any
        ])
        return
    }
    @objc func endCall(_ call: CAPPluginCall) {
        let tracker = call.getObject("call_tracker") as Any
        implementation.endCall(tracker: tracker)
        call.resolve()
    }
    @objc func beginHttpRequest(_ call: CAPPluginCall) {
        let url_string = call.getString("url") ?? nil
        if url_string == nil {
            //do nothing and return nothing
            call.resolve()
            return
        }
        let url = URL.init(string:url_string!)
        let http_tracker = implementation.beginHttpRequest(url: url!)
        call.resolve([
            "http_tracker": http_tracker
        ])
        return
    }
    @objc func reportDone(_ call: CAPPluginCall) {
        let http_tracker = call.getObject("http_tracker") as Any
        implementation.reportDone(tracker: http_tracker)
        call.resolve()
    }
    
    @objc func withResponseCode(_ call: CAPPluginCall) {
        let http_tracker = call.getObject("http_tracker") as Any
        let statusCode = NSNumber.init(nonretainedObject: call.getInt("status_code"))
        implementation.withResponseCode(tracker: http_tracker, statusCode: statusCode)
        call.resolve()
    }
    
    @objc func withResponseContentLength(_ call: CAPPluginCall) {
        let http_tracker = call.getObject("http_tracker") as Any
        let content_length = NSNumber.init(nonretainedObject: call.getInt("content_length"))
        implementation.withResponseContentLength(tracker: http_tracker, responseContentLength: content_length)
        call.resolve()
    }
    
    @objc func withRequestContentLength(_ call: CAPPluginCall) {
        let http_tracker = call.getObject("http_tracker") as Any
        let content_length = NSNumber.init(nonretainedObject: call.getInt("content_length"))
        implementation.withRequestContentLength(tracker: http_tracker, requestContentLength: content_length)
        call.resolve()
    }
    
    @objc func withResponseHeaderFields(_ call: CAPPluginCall) {
        let http_tracker = call.getObject("http_tracker") as Any
        let headers = call.getObject("http_headers")! as NSDictionary
        implementation.withResponseHeaderFields(tracker: http_tracker, responseHeaders: headers)
        call.resolve()
    }
    
    @objc func withRequestHeaderFields(_ call: CAPPluginCall) {
        let http_tracker = call.getObject("http_tracker") as Any
        let headers = call.getObject("http_headers")! as NSDictionary
        implementation.withRequestHeaderFields(tracker: http_tracker, requestHeaders: headers)
        call.resolve()
    }
    
    @objc func withInstrumentationSource(_ call: CAPPluginCall) {
        let http_tracker = call.getObject("http_tracker") as Any
        let source = call.getString("information_source") ?? ""
        implementation.withInstrumentationSource(tracker: http_tracker, informationSource: source)
        call.resolve()
    }
    
    @objc func getCorrelationHeaders(_ call: CAPPluginCall) {
        let headers = implementation.getCorrelationHeaders()
        call.resolve([
            "headers": headers
        ])
        return
    }
    override public func load() {
        if let appKey = getConfigValue("ADEUM_APP_KEY") as? String{
            config.appKey = appKey
        }
        if let collectorUrl = getConfigValue("ADEUM_COLLECTOR_URL") as? String{
            config.collectorURL = collectorUrl
        }
        if let screenshotUrl = getConfigValue("ADEUM_SCREENSHOT_URL") as? String{
            config.screenshotURL = screenshotUrl
        }
        if let screenshotEnabled = getConfigValue("ADEUM_SCREENSHOTS_ENABLED") as? Bool{
            config.screenshotsEnabled = screenshotEnabled
        }
        if let loggingLevel = getConfigValue("ADEUM_LOGGING_LEVEL") as? UInt{
            config.loggingLevel = ADEumLoggingLevel(rawValue: loggingLevel) ?? ADEUMInstrumentation.ADEumLoggingLevel.error
        }
        if let reachabilityHost = getConfigValue("ADEUM_REACHABILITY_HOST") as? String{
            config.reachabilityHostName = reachabilityHost
        }
        if let captureMode = getConfigValue("ADEUM_INTERACTION_CAPTURE_MODE") as? UInt{
            //let d = ADEumInteractionCaptureMode.ADEumInteractionCaptureModeNone
            config.interactionCaptureMode = ADEumInteractionCaptureMode.init(rawValue: captureMode)
        }
        implementation.pluginInitialize(config: <#T##ADEumAgentConfiguration#>)
    }
}
