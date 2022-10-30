import UIKit

extension UIFont {
    static let chalkboardBold = UIFont(
        name: "ChalkboardSE-Bold",
        size: UIFont.labelFontSize
    ).assert() ?? UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
}
