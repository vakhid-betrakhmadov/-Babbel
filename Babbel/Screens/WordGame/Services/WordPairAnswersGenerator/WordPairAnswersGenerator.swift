protocol WordPairAnswersGenerator {
    func infiniteWordPairAnswers(
        wordPairs: [WordPair],
        correctWordPairProbabilityIsOneIn: Int
    ) -> AnySequence<WordPairAnswer>
}
