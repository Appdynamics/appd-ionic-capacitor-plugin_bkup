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
            "call_tracker": implementation.beginCall(className: className!, methodName: methodName!, withArguments: withArguments) as String
        ])
        return
    }
    @objc func endCall(_ call: CAPPluginCall) {
        let tracker = call.getString("call_tracker")
        if tracker != nil {
            implementation.endCall(tracker_key: tracker!)
        }
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
        let tracker = call.getString("http_tracker")
        if tracker != nil {
            implementation.reportDone(tracker_key: tracker!)
        }
        call.resolve()
    }
    
    @objc func withResponseCode(_ call: CAPPluginCall) {
        let tracker = call.getString("http_tracker")
        let statusCode = NSNumber.init(nonretainedObject: call.getInt("status_code"))
        if tracker != nil {
            implementation.withResponseCode(tracker_key: tracker!, statusCode: statusCode)
        }
        call.resolve()
    }
    
    @objc func withResponseContentLength(_ call: CAPPluginCall) {
        let tracker = call.getString("http_tracker")
        let content_length = NSNumber.init(nonretainedObject: call.getInt("content_length"))
        if tracker != nil {
            implementation.withResponseContentLength(tracker_key: tracker!, responseContentLength: content_length)
        }
        call.resolve()
    }
    
    @objc func withRequestContentLength(_ call: CAPPluginCall) {
        let tracker = call.getString("http_tracker")
        let content_length = NSNumber.init(nonretainedObject: call.getInt("content_length"))
        if tracker != nil {
            implementation.withRequestContentLength(tracker_key: tracker!, requestContentLength: content_length)
        }
        call.resolve()
    }
    
    @objc func withResponseHeaderFields(_ call: CAPPluginCall) {
        let tracker = call.getString("http_tracker")
        let headers = call.dictionaryWithValues(forKeys: ["http_headers"]) as NSDictionary
        if tracker != nil {
            implementation.withResponseHeaderFields(tracker_key: tracker!, responseHeaders: headers)
        }
        call.resolve()
    }
    
    @objc func withRequestHeaderFields(_ call: CAPPluginCall) {
        let tracker = call.getString("http_tracker")
        let headers = call.dictionaryWithValues(forKeys: ["http_headers"]) as NSDictionary
        if tracker != nil {
            implementation.withRequestHeaderFields(tracker_key: tracker!, requestHeaders: headers)
        }
        call.resolve()
    }
    
    @objc func withInstrumentationSource(_ call: CAPPluginCall) {
        let tracker = call.getString("http_tracker")
        let source = call.getString("information_source") ?? ""
        if tracker != nil {
            implementation.withInstrumentationSource(tracker_key: tracker!, informationSource: source)
        }
        call.resolve()
    }
    
    @objc func withErrorMessage(_ call: CAPPluginCall) {
        let tracker = call.getString("http_tracker")
        let error_message = call.getString("error_message") ?? ""
        if tracker != nil {
            implementation.withErrorMessage(tracker_key: tracker!, errorMessage: error_message)
        }
        call.resolve()
    }
    
    @objc func getCorrelationHeaders(_ call: CAPPluginCall) {
        let headers = implementation.getCorrelationHeaders()
        call.resolve([
            "headers": headers //NSDictionary
        ])
        return
    }
    
    @objc func startNextSession(_ call: CAPPluginCall) {
        implementation.startNextSession()
        call.resolve()
    }
    
    @objc func unblockScreenshots(_ call: CAPPluginCall) {
        implementation.unblockScreenshots()
        call.resolve()
    }
    
    @objc func blockScreenshots(_ call: CAPPluginCall) {
        implementation.blockScreenshots()
        call.resolve()
    }
    
    @objc func screenshotsBlocked(_ call: CAPPluginCall) {
        let is_blocked = implementation.screenshotsBlocked()
        call.resolve([
            "screenshots_blocked": is_blocked
        ])
        return
    }
    
    @objc func startSessionFrame(_ call: CAPPluginCall) {
        let sessionFrameName = call.getString("session_frame_name") ?? nil
        if sessionFrameName == nil {
            //do nothing and return nothing
            call.resolve()
            return
        }
        let session = implementation.startSessionFrame(sessionFrameName: sessionFrameName!)
        call.resolve([
            "session_frame": session
        ])
        return
    }
    
    @objc func endSessionFrame(_ call: CAPPluginCall) {
        let tracker = call.getString("session_frame")
        if tracker != nil {
            implementation.endSessionFrame(session_key: tracker!)
        }
        call.resolve()
    }
    
    @objc func updateSessionFrameName(_ call: CAPPluginCall) {
        let sessionFrameName = call.getString("session_frame_name") ?? nil
        let tracker = call.getString("session_frame")
        if sessionFrameName == nil || tracker == nil{
            //do nothing and return nothing
            call.resolve()
            return
        }
        //if here we should have vals for both and can force unwrap
        implementation.updateSessionFrameName(session_key: tracker!, session_name: sessionFrameName!)
        call.resolve([
            "session_frame": tracker!
        ])
        return
        
    }
    
    @objc func getVersion(_ call: CAPPluginCall) {
        call.resolve([
            "version": implementation.getVersion()
        ])
        return
    }
    
    @objc func clear(_ call: CAPPluginCall) {
        implementation.clear()
        call.resolve()
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
        implementation.pluginInitialize(config: config)
    }
}
