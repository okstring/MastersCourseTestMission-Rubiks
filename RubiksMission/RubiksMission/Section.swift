import Foundation

class Section {
    var matrix: Array<Array<String>>
    var name: String!
    init(value: String) {
        matrix = Array(repeating: Array(repeating: value, count: 3), count: 3)
        self.name = value
    }
    
    func printSection() {
        for row in matrix {
            print(String(repeating: " ", count: 16), terminator: "")
            print(row.joined(separator: " "), terminator: "\n")
        }
    }
}
