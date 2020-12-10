import Foundation

class Section {
    typealias Matrix = Array<Array<String>>
    var matrix: Matrix
    var name: String
    
    var closeSections = Dictionary<String, String>()
    var closeRow = Dictionary<String, RubiksCube.Side>()
    
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
