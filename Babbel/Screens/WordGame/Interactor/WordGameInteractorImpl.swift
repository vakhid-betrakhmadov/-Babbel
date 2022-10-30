import Foundation
import Combine

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
    private var attemptTimeoutEventTimer: AnyCancellable?
    private var onAttemptTimeoutEvent: (() -> ())?
    private var onGameEndEvent: (() -> ())?
    private let maxWrongAttempts = 3
    private let maxTotalAttempts = 15
    private let correctWordPairProbabilityIsOneIn = 4
    
    let attemptDurationSeconds: Double = 5
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
            correctWordPairProbabilityIsOneIn: correctWordPairProbabilityIsOneIn
        )
        
        wordPairAnswersIterator = wordPairAnswers.makeIterator()
        
        return try await nextWordPair()
    }
    
    @discardableResult
    func submitWordPairAnswer(_ wordPairAnswer: WordPairAnswer) -> Answer {
        restartAttemptTimeoutEventTimer()
        
        if wordPairAnswer == currentWordPairAnswer {
            incrementCorrectAttemptsCount()
            return .correct
        } else {
            incrementWrongAttemptsCount()
            return .wrong
        }
    }
    
    func subscribeToAttemptTimeoutEvent(_ closure: @escaping () -> ()) {
        onAttemptTimeoutEvent = closure
        restartAttemptTimeoutEventTimer()
    }
    
    func subscribeToGameEndEvent(_ closure: @escaping () -> ()) {
        onGameEndEvent = closure
    }
    
    private func restartAttemptTimeoutEventTimer() {
        attemptTimeoutEventTimer?.cancel()
        attemptTimeoutEventTimer = Timer
            .publish(every: attemptDurationSeconds, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.incrementWrongAttemptsCount()
                self.onAttemptTimeoutEvent?()
            }
    }
    
    private func incrementCorrectAttemptsCount() {
        correctAttemptsCount += 1
        checkGameEnd()
    }
    
    private func incrementWrongAttemptsCount() {
        wrongAttemptsCount += 1
        checkGameEnd()
    }
    
    private func checkGameEnd() {
        if wrongAttemptsCount >= maxWrongAttempts || (wrongAttemptsCount + correctAttemptsCount) >= maxTotalAttempts {
            onGameEndEvent?()
        }
    }
}
