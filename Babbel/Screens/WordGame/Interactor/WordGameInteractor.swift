protocol WordGameInteractor: Actor {
    var attemptDurationSeconds: Double { get }
    var isGameOver: Bool { get }
    var correctAttemptsCount: Int { get }
    var wrongAttemptsCount: Int { get }
    
    func startGame()
    func nextWordPair() async throws -> WordPair
    @discardableResult
    func submitWordPairAnswer(_: WordPairAnswer) -> Answer
    func subscribeToAttemptTimeoutEvent(_: @escaping () -> ())
    func subscribeToGameOverEvent(_: @escaping (WordGameResult) -> ())
}
