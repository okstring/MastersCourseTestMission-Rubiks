import Foundation

struct RubiksCube {
    typealias SectionMatrix = Array<Array<String>>
    var W: Section
    var B: Section
    var G: Section
    var Y: Section
    var O: Section
    var R: Section
    var sections: [Section]
    var startTime: TimeInterval!
    var endTime: TimeInterval!
    
    init() {
        self.W = Section(value: "W")
        self.B = Section(value: "B")
        self.G = Section(value: "G")
        self.Y = Section(value: "Y")
        self.O = Section(value: "O")
        self.R = Section(value: "R")
        sections = [W, B, G, Y, O, R]
    }
    
    mutating func startRubiksCube() {
        self.startTime = Date().timeIntervalSince1970
        
        
    }
    
    private func checkRubiksCube() -> Bool {
        for section in sections {
            if Set(section.matrix.flatMap({ $0 })).count != 1 {
                return false
            }
        }
        return true
    }
    
    private mutating func printElapsedTimeAndResult(result: Bool) -> Bool {
        self.endTime = Date().timeIntervalSince1970
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        
        let elapsedTime = Date(timeIntervalSince1970: endTime - startTime)
        print("경과시간: ", elapsedTime)
        if result {
            print("축하드립니다!! 큐브 맞추기를 꽤 잘하시네요!")
        } else {
            print("이용해주셔서 감사합니다. 뚜뚜뚜.")
        }
        return true
    }
    
    private func printRubiksCube() {
        B.printSection()
        print()
        for rowIndex in 0...2 {
            print(" ", terminator: "")
            print(W.matrix[rowIndex].joined(separator: " "), terminator: "")
            print(String(repeating: " ", count: 5), terminator: "")
            print(O.matrix[rowIndex].joined(separator: " "), terminator: "")
            print(String(repeating: " ", count: 5), terminator: "")
            print(G.matrix[rowIndex].joined(separator: " "), terminator: "")
            print(String(repeating: " ", count: 5), terminator: "")
            print(Y.matrix[rowIndex].joined(separator: " "))
        }
        print()
        R.printSection()
    }
}
