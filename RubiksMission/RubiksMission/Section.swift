import Foundation

struct Section {
    typealias SectionMatrix = Array<Array<String>>
    var section: SectionMatrix
    
    init(value: String) {
        section = Array(repeating: Array(repeating: value, count: 3), count: 3)
    }
    
    func printSection() {
        for row in section {
            print(String(repeating: " ", count: 16), terminator: "")
            print(row.joined(separator: " "), terminator: "\n")
        }
    }
}
