import UIKit

@MainActor
final class WordGamePresenter: WordGameInterface {
    init(
        view: AnyObject & WordGameViewInterface,
        interactor: WordGameInteractor,
        router: WordGameRouter)
    {
        self.view = view
        self.interactor = interactor
        self.router = router
        
        setup()
    }
    
    private weak var view: (AnyObject & WordGameViewInterface)?
    private let interactor: WordGameInteractor
    private let router: WordGameRouter
    private let buttonAnimationDurationSeconds = 0.1
    var onFinish: (() -> ())?
    
    private func setup() {
        setupView()
        setupInteractor()
    }
    
    private func setupView() {
        view?.onViewDidLoad = { [weak self] in
            self?.startGame()
        }
    }
    
    private func setupInteractor() {
        Task {
            await interactor.subscribeToAttemptTimeoutEvent { [weak self] in
                self?.updateView()
            }
            
            await interactor.subscribeToGameOverEvent { [weak self] gameResult in
                self?.displayDialog(gameResult: gameResult)
            }
        }
    }
    
    private func startGame() {
        Task {
            await interactor.startGame()
            updateView()
        }
    }
    
    private func displayDialog(gameResult: WordGameResult) {
        Task {
            _ = router.displayDialog(Dialog(
                title: "GAME OVER",
                message: """
                    Correct attempts: \(gameResult.correctAttemptsCount)
                    Wrong attempts: \(gameResult.wrongAttemptsCount)
                """,
                style: .alert,
                actions: [
                    .init(
                        title: "Restart",
                        style: .default,
                        handler: { [weak self] _ in
                            self?.startGame()
                        }
                    ),
                    .init(
                        title: "Quit",
                        style: .destructive,
                        handler: { [weak self] _ in
                            self?.finish()
                        }
                    ),
                ]
            ))
        }
    }
    
    private func finish() {
        Task {
            onFinish?()
        }
    }
    
    private func updateView(
        correctAnswerButtonAnimation: WordGameViewData.ButtonAnimation? = nil,
        wrongAnswerButtonAnimation: WordGameViewData.ButtonAnimation? = nil)
    {
        Task {
            let viewData = try await viewData(
                correctAnswerButtonAnimation: correctAnswerButtonAnimation,
                wrongAnswerButtonAnimation: wrongAnswerButtonAnimation
            )
            view?.setViewData(viewData)
        }
    }
    
    private func viewData(
        correctAnswerButtonAnimation: WordGameViewData.ButtonAnimation? = nil,
        wrongAnswerButtonAnimation: WordGameViewData.ButtonAnimation? = nil
    ) async throws -> WordGameViewData {
        let wordPair = try await interactor.nextWordPair()
        
        return await WordGameViewData(
            correctAttemptCounterText: "Correct attempts: \(interactor.correctAttemptsCount)",
            wrongAttemptCounterText: "Wrong attempts: \(interactor.wrongAttemptsCount)",
            correctAnswerButtonText: "Correct",
            wrongAnswerButtonText: "Wrong",
            correctAnswerButtonAnimation: correctAnswerButtonAnimation,
            wrongAnswerButtonAnimation: wrongAnswerButtonAnimation,
            onCorrectAnswerButtonTap: { [weak self] in
                guard let self else { return }
                
                Task {
                    let actualAnswer = await self.interactor.submitWordPairAnswer(WordPairAnswer(
                        wordPair: wordPair,
                        answer: .correct
                    ))
                    self.updateView(correctAnswerButtonAnimation: self.answerButtonAnimation(answer: actualAnswer))
                }
            },
            onWrongAnswerButtonTap: { [weak self] in
                guard let self else { return }
                
                Task {
                    let actualAnswer = await self.interactor.submitWordPairAnswer(WordPairAnswer(
                        wordPair: wordPair,
                        answer: .wrong
                    ))
                    self.updateView(wrongAnswerButtonAnimation: self.answerButtonAnimation(answer: actualAnswer))
                }
            },
            wordTranslationText: wordPair.wordTranslation,
            wordText: wordPair.word,
            wordTranslationAnimation: interactor.isGameOver ? nil : .init(durationSeconds: interactor.attemptDurationSeconds)
        )
    }
    
    private func answerButtonAnimation(answer: Answer) -> WordGameViewData.ButtonAnimation {
        let backgroundColor: UIColor
        
        switch answer {
        case .wrong:
            backgroundColor = UIColor.systemRed
        case .correct:
            backgroundColor = UIColor.systemGreen
        }
        
        return .init(
            backgroundColor: backgroundColor,
            durationSeconds: buttonAnimationDurationSeconds
        )
    }
}
