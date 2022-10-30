import UIKit

struct LabelViewStyle {
    var backgroundColor: UIColor
    var font: UIFont
    var textColor: UIColor
    var textAlignment: NSTextAlignment
    var numberOfLines: Int
    
    static let `default` = LabelViewStyle(
        backgroundColor: .systemBackground,
        font: .systemFont(ofSize: UIFont.labelFontSize),
        textColor: .label,
        textAlignment: .natural,
        numberOfLines: 1
    )
    
    func with(_ configure: (inout Self) -> ()) -> Self {
        var style = self
        configure(&style)
        return style
    }
}
