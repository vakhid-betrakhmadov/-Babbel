import Foundation

extension Optional {
    struct Error: LocalizedError {
        let errorDescription: String?
    }
    
    func get(
        fileID: StaticString = #fileID,
        line: Int = #line,
        column: Int = #column
    ) throws -> Wrapped {
        switch self {
        case let .some(value):
            return value
        case .none:
            throw Error(errorDescription: "\(fileID):\(line):\(column): Failed to unwrap instance of \(type(of: self))")
        }
    }
    
    func assert(
        fileID: StaticString = #fileID,
        line: Int = #line,
        column: Int = #column
    ) -> Self {
        do {
            return try get(
                fileID: fileID,
                line: line,
                column: column
            )
        } catch {
            assertionFailure(error.localizedDescription)
            return nil
        }
    }
}

