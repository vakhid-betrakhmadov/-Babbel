@MainActor
protocol WordGameViewInterface {
    var onViewDidLoad: (() -> ())? { get set }
    func setViewData(_ viewData: WordGameViewData)
}
