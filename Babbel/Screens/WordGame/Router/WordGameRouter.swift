@MainActor
protocol WordGameRouter {
    @discardableResult
    func displayDialog(_: Dialog) -> DialogInterface
}
