import UIKit

@MainActor
final class ButtonView: UIButton {
    init(
        frame: CGRect = .zero,
        style: ButtonViewStyle = .default)
    {
        self.style = style
        super.init(frame: frame)
        
        setup()
        applyStyle()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) var style: ButtonViewStyle {
        didSet {
            applyStyle()
        }
    }
    private(set) var viewData: ButtonViewData? {
        didSet {
            applyViewData()
        }
    }
    
    func setViewData(_ viewData: ButtonViewData) {
        self.viewData = viewData
    }
    
    func setStyle(_ style: ButtonViewStyle) {
        self.style = style
    }
    
    private func setup() {
        addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }
    
    private func applyViewData() {
        setTitle(viewData?.title, for: .normal)
    }
    
    private func applyStyle() {
        backgroundColor = style.backgroundColor
        titleLabel?.font = style.titleFont
        setTitleColor(style.titleColorNormal, for: .normal)
        setTitleColor(style.titleColorHighlighted, for: .highlighted)
        contentEdgeInsets = style.contentInsets
        layer.borderWidth = style.borderWidth
        layer.borderColor = style.borderColor.cgColor
        layer.shadowColor = style.borderColor.cgColor
        layer.shadowOffset = style.shadowOffset
        layer.shadowOpacity = Float(style.shadowOpacity)
        layer.shadowRadius = style.shadowRadius
    }
    
    @objc
    private func onTap() {
        viewData?.onTap?()
    }
}
