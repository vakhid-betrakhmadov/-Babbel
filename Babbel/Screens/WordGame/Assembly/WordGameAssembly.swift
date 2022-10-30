import UIKit

@MainActor
protocol WordGameAssembly {
    func assemble() -> (WordGameInterface, UIViewController)
}
