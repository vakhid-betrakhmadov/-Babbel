import XCTest

@testable import Babbel

final class FileSystemWordPairsRroviderTests: XCTestCase {
    
    func testWordPairsFileIsParsedCorrectly() async throws {
        // GIVEN
        mockFileContentsProvider.onContents = { _ in
            """
            [
              {
                "test_eng":"primary school",
                "test_spa":"escuela primaria"
              },
              {
                "test_eng":"teacher",
                "test_spa":"profesor / profesora"
              },
            ]
            """.data(using: .utf8)
        }
        
        // WHEN
        let wordPairs = try await fileSystemWordPairsRrovider.wordPairs()
        
        // THEN
        XCTAssertEqual(
            wordPairs,
            [
                WordPair(word: "primary school", wordTranslation: "escuela primaria"),
                WordPair(word: "teacher", wordTranslation: "profesor / profesora")
            ]
        )
    }
    
    func testWordPairsFileIsLoadedExactlyOnce() async throws {
        // GIVEN
        var contentsCallCount = 0
        var contentsFilePath: String?
        
        mockFileContentsProvider.onContents = { filePath in
            contentsCallCount += 1
            contentsFilePath = filePath
            
            sleep(1)
            
            return "[]".data(using: .utf8)
        }
        
        // WHEN
        async let wordPairs1 = fileSystemWordPairsRrovider.wordPairs()
        async let wordPairs2 = fileSystemWordPairsRrovider.wordPairs()
        async let wordPairs3 = fileSystemWordPairsRrovider.wordPairs()
        
        _ = try await [wordPairs1, wordPairs2, wordPairs3]
        
        // THEN
        XCTAssertEqual(contentsCallCount, 1)
        XCTAssertEqual(contentsFilePath, wordlistFileInfo.filePath)
    }
    
    private var mockFileContentsProvider: MockFileContentsProvider!
    private var wordlistFileInfo: WordlistFileInfo!
    private var fileSystemWordPairsRrovider: FileSystemWordPairsRrovider!
    
    override func setUp() {
        super.setUp()
        
        mockFileContentsProvider = MockFileContentsProvider()
        
        wordlistFileInfo = WordlistFileInfo(
            filePath: "eng_spa_test",
            wordPairCodingKeys: WordPairCodingKeys(
                word: "test_eng",
                wordTranslation: "test_spa"
            )
        )
        
        fileSystemWordPairsRrovider = FileSystemWordPairsRrovider(
            wordlistFileInfo: wordlistFileInfo,
            fileManager: mockFileContentsProvider
        )
    }
    
    override func tearDown() {
        super.tearDown()
        
        mockFileContentsProvider = nil
        wordlistFileInfo = nil
        fileSystemWordPairsRrovider = nil
    }
}
