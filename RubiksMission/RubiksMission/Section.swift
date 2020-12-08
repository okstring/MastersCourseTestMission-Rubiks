import Foundation

struct Section {
    typealias SectionMatrix = Array<Array<String>>
    var matrix: SectionMatrix
    
    init(value: String) {
        matrix = Array(repeating: Array(repeating: value, count: 3), count: 3)
    }
    
    func printSection() {
        for row in matrix {
            print(String(repeating: " ", count: 16), terminator: "")
            print(row.joined(separator: " "), terminator: "\n")
        }
    }
}
