import Foundation

actor FileSystemWordPairsRrovider: WordPairsRrovider {
    struct Error: LocalizedError {
        let errorDescription: String?
    }
    
    init(wordlistFileInfo: WordlistFileInfo) {
        self.wordlistFileInfo = wordlistFileInfo
    }
    
    private let wordlistFileInfo: WordlistFileInfo
    private var loadWordPairsFromFileTask: Task<[WordPair], Swift.Error>?
    
    func wordPairs() async throws -> [WordPair] {
        if let loadWordPairsFromFileTask {
            return try await loadWordPairsFromFileTask.value
        }
        
        let task = Task<[WordPair], Swift.Error> {
            defer { loadWordPairsFromFileTask = nil }
            return try self.loadWordPairsFromFile()
        }
        
        loadWordPairsFromFileTask = task
        
        return try await task.value
    }
    
    private func loadWordPairsFromFile() throws -> [WordPair] {
        guard let wordPairsData = FileManager.default.contents(atPath: wordlistFileInfo.filePath)
        else { throw Error(errorDescription: "Failed to return contents of the file at \(wordlistFileInfo.filePath)") }
        
        let rawWordPairs = try JSONDecoder().decode(
            [[String:String]].self,
            from: wordPairsData
        )
        
        let wordPairs = try rawWordPairs.map { rawWordPair in
            guard let word = rawWordPair[wordlistFileInfo.wordPairCodingKeys.word],
                  let wordTranslation = rawWordPair[wordlistFileInfo.wordPairCodingKeys.wordTranslation]
            else { throw Error(errorDescription: "") }
            
            return WordPair(
                word: word,
                wordTranslation: wordTranslation
            )
        }
        
        return wordPairs
    }
}
