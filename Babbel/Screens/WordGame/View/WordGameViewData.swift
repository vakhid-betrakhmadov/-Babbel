import UIKit

struct WordGameViewData {
    let correctAttemptCounterText: String?
    let wrongAttemptCounterText: String?
    let correctAnswerButtonText: String?
    let wrongAnswerButtonText: String?
    let correctAnswerButtonAnimation: ButtonAnimation?
    let wrongAnswerButtonAnimation: ButtonAnimation?
    let onCorrectAnswerButtonTap: (() ->())?
    let onWrongAnswerButtonTap: (() ->())?
    let wordTranslationText: String?
    let wordText: String?
    
    struct ButtonAnimation {
        let backgroundColor: UIColor
        let durationSeconds: Double
    }
}
