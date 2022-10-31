import XCTest

@testable import Babbel

final class WordGameInteractorImplTests: XCTestCase {
        
    func testNextWordPairReturnsWordPairsInOrder() async throws {
        // GIVEN
        let wordPairs = try await mockWordPairsRrovider.wordPairs()
        
        // WHEN
        var returnedWordPairs: [WordPair] = []
        
        for _ in (0..<wordPairs.count) {
            returnedWordPairs.append(try await wordGameInteractorImpl.nextWordPair())
        }
        
        // THEN
        XCTAssertEqual(wordPairs, returnedWordPairs)
    }
    
    func testStartGameResetsAttemptsCount() async throws {
        // GIVEN
        let wordPairAnswers = Array(mockWordPairAnswersGenerator.infiniteWordPairAnswers(
            wordPairs: [],
            correctWordPairProbabilityIsOneIn: 0
        ))
        _ = try await wordGameInteractorImpl.nextWordPair()
        await wordGameInteractorImpl.submitWordPairAnswer(wordPairAnswers[0])
        await wordGameInteractorImpl.submitWordPairAnswer(wordPairAnswers[1])
        
        let correctAttemptsCountBefore = await wordGameInteractorImpl.correctAttemptsCount
        let wrongAttemptsCountBefore = await wordGameInteractorImpl.wrongAttemptsCount

        XCTAssertEqual(correctAttemptsCountBefore, 1)
        XCTAssertEqual(wrongAttemptsCountBefore, 1)
        
        // WHEN
        await wordGameInteractorImpl.startGame()
        
        // THEN
        let correctAttemptsCountAfter = await wordGameInteractorImpl.correctAttemptsCount
        let wrongAttemptsCountAfter = await wordGameInteractorImpl.wrongAttemptsCount

        XCTAssertEqual(correctAttemptsCountAfter, 0)
        XCTAssertEqual(wrongAttemptsCountAfter, 0)
    }
    
    func testStartGameResetsIsGameOver() async {
        // GIVEN
        let wrongWordPairAnswer = WordPairAnswer(
            wordPair: WordPair(word: "", wordTranslation: ""),
            answer: .correct
        )
        
        await wordGameInteractorImpl.submitWordPairAnswer(wrongWordPairAnswer)
        await wordGameInteractorImpl.submitWordPairAnswer(wrongWordPairAnswer)
        await wordGameInteractorImpl.submitWordPairAnswer(wrongWordPairAnswer)
        
        let isGameOverBefore = await wordGameInteractorImpl.isGameOver
        XCTAssertTrue(isGameOverBefore)
        
        // WHEN
        await wordGameInteractorImpl.startGame()
        
        // THEN
        let isGameOverAfter = await wordGameInteractorImpl.isGameOver
        XCTAssertFalse(isGameOverAfter)
    }
    
    // TODO:
    // - Mock timer
    // - Test that startGame triggers onAttemptTimeoutEvent after attempt timeout
    // - Test that submitWordPairAnswer increments correct / wrong attempts count
    // - Test that submitWordPairAnswer triggers onGameOverEvent after 3 wrong / 15 total attempts
    // - Test that submitWordPairAnswer resets attempt timeout

    private var wordGameInteractorImpl: WordGameInteractorImpl!
    private var mockWordPairsRrovider: MockWordPairsRrovider!
    private var mockWordPairAnswersGenerator: MockWordPairAnswersGenerator!
    
    override func setUp() {
        super.setUp()
        
        mockWordPairsRrovider = MockWordPairsRrovider()
        
        mockWordPairAnswersGenerator = MockWordPairAnswersGenerator()
        
        wordGameInteractorImpl = WordGameInteractorImpl(
            wordPairsRrovider: mockWordPairsRrovider,
            wordPairAnswersGenerator: mockWordPairAnswersGenerator
        )
        
        setupMocks()
    }
    
    override func tearDown() {
        super.tearDown()
        
        mockWordPairsRrovider = nil
        mockWordPairAnswersGenerator = nil
        wordGameInteractorImpl = nil
    }
    
    
    private func setupMocks() {
        let wordPairs = (0..<10).map {
            WordPair(
                word: "\($0)_eng",
                wordTranslation: "\($0)_spa"
            )
        }
        
        mockWordPairsRrovider.onWordPairs = { wordPairs }
        
        mockWordPairAnswersGenerator.onInfiniteWordPairAnswers = { _, _ in
            AnySequence(wordPairs.map {
                WordPairAnswer(
                    wordPair: $0,
                    answer: Bool.random() ? .correct : .wrong
                )
            })
        }
    }
}
