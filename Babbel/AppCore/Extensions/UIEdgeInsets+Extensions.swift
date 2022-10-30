import UIKit

extension UIEdgeInsets {
    static func +(left: Self, right: Self) -> Self {
        .init(
            top: left.top + right.top,
            left: left.left + right.left,
            bottom: left.bottom + right.bottom,
            right: left.right + right.right
        )
    }
    
    static func -(left: Self, right: Self) -> Self {
        left + -right
    }
    
    static prefix func -(value: Self) -> Self {
        .init(
            top: -value.top,
            left: -value.left,
            bottom: -value.bottom,
            right: -value.right
        )
    }
}
