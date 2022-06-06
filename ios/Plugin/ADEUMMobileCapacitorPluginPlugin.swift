import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(ADEUMMobileCapacitorPluginPlugin)
public class ADEUMMobileCapacitorPluginPlugin: CAPPlugin {
    private let implementation = ADEUMMobileCapacitorPlugin()

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }
}
