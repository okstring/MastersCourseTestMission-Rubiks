import Foundation
/*
-------------------------------------
               B B B
               B 위 B
               B B B

W W W     O O O     G G G     Y Y Y
W왼쪽W     O 앞 O     오른쪽     Y 뒤 Y
W W W     O O O     G G G     Y Y Y

               R R R
               R아래R
               R R R
 ------------------------------------
 */

class RubiksCube {
    var W: Section = Section(value: "W") // left
    var O: Section = Section(value: "O") // front
    var G: Section = Section(value: "G") // right
    var Y: Section = Section(value: "Y") // back
    var B: Section = Section(value: "B") // top
    var R: Section = Section(value: "R") // bottom
    
    private var sections: [Section]
    private var startTime: TimeInterval = Date().timeIntervalSince1970
    private var numberOfOperations = 0
    
    private let commands = ["U", "U'", "L", "L'", "F", "F'", "R", "R'", "B", "B'", "D", "D'"]
    
    private var isComplete = false
    private var command = ""
    private var repeatCount = 1
    
    private let gameGuide = """

---------------------------------------------

큐브가 만들어졌습니다 게임을 시작해주세요!

이용 방법

startRubiksCube(): Rubiks Cube Game을 시작합니다. Q를 입력하면 게임이 종료됩니다.
shuffleRubiksCube(): Cube를 섞습니다.
printRubiksCube(): 현재 Cube를 출력합니다.


---------------------------------------------

"""
    
    init() {
        sections = [W, O, G, Y, B, R]
        
        O.closeSections = ["top": B.name, "right": G.name, "bottom": R.name, "left": W.name]
        O.closeRow = ["top": .bottom, "right": .left, "bottom": .reverseTop, "left": .right]
        B.closeSections = ["top": Y.name, "right": G.name, "bottom": O.name, "left": W.name]
        B.closeRow = ["top": .reverseTop, "right": .reverseTop, "bottom": .reverseTop, "left": .reverseTop]
        G.closeSections = ["top": B.name, "right": Y.name, "bottom": R.name, "left": O.name]
        G.closeRow = ["top": .reverseRight, "right": .left, "bottom": .reverseRight, "left": .right]
        R.closeSections = ["top": O.name, "right": G.name, "bottom": Y.name, "left": W.name]
        R.closeRow = ["top": .bottom, "right": .bottom, "bottom": .bottom, "left": .bottom]
        W.closeSections = ["top": B.name, "right": O.name, "bottom": R.name, "left": Y.name]
        W.closeRow = ["top": .left, "right": .left, "bottom": .reverseLeft, "left": .reverseRight]
        Y.closeSections = ["top": B.name, "right": W.name, "bottom": R.name, "left": G.name]
        Y.closeRow = ["top": .reverseTop, "right": .reverseLeft, "bottom": .top, "left": .reverseRight]

        printRubiksCube()
        print(gameGuide)

    }
    
    subscript(name: String) -> Section {
        get {
            guard let section = sections.filter({ $0.name == name }).first else {
                assert(false, "subscript name이 올바르지 않습니다")
            }
            return section
        }
        set(newValue) {
            switch name {
            case "W": self.W = newValue
            case "O": self.O = newValue
            case "G": self.G = newValue
            case "Y": self.Y = newValue
            case "B": self.B = newValue
            case "R": self.R = newValue
            default: break
            }
        }
    }
    
    enum Side {
        case top
        case bottom
        case right
        case left
        case reverseTop
        case reverseBottom
        case reverseRight
        case reverseLeft
    }
    
    func startRubiksCube() {
        var input = ""
        while !isComplete {
            if input == "" {
                print("\nCUBE> ", terminator: "")
                input = readLine() ?? ""
            }
            command = String(input.removeFirst())
            repeatCount = 1
            
            if command == "Q" { break }
            
            input = extractSubCommandAndRepeatCount(input)
            
            executeRotate(command, count: repeatCount, isShuffle: false)
            isComplete = isCompleteRubiksCube()
        }
        
        printElapsedTimeAndResult(result: isComplete)
    }
    
    func extractSubCommandAndRepeatCount(_ input: String) -> String {
        var classified = input
        
        if let digit = Int(command){ // 숫자면
            repeatCount = digit
        }
        
        if repeatCount != 1 && input != "" { // 커멘드 있으면 꺼내기
            command = String(classified.removeFirst())
        }
        
        if input.first != nil && input.first! == "'" {  // is reverse?
            command.append(classified.removeFirst())
        }
        
        return classified
    }
    
    
    private func isCompleteRubiksCube() -> Bool {
        for section in sections {
            if Set(section.matrix.flatMap({ $0 })).count != 1 {
                return false
            }
        }
        
        return true
    }
    
    private func printElapsedTimeAndResult(result: Bool) {
        let endTime = Date().timeIntervalSince1970
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        
        let elapsedTime = Date(timeIntervalSince1970: endTime - startTime)
        print("경과시간: ", dateFormatter.string(from: elapsedTime))
        print("조작갯수: ", numberOfOperations)
        if result {
            print("🎉🎉축하드립니다!! 큐브 맞추기를 꽤 잘하시네요!")
        } else {
            print("이용해주셔서 감사합니다. 뚜뚜뚜.")
        }
    }
    
    func printRubiksCube() {
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
        print()
    }
    
    func shuffleRubiksCube() {
        let shuffleCount = Int.random(in: (1...3))
        _ = commands.shuffled().map({ executeRotate($0, count: shuffleCount, isShuffle: true) })
        printRubiksCube()
        print("\nShuffle이 완료됐습니다 🔀", terminator: "\n\n")
    }
    
    
    private func countOperationAndPrintRubiksCube() {
        numberOfOperations += 1
        printRubiksCube()
    }
    
    // MARK: Rotate Method
    
    private func executeRotate(_ command: String, count: Int, isShuffle: Bool) {
        for _ in 1...count {
            if !isShuffle{ print("\n\(command)") }
            switch command {
            case "U": rotate(of: &B, isReverse: false)
            case "U'": rotate(of: &B, isReverse: true)
            case "L": rotate(of: &W, isReverse: false)
            case "L'": rotate(of: &W, isReverse: true)
            case "F": rotate(of: &O, isReverse: false)
            case "F'": rotate(of: &O, isReverse: true)
            case "R": rotate(of: &G, isReverse: false)
            case "R'": rotate(of: &G, isReverse: true)
            case "B": rotate(of: &Y, isReverse: false)
            case "B'": rotate(of: &Y, isReverse: true)
            case "D": rotate(of: &R, isReverse: false)
            case "D'":rotate(of: &R, isReverse: true)
            default: print("command(\(command))가 올바르지 않습니다.")
            }
            if !isShuffle { countOperationAndPrintRubiksCube() }
        }
    }
    
    private func rotate(of front: inout Section, isReverse: Bool) {
        var result = Array(repeating: Array(repeating: "", count: 3), count: 3)
        for index in 0...2 {
            for anotherIndex in 0...2 {
                result[anotherIndex][index] = front.matrix[index][anotherIndex]
            }
        }
        if isReverse {
            front.matrix = [result[2], result[1], result[0]] // -90
            reverseRotateSideValue(top: front.closeSections["top"]!, topSide: front.closeRow["top"]!, right: front.closeSections["right"]!, rightSide: front.closeRow["right"]!,
                                   bottom: front.closeSections["bottom"]!, bottomSide: front.closeRow["bottom"]!, left: front.closeSections["left"]!, leftSide: front.closeRow["left"]!)
        } else {
            front.matrix = [result[0].reversed(), result[1].reversed(), result[2].reversed()] // 90
            rotateSideValue(top: front.closeSections["top"]!, topSide: front.closeRow["top"]!, right: front.closeSections["right"]!, rightSide: front.closeRow["right"]!,
                            bottom: front.closeSections["bottom"]!, bottomSide: front.closeRow["bottom"]!, left: front.closeSections["left"]!, leftSide: front.closeRow["left"]!)
        }
    }
    
    private func rotateSideValue(top: String, topSide: Side, right: String, rightSide: Side, bottom: String, bottomSide: Side, left: String, leftSide: Side) {
        let toRightValue = findSideValue(of: top, side: topSide)
        let toBottomValue = findSideValue(of: right, side: rightSide)
        let toLeftValue = findSideValue(of: bottom, side: bottomSide)
        let toTopValue = findSideValue(of: left, side: leftSide)
        
        rubiksCube[top].matrix = changeSideValue(of: top, side: topSide, value: toTopValue)
        rubiksCube[bottom].matrix = changeSideValue(of: bottom, side: bottomSide, value: toBottomValue)
        rubiksCube[right].matrix = changeSideValue(of: right, side: rightSide, value: toRightValue)
        rubiksCube[left].matrix = changeSideValue(of: left, side: leftSide, value: toLeftValue)
    }
    
    private func reverseRotateSideValue(top: String , topSide: Side, right: String, rightSide: Side, bottom: String, bottomSide: Side, left: String, leftSide: Side) {
        let toLeftValue = findSideValue(of: top, side: topSide)
        let toBottomValue = findSideValue(of: left, side: leftSide)
        let toRightValue = findSideValue(of: bottom, side: bottomSide)
        let toTopValue = findSideValue(of: right, side: rightSide)
        
        rubiksCube[top].matrix = changeSideValue(of: top, side: topSide, value: toTopValue)
        rubiksCube[bottom].matrix = changeSideValue(of: bottom, side: bottomSide, value: toBottomValue)
        rubiksCube[right].matrix = changeSideValue(of: right, side: rightSide, value: toRightValue)
        rubiksCube[left].matrix = changeSideValue(of: left, side: leftSide, value: toLeftValue)
    }

    private func changeSideValue(of name: String, side: Side, value: Array<String>) -> Section.Matrix {
        guard var result = sections.filter({ $0.name == name }).first?.matrix else { return Section.Matrix() }
        switch side {
        case .top: result[0] = value
        case .bottom: result[2] = value
        case .reverseTop: result[0] = value.reversed()
        case .reverseBottom: result[2] = value.reversed()
        case .left: _ = stride(from: 2, through: 0, by: -1).map({ result[$0][0] = value[$0] })
        case .right: _ = (0...2).map({ result[$0][2] = value[$0] })
        case .reverseLeft: _ = (0...2).map({ result[$0][0] = value[$0] })
        case .reverseRight: _ = stride(from: 2, through: 0, by: -1).map({ result[$0][2] = value[$0] })
        }
        return result
    }

    private func findSideValue(of name: String, side: Side) -> Array<String> {
        var result = Array<String>()
        guard let matrix = sections.filter({ $0.name == name }).first?.matrix else { return result }
        switch side {

        case .top: return matrix[0]
        case .bottom: return matrix[2]
            
        case .reverseTop: return matrix[0].reversed()
        case .reverseBottom: return matrix[2].reversed()
            
        case .left: _ = (0...2).map({ result.append(matrix[$0][0]) }); return result
        case .right: _ = (0...2).map({ result.append(matrix[$0][2]) }); return result
            
        case .reverseLeft: _ = stride(from: 2, through: 0, by: -1).map({ result.append(matrix[$0][0]) }); return result
        case .reverseRight: _ = stride(from: 2, through: 0, by: -1).map({ result.append(matrix[$0][2]) }); return result
        }
    }
}
