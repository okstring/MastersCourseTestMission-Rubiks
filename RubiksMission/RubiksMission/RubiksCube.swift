import Foundation

struct RubiksCube {
    typealias SectionMatrix = Array<Array<String>>
    var W: Section
    var B: Section
    var G: Section
    var Y: Section
    var O: Section
    var R: Section
    var startTime: TimeInterval!
    var endTime: TimeInterval!
    
    init() {
        self.W = Section(value: "W")
        self.B = Section(value: "B")
        self.G = Section(value: "G")
        self.Y = Section(value: "Y")
        self.O = Section(value: "O")
        self.R = Section(value: "R")
    }
    
    mutating func startRubiksCube() {
        self.startTime = Date().timeIntervalSince1970
        
        
    }
    
    mutating func printElapsedTimeAndResult() -> Bool {
        self.endTime = Date().timeIntervalSince1970
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        
        let elapsedTime = Date(timeIntervalSince1970: endTime - startTime)
        print("경과시간: ", elapsedTime)
        print("이용해주셔서 감사합니다. 뚜뚜뚜.")
        return true
    }
    
    func printRubiksCube() {
        B.printSection()
        print()
        for rowIndex in 0...2 {
            print(" ", terminator: "")
            print(W.section[rowIndex].joined(separator: " "), terminator: "")
            print(String(repeating: " ", count: 5), terminator: "")
            print(O.section[rowIndex].joined(separator: " "), terminator: "")
            print(String(repeating: " ", count: 5), terminator: "")
            print(G.section[rowIndex].joined(separator: " "), terminator: "")
            print(String(repeating: " ", count: 5), terminator: "")
            print(Y.section[rowIndex].joined(separator: " "))
        }
        print()
        R.printSection()
    }
}
