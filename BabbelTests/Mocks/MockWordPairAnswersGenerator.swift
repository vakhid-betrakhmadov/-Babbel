@testable import Babbel

final class MockWordPairAnswersGenerator: WordPairAnswersGenerator {
    
    var onInfiniteWordPairAnswers: ([WordPair], Int) -> AnySequence<WordPairAnswer> = { _,_ in fatalError() }
    
    func infiniteWordPairAnswers(
        wordPairs: [WordPair],
        correctWordPairProbabilityIsOneIn: Int
    ) -> AnySequence<WordPairAnswer> {
        onInfiniteWordPairAnswers(wordPairs, correctWordPairProbabilityIsOneIn)
    }
    
}
