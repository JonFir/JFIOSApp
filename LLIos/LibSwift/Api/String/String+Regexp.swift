import Foundation

public extension String {
    func matches(
        _ pattern: String,
        options: NSRegularExpression.Options = []
    ) throws -> Bool {
        let regex = try NSRegularExpression(pattern: pattern, options: options)

        let range = NSRange(self.startIndex..., in: self)
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
}
