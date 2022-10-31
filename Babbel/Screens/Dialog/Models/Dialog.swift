struct Dialog {
    enum Style {
        case actionSheet, alert
    }
    
    struct Action {
        let title: String?
        let style: Style
        let handler: ((Action) -> ())?
        
        enum Style {
            case `default`, cancel, destructive
        }
    }
    
    let title: String?
    let message: String?
    let style: Style
    let actions: [Action]
}
