final class DefaultDisposeBag: DisposeBag {
    private var disposables: Array<AnyObject> = []
    
    func add(disposable: AnyObject) {
        disposables.append(disposable)
    }
}
