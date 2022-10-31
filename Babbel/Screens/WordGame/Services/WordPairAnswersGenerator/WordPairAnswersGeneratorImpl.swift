final class WordPairAnswersGeneratorImpl: WordPairAnswersGenerator {
    func infiniteWordPairAnswers(
        wordPairs: [WordPair],
        correctWordPairProbabilityIsOneIn total: Int
    ) -> AnySequence<WordPairAnswer> {
        let wordPairAnswersSequence = (0...)
            .lazy
            .map { _ in
                wordPairs
                    .shuffled()
                    .enumerated()
                    .compactMap { index, wordPair in
                        let isIndexDivisibleByTotal = index % total == 0
                        
                        if isIndexDivisibleByTotal {
                            return WordPairAnswer(
                                wordPair: wordPair,
                                answer: .correct
                            )
                        } else {
                            while let randomWordPair = wordPairs.randomElement() {
                                guard randomWordPair != wordPair else { continue }
                                return WordPairAnswer(
                                    wordPair: WordPair(
                                        word: wordPair.word,
                                        wordTranslation: randomWordPair.wordTranslation
                                    ),
                                    answer: .wrong
                                )
                            }
                            
                            return nil
                        }
                    }
            }
        
        var wordPairAnswersSequenceIterator = wordPairAnswersSequence.makeIterator()
        var wordPairAnswersIterator = wordPairAnswersSequenceIterator.next()?.shuffled().makeIterator()
        
        guard let firstWordPairAnswer = wordPairAnswersIterator?.next()
        else { return AnySequence([]) }
        
        return AnySequence(sequence(
            first: firstWordPairAnswer,
            next: { _ in
                if let next = wordPairAnswersIterator?.next() {
                    return next
                } else {
                    wordPairAnswersIterator = wordPairAnswersSequenceIterator.next()?.shuffled().makeIterator()
                    return wordPairAnswersIterator?.next()
                }
            }
        ))
    }
}
