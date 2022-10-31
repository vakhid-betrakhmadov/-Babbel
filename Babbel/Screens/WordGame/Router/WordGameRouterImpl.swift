import UIKit

@MainActor
final class WordGameRouterImpl: WordGameRouter {
    
    init(
        viewController: UIViewController,
        dialogAssembly: DialogAssembly)
    {
        self.viewController = viewController
        self.dialogAssembly = dialogAssembly
    }
    
    private let viewController: UIViewController
    private let dialogAssembly: DialogAssembly
    
    @discardableResult
    func displayDialog(_ dialog: Dialog) -> DialogInterface {
        let (dialogInterface, dialogViewController) = dialogAssembly.assemble(dialog)
        
        viewController.present(
            dialogViewController,
            animated: true
        )
        
        return dialogInterface
    }
}
