import Foundation

protocol FileContentsProvider {
    func contents(atPath: String) -> Data?
}
