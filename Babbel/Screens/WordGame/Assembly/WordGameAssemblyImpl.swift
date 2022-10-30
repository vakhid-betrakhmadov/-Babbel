import UIKit

@MainActor
final class WordGameAssemblyImpl: WordGameAssembly {
    func assemble() -> (WordGameInterface, UIViewController) {
        let viewController = WordGameViewController()
        
        let interactor = WordGameInteractorImpl(
            wordPairsRrovider: FileSystemWordPairsRrovider(wordlistFileInfo: .engSpa),
            wordPairAnswersGenerator: WordPairAnswersGeneratorImpl()
        )
        
        let presenter = WordGamePresenter(
            view: viewController,
            interactor: interactor
        )
        
        viewController.add(disposable: presenter)
        
        return (presenter, viewController)
    }
}
