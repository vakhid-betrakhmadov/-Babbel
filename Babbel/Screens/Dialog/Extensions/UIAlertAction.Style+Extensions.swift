import UIKit

extension UIAlertAction.Style {
    init(_ style: Dialog.Action.Style) {
        switch style {
        case .default:
            self = .default
        case .cancel:
            self = .cancel
        case .destructive:
            self = .destructive
        }
    }
}
