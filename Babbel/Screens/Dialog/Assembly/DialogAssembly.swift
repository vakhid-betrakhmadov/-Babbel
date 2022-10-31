import UIKit

@MainActor
protocol DialogAssembly {
    func assemble(_: Dialog) -> (DialogInterface, UIViewController)
}
