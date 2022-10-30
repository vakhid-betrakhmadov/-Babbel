import Foundation

struct WordlistFileInfo {
    let filePath: String
    let wordPairCodingKeys: WordPairCodingKeys
}

extension WordlistFileInfo {
    static let engSpa: WordlistFileInfo = WordlistFileInfo(
        filePath: Bundle.main.path(
            forResource: "eng_spa_wordlist",
            ofType: "json"
        ).assert() ?? "",
        wordPairCodingKeys: WordPairCodingKeys(
            word: "text_eng",
            wordTranslation: "text_spa"
        )
    )
}
