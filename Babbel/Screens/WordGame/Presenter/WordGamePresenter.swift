import UIKit

@MainActor
final class WordGamePresenter: WordGameInterface {
    init(
        view: AnyObject & WordGameViewInterface,
        interactor: WordGameInteractor)
    {
        self.view = view
        self.interactor = interactor
        
        setup()
    }
    
    private weak var view: (AnyObject & WordGameViewInterface)?
    private let interactor: WordGameInteractor
    private let buttonAnimationDurationSeconds = 0.1
    var onFinish: (() -> ())?
    
    private func setup() {
        setupView()
        setupInteractor()
    }
    
    private func setupView() {
        view?.onViewDidLoad = { [weak self] in
            self?.updateView()
        }
    }
    
    private func setupInteractor() {
        Task {
            await interactor.subscribeToAttemptTimeoutEvent { [weak self] in
                self?.updateView()
            }
            
            await interactor.subscribeToGameEndEvent { [weak self] in
                self?.finish()
            }
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
            wordText: wordPair.word
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
