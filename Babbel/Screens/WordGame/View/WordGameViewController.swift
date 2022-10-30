import UIKit

@MainActor
final class WordGameViewController:
    UIViewController,
    WordGameViewInterface,
    DisposeBagHolding,
    DisposeBag
{
    init(disposeBag: DisposeBag = DefaultDisposeBag()) {
        self.disposeBag = disposeBag
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let disposeBag: DisposeBag
    var onViewDidLoad: (() -> ())?
    private lazy var wordGameView = WordGameView()
    
    override func loadView() {
        view = wordGameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad?()
    }
    
    func setViewData(_ viewData: WordGameViewData) {
        wordGameView.setViewData(viewData)
    }
}
