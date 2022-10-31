import XCTest

@testable import Babbel

final class WordPairAnswersGeneratorImplTests: XCTestCase {
        
    func testInfiniteWordPairAnswersIsNotEmptyForSingleElementWordPairsSet() {
        // GIVEN
        let wordPairs = [
            WordPair(
                word: "0_eng",
                wordTranslation: "0_spa"
            )
        ]
        
        // WHEN
        let wordPairAnswers = wordPairAnswersGeneratorImpl.infiniteWordPairAnswers(
            wordPairs: wordPairs,
            correctWordPairProbabilityIsOneIn: 4
        )
        
        // THEN
        let wordPairAnswersIterator = wordPairAnswers.makeIterator()
        XCTAssertNotNil(wordPairAnswersIterator.next())
    }
    
    func testInfiniteWordPairAnswersIsEmptyForEmptyWordPairsSet() {
        // GIVEN
        
        // WHEN
        let wordPairAnswers = wordPairAnswersGeneratorImpl.infiniteWordPairAnswers(
            wordPairs: [],
            correctWordPairProbabilityIsOneIn: 4
        )
        
        // THEN
        XCTAssertEqual(Array(wordPairAnswers).count, 0)
    }
    
    func testInfiniteWordPairAnswersHasCorrectWordPairProbabilityForSmallWordPairsSet() {
        parameterizedTestInfiniteWordPairAnswersHasRequestedCorrectWordPairProbability(wordPairsCount: 20)
    }
    
    func testInfiniteWordPairAnswersHasCorrectWordPairProbabilityForBigWordPairsSet() {
        parameterizedTestInfiniteWordPairAnswersHasRequestedCorrectWordPairProbability(wordPairsCount: 1000)
    }
    
    private var wordPairAnswersGeneratorImpl: WordPairAnswersGeneratorImpl!
    
    override func setUp() {
        super.setUp()
        
        wordPairAnswersGeneratorImpl = WordPairAnswersGeneratorImpl()
    }
    
    override func tearDown() {
        super.tearDown()
        
        wordPairAnswersGeneratorImpl = nil
    }
    
    private func parameterizedTestInfiniteWordPairAnswersHasRequestedCorrectWordPairProbability(wordPairsCount: Int) {
        // GIVEN
        let correctWordPairProbabilityIsOneIn = 4
        
        let wordPairs = (0..<wordPairsCount).map {
            WordPair(
                word: "\($0)_eng",
                wordTranslation: "\($0)_spa"
            )
        }
        
        // WHEN
        let wordPairAnswers = wordPairAnswersGeneratorImpl.infiniteWordPairAnswers(
            wordPairs: wordPairs,
            correctWordPairProbabilityIsOneIn: correctWordPairProbabilityIsOneIn
        )
        
        let finiteWordPairAnswers = Array(wordPairAnswers.prefix(1000))
        
        // THEN
        let total = finiteWordPairAnswers.count
        let correct = finiteWordPairAnswers.filter { $0.answer == .correct }.count
        let wrong = finiteWordPairAnswers.filter { $0.answer == .wrong }.count
        
        // THEN
        XCTAssertEqual(total, 1000)
        XCTAssertEqual(correct, 250)
        XCTAssertEqual(wrong, 750)
    }
}
