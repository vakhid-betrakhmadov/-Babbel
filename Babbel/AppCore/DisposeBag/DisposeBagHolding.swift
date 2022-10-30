protocol DisposeBagHolding {
    var disposeBag: DisposeBag { get }
}

extension DisposeBagHolding where Self: DisposeBag {
    func add(disposable: AnyObject) {
        disposeBag.add(disposable: disposable)
    }
}
