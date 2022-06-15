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
            call.resolve([
                "call_tracker": nil
            ])
            return
        }
        call.resolve([
            "call_tracker": implementation.beginCall(className: className!, methodName: methodName!, withArguments: withArguments) as Any
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
