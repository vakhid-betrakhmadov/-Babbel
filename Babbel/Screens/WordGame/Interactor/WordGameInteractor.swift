protocol WordGameInteractor: Actor {
    var correctAttemptsCount: Int { get }
    var wrongAttemptsCount: Int { get }
    
    func nextWordPair() async throws -> WordPair
    @discardableResult
    func submitWordPairAnswer(_: WordPairAnswer) -> Answer
}
