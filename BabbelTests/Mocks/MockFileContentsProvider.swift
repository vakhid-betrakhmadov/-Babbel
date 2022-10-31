import Foundation

@testable import Babbel

final class MockFileContentsProvider: FileContentsProvider {
    
    var onContents: (_ atPath: String) -> Data? = { _ in fatalError() }
    
    func contents(atPath path: String) -> Data? {
        onContents(path)
    }
}
