import UIKit

@MainActor
final class WordGameAssemblyImpl: WordGameAssembly {
    func assemble() -> (WordGameInterface, UIViewController) {
        let viewController = WordGameViewController()
        
        let interactor = WordGameInteractorImpl(
            wordPairsRrovider: FileSystemWordPairsRrovider(wordlistFileInfo: .engSpa),
            wordPairAnswersGenerator: WordPairAnswersGeneratorImpl()
        )
        
        let router = WordGameRouterImpl(
            viewController: viewController,
            dialogAssembly: DialogAssemblyImpl()
        )
        
        let presenter = WordGamePresenter(
            view: viewController,
            interactor: interactor,
            router: router
        )
        
        viewController.add(disposable: presenter)
        
        return (presenter, viewController)
    }
}
