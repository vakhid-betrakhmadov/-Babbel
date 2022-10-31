@MainActor
protocol WordGameInterface: AnyObject {
    var onFinish: (() -> ())? { get set }
}
