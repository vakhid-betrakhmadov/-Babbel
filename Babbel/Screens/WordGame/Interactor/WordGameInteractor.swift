protocol WordGameInteractor: Actor {
    var attemptDurationSeconds: Double { get }
    var correctAttemptsCount: Int { get }
    var wrongAttemptsCount: Int { get }
    
    func nextWordPair() async throws -> WordPair
    @discardableResult
    func submitWordPairAnswer(_: WordPairAnswer) -> Answer
    func subscribeToAttemptTimeoutEvent(_: @escaping () -> ())
    func subscribeToGameEndEvent(_: @escaping () -> ())
}
