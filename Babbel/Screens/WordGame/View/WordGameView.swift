import UIKit

@MainActor
final class WordGameView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let attemptCountersStackView = UIStackView()
    private let correctAttemptCounterLabel = LabelView(style: .attemptCounter)
    private let wrongAttemptCounterLabel = LabelView(style: .attemptCounter)
    private let buttonsStackView = UIStackView()
    private let correctAnswerButton = ButtonView(style: .answer)
    private let wrongAnswerButton = ButtonView(style: .answer)
    private let wordsStackView = UIStackView()
    private let wordTranslationLabel = LabelView(style: .wordTranslation)
    private let wordTranslationAnimationLabel = LabelView(style: .wordTranslation)
    private let wordLabel = LabelView(style: .word)
    private var additionalLayoutMargins: UIEdgeInsets {
        .init(
            top: 0,
            left: 0,
            bottom: safeAreaInsets.bottom == 0 ? 16 : 0,
            right: 0
        )
    }
    private var wordTranslationAnimator: UIViewPropertyAnimator?
    
    override var layoutMargins: UIEdgeInsets {
        get { super.layoutMargins + additionalLayoutMargins }
        set { super.layoutMargins = newValue }
    }
    
    func setViewData(_ viewData: WordGameViewData) {
        correctAttemptCounterLabel.setViewData(
            LabelViewData(text: viewData.correctAttemptCounterText)
        )
        wrongAttemptCounterLabel.setViewData(
            LabelViewData(text: viewData.wrongAttemptCounterText)
        )
        correctAnswerButton.setViewData(ButtonViewData(
            title: viewData.correctAnswerButtonText,
            onTap: viewData.onCorrectAnswerButtonTap)
        )
        wrongAnswerButton.setViewData(ButtonViewData(
            title: viewData.wrongAnswerButtonText,
            onTap: viewData.onWrongAnswerButtonTap)
        )
        wordTranslationLabel.setViewData(
            LabelViewData(text: viewData.wordTranslationText)
        )
        wordLabel.setViewData(
            LabelViewData(text: viewData.wordText)
        )
        
        animateButtonIfNeeded(
            correctAnswerButton,
            buttonAnimation: viewData.correctAnswerButtonAnimation
        )
        
        animateButtonIfNeeded(
            wrongAnswerButton,
            buttonAnimation: viewData.wrongAnswerButtonAnimation
        )
        
        animateWordTranslationIfNeeded(viewData: viewData)
    }
    
    private func animateWordTranslationIfNeeded(viewData: WordGameViewData) {
        wordTranslationAnimator?.stopAnimation(false)
        wordTranslationAnimator?.finishAnimation(at: .end)
        
        guard let wordTranslationAnimation = viewData.wordTranslationAnimation
        else { return }
        
        layoutIfNeeded()
        
        let wordTranslationAnimationLabelEndFrame = wordTranslationLabel.convert(
            self.wordTranslationLabel.frame,
            to: self
        )
        
        let wordTranslationAnimationLabelStartFrame = CGRect(
            x: wordTranslationAnimationLabelEndFrame.minX,
            y: -wordTranslationAnimationLabelEndFrame.height,
            width: wordTranslationAnimationLabelEndFrame.width,
            height: wordTranslationAnimationLabelEndFrame.height
        )
        
        wordTranslationAnimationLabel.setViewData(LabelViewData(text: viewData.wordTranslationText))
        wordTranslationAnimationLabel.frame = wordTranslationAnimationLabelStartFrame
        wordTranslationLabel.alpha = 0
        
        wordTranslationAnimator = UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: wordTranslationAnimation.durationSeconds,
            delay: 0,
            options: [.curveEaseOut],
            animations: { [weak self] in
                guard let self else { return }
                self.wordTranslationAnimationLabel.frame = wordTranslationAnimationLabelEndFrame
            },
            completion: { [weak self] _ in
                guard let self else { return }
                self.wordTranslationLabel.alpha = 1
                self.wordTranslationAnimationLabel.frame = wordTranslationAnimationLabelStartFrame
            }
        )
    }
    
    private func animateButtonIfNeeded(
        _ button: ButtonView,
        buttonAnimation: WordGameViewData.ButtonAnimation?)
    {
        guard let buttonAnimation else { return }
        
        let oldButtonStyle = button.style
        button.setStyle(oldButtonStyle.with {
            $0.backgroundColor = buttonAnimation.backgroundColor
        })
        Task {
            try await Task.sleep(nanoseconds: UInt64(Double(NSEC_PER_SEC) * buttonAnimation.durationSeconds))
            button.setStyle(oldButtonStyle)
        }
    }
    
    private func setup() {
        backgroundColor = .systemBackground
        
        addSubview(wordTranslationAnimationLabel)
        wordTranslationAnimationLabel.backgroundColor = .clear
        
        attemptCountersStackView.axis = .vertical
        attemptCountersStackView.spacing = 4
        [
            correctAttemptCounterLabel,
            wrongAttemptCounterLabel,
        ].forEach { attemptCountersStackView.addArrangedSubview($0) }
        
        addSubview(attemptCountersStackView)
        attemptCountersStackView.translatesAutoresizingMaskIntoConstraints = false
        [
            attemptCountersStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            attemptCountersStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
        ].forEach { $0.isActive.toggle() }
        
        buttonsStackView.spacing = 16
        [
            correctAnswerButton,
            wrongAnswerButton,
        ].forEach { buttonsStackView.addArrangedSubview($0) }
        
        addSubview(buttonsStackView)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        [
            buttonsStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            buttonsStackView.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
        ].forEach { $0.isActive.toggle() }
        
        wordsStackView.axis = .vertical
        wordsStackView.spacing = 40
        [
            wordTranslationLabel,
            wordLabel
        ].forEach { wordsStackView.addArrangedSubview($0) }
        
        addSubview(wordsStackView)
        wordsStackView.translatesAutoresizingMaskIntoConstraints = false
        [
            wordsStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            wordsStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            wordsStackView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor),
        ].forEach { $0.isActive.toggle() }
    }
}

private extension LabelViewStyle {
    static let attemptCounter: Self = {
        var style = Self.default
        style.font = .chalkboardBold.withSize(14)
        style.textAlignment = .right
        return style
    }()
    
    static let wordTranslation: Self = {
        var style = Self.default
        style.font = .chalkboardBold.withSize(24)
        style.textAlignment = .center
        style.numberOfLines = 0
        return style
    }()
    
    static let word: Self = {
        var style = Self.wordTranslation
        style.font = .chalkboardBold.withSize(17)
        return style
    }()
}

private extension ButtonViewStyle {
    static let answer: Self = {
        var style = Self.default
        style.titleFont = .chalkboardBold.withSize(24)
        style.contentInsets = .init(top: 8, left: 32, bottom: 8, right: 32)
        style.borderWidth = 2
        style.shadowOffset = .init(width: 2, height: 2)
        style.shadowOpacity = 1
        style.shadowRadius = 0
        return style
    }()
}
