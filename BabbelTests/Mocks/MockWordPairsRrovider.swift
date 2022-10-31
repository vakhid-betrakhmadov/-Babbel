@testable import Babbel

final class MockWordPairsRrovider: WordPairsRrovider {
    
    var onWordPairs: () async throws -> [WordPair] = { fatalError() }
    
    func wordPairs() async throws -> [WordPair] {
        try await onWordPairs()
    }
}
