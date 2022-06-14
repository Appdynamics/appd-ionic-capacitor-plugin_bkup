import Foundation
import ADEUMInstrumentation

@objc public class ADEUMMobileCapacitorPlugin: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
