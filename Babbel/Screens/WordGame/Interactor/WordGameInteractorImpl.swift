import Foundation

actor WordGameInteractorImpl: WordGameInteractor {
    struct Error: LocalizedError {
        let errorDescription: String?
    }
    
    init(
        wordPairsRrovider: WordPairsRrovider,
        wordPairAnswersGenerator: WordPairAnswersGenerator)
    {
        self.wordPairsRrovider = wordPairsRrovider
        self.wordPairAnswersGenerator = wordPairAnswersGenerator
    }
    
    private let wordPairsRrovider: WordPairsRrovider
    private let wordPairAnswersGenerator: WordPairAnswersGenerator
    private var currentWordPairAnswer: WordPairAnswer?
    private var wordPairAnswersIterator: AnyIterator<WordPairAnswer>?
    private(set) var correctAttemptsCount = 0
    private(set) var wrongAttemptsCount = 0
    
    func nextWordPair() async throws -> WordPair {
        if let wordPairAnswersIterator {
            guard let wordPairAnswer = wordPairAnswersIterator.next()
            else { throw Error(errorDescription: "Failed to get next word pair") }
            
            currentWordPairAnswer = wordPairAnswer
            
            return wordPairAnswer.wordPair
        }
        
        let wordPairs = try await wordPairsRrovider.wordPairs()
        
        let wordPairAnswers = wordPairAnswersGenerator.generateWordPairAnswers(
            wordPairs: wordPairs,
            correctWordPairProbabilityIsOneIn: 4
        )
        
        wordPairAnswersIterator = wordPairAnswers.makeIterator()
        
        return try await nextWordPair()
    }
    
    @discardableResult
    func submitWordPairAnswer(_ wordPairAnswer: WordPairAnswer) -> Answer {
        if wordPairAnswer == currentWordPairAnswer {
            correctAttemptsCount += 1
            return .correct
        } else {
            wrongAttemptsCount += 1
            return .wrong
        }
    }
}
