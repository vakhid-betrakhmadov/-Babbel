protocol WordPairAnswersGenerator {
    func generateWordPairAnswers(
        wordPairs: [WordPair],
        correctWordPairProbabilityIsOneIn: Int
    ) -> AnySequence<WordPairAnswer>
}
