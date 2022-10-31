import UIKit

extension UIAlertController.Style {
    init(_ style: Dialog.Style) {
        switch style {
        case .alert:
            self = .alert
        case .actionSheet:
            self = .actionSheet
        }
    }
}
