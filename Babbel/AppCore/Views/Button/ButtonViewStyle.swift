import UIKit

struct ButtonViewStyle {
    var backgroundColor: UIColor
    var titleFont: UIFont
    var titleColorNormal: UIColor
    var titleColorHighlighted: UIColor
    var contentInsets: UIEdgeInsets
    var borderWidth: Double
    var borderColor: UIColor
    var shadowColor: UIColor
    var shadowOffset: CGSize
    var shadowOpacity: Double
    var shadowRadius: Double
    
    static let `default` = ButtonViewStyle(
        backgroundColor: .systemBackground,
        titleFont: .systemFont(ofSize: UIFont.labelFontSize),
        titleColorNormal: .label,
        titleColorHighlighted: .gray,
        contentInsets: .zero,
        borderWidth: 0,
        borderColor: .label,
        shadowColor: .label,
        shadowOffset: CGSize(width: 0, height: -3),
        shadowOpacity: 0,
        shadowRadius: 3
    )
    
    func with(_ configure: (inout Self) -> ()) -> Self {
        var style = self
        configure(&style)
        return style
    }
}
