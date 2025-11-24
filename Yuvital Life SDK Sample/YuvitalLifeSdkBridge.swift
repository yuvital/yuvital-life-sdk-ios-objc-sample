import Foundation
import YuvitalLifeSDK
import ReactBrownfield

@objc final class YuvitalLifeSdkBridge: NSObject {

    @objc static func configure() {
        ReactNativeBrownfield.shared.bundle = ReactNativeBundle
        ReactNativeBrownfield.shared.startReactNative()
    }

    @objc static func makeYuvitalSdkViewController() -> UIViewController {
        let rnVC = ReactNativeViewController(
            moduleName: "YuvitalLifeNativeSdk",
            initialProperties: nil
        )
        let sdkWrapper = YuvitalLifeSdkViewController(embeddedViewController: rnVC)
        return sdkWrapper
    }
}
