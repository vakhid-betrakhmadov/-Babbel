import UIKit

@MainActor
final class DialogAssemblyImpl: DialogAssembly {
    func assemble(_ dialog: Dialog) -> (DialogInterface, UIViewController) {
        
        let alertContoller = UIAlertController(
            title: dialog.title,
            message: dialog.message,
            preferredStyle: .init(dialog.style)
        )
        
        for action in dialog.actions {
            alertContoller.addAction(UIAlertAction(
                title: action.title,
                style: .init(action.style),
                handler: { _ in
                    action.handler?(action)
                }
            ))
        }
        
        return (alertContoller, alertContoller)
    }
}
