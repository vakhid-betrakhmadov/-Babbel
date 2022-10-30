import UIKit

@MainActor
final class LabelView: UILabel {
    init(
        frame: CGRect = .zero,
        style: LabelViewStyle = .default)
    {
        self.style = style
        super.init(frame: frame)
        
        applyStyle()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) var style: LabelViewStyle {
        didSet {
            applyStyle()
        }
    }
    private(set) var viewData: LabelViewData? {
        didSet {
            guard oldValue != viewData else { return }
            applyViewData()
        }
    }
    
    func setViewData(_ viewData: LabelViewData) {
        self.viewData = viewData
    }
    
    func setStyle(_ style: LabelViewStyle) {
        self.style = style
    }
    
    private func applyViewData() {
        text = viewData?.text
    }
    
    private func applyStyle() {
        backgroundColor = style.backgroundColor
        font = style.font
        textColor = style.textColor
        textAlignment = style.textAlignment
        numberOfLines = style.numberOfLines
    }
}
