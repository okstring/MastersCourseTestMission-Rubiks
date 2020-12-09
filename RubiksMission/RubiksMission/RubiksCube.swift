import Foundation
/*
               B B B
               B 위 B
               B B B

W W W     O O O     G G G     Y Y Y
W왼쪽W     O 앞 O     오른쪽     Y 뒤 Y
W W W     O O O     G G G     Y Y Y

               R R R
               R아래R
               R R R
 */


class RubiksCube {
    var W: Section // left
    var O: Section // front
    var G: Section // right
    var Y: Section // back
    var B: Section // top
    var R: Section // bottom
    var sections: [Section]
    var startTime: TimeInterval!
    var endTime: TimeInterval!
    
    init() {
        self.W = Section(value: "W")
        self.O = Section(value: "O")
        self.G = Section(value: "G")
        self.Y = Section(value: "Y")
        self.B = Section(value: "B")
        self.R = Section(value: "R")
        sections = [W, O, G, Y, B, R]
    }
    
    typealias Matrix = Array<Array<String>>
    
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
        self.startTime = Date().timeIntervalSince1970
        var isComplete = false
        var quit = false
        var input = ""
        
        while !isComplete {
            
            if input == "" { print("\nCUBE> ", terminator: ""); input = readLine() ?? "" }
            var command = String(input.removeFirst())
            var repeatCount = 1
            
            if command == "Q" { quit = true; break }
            
            if let digit = Int(command) { // 숫자면
                repeatCount = digit
                if input != "" { // 또 꺼내기
                    command = String(input.removeFirst())
                }
            }
            if let reverseSign = input.first {
                if reverseSign == "'" {
                    command.append(input.removeFirst())
                }
            }
            
            executeRotate(command, count: repeatCount)
            
            isComplete = isCompleteRubiksCube()
            if quit { break }
        }
        
        printElapsedTimeAndResult(result: isComplete)
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
        self.endTime = Date().timeIntervalSince1970
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        
        let elapsedTime = Date(timeIntervalSince1970: endTime - startTime)
        print("경과시간: ", dateFormatter.string(from: elapsedTime))
        if result {
            print("축하드립니다!! 큐브 맞추기를 꽤 잘하시네요!")
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
    
    // MARK: Rotate Method
    
    func executeRotate(_ command: String, count: Int) {
        for _ in 1...count {
            print("\n\(command)")

            switch command {
            case "U":
                rotateFront(of: &B.matrix, isReverse: false)
                rotateSideValue(top: &Y, topSide: .reverseTop, right: &G, rightSide: .reverseTop, bottom: &O, bottomSide: .reverseTop, left: &W, leftSide: .reverseTop)
            case "U'":
                rotateFront(of: &B.matrix, isReverse: true)
                reverseRotateSideValue(top: &Y, topSide: .reverseTop, right: &G, rightSide: .reverseTop, bottom: &O, bottomSide: .reverseTop, left: &W, leftSide: .reverseTop)
            case "L":
                rotateFront(of: &W.matrix, isReverse: false)
                rotateSideValue(top: &B, topSide: .left, right: &O, rightSide: .left, bottom: &R, bottomSide: .reverseLeft, left: &Y, leftSide: .reverseRight)
            case "L'":
                rotateFront(of: &W.matrix, isReverse: true)
                reverseRotateSideValue(top: &B, topSide: .left, right: &O, rightSide: .left, bottom: &R, bottomSide: .reverseLeft, left: &Y, leftSide: .reverseRight)
            case "F":
                rotateFront(of: &O.matrix, isReverse: false)
                rotateSideValue(top: &B, topSide: .bottom, right: &G, rightSide: .left,
                                bottom: &R, bottomSide: .reverseTop, left: &W, leftSide: .right)
            case "F'":
                rotateFront(of: &O.matrix, isReverse: true)
                reverseRotateSideValue(top: &B, topSide: .bottom, right: &G, rightSide: .left,
                                bottom: &R, bottomSide: .reverseTop, left: &W, leftSide: .right)
            case "R":
                rotateFront(of: &G.matrix, isReverse: false)
                rotateSideValue(top: &B, topSide: .reverseRight, right: &Y, rightSide: .left, bottom: &R, bottomSide: .reverseRight, left: &O, leftSide: .right)
            case "R'":
                rotateFront(of: &G.matrix, isReverse: true)
                reverseRotateSideValue(top: &B, topSide: .reverseRight, right: &Y, rightSide: .left, bottom: &R, bottomSide: .reverseRight, left: &O, leftSide: .right)
            case "B":
                rotateFront(of: &Y.matrix, isReverse: false)
                rotateSideValue(top: &B, topSide: .reverseTop, right: &W, rightSide: .reverseLeft, bottom: &R, bottomSide: .top, left: &G, leftSide: .reverseRight)
            case "B'":
                rotateFront(of: &Y.matrix, isReverse: true)
                reverseRotateSideValue(top: &B, topSide: .reverseTop, right: &W, rightSide: .reverseLeft, bottom: &R, bottomSide: .top, left: &G, leftSide: .reverseRight)
            case "D":
                rotateFront(of: &R.matrix, isReverse: false)
                rotateSideValue(top: &O, topSide: .bottom, right: &G, rightSide: .bottom, bottom: &Y, bottomSide: .bottom, left: &W, leftSide: .bottom)
            case "D'":
                rotateFront(of: &R.matrix, isReverse: true)
                reverseRotateSideValue(top: &O, topSide: .bottom, right: &G, rightSide: .bottom, bottom: &Y, bottomSide: .bottom, left: &W, leftSide: .bottom)
            default:
                print("command(\(command))가 올바르지 않습니다.")
            }
            
            printRubiksCube()
        }
    }
    
    func rotateSideValue(top: inout Section, topSide: Side, right: inout Section, rightSide: Side, bottom: inout Section, bottomSide: Side, left: inout Section, leftSide: Side) {
        let toRightValue = findSideValue(of: top.name, side: topSide)
        let toBottomValue = findSideValue(of: right.name, side: rightSide)
        let toLeftValue = findSideValue(of: bottom.name, side: bottomSide)
        let toTopValue = findSideValue(of: left.name, side: leftSide)

        top.matrix = changeSideValue(of: top.name, side: topSide, value: toTopValue)
        bottom.matrix = changeSideValue(of: bottom.name, side: bottomSide, value: toBottomValue)
        right.matrix = changeSideValue(of: right.name, side: rightSide, value: toRightValue)
        left.matrix = changeSideValue(of: left.name, side: leftSide, value: toLeftValue)
    }
    
    func reverseRotateSideValue(top: inout Section , topSide: Side, right: inout Section, rightSide: Side, bottom: inout Section, bottomSide: Side, left: inout Section, leftSide: Side) {
        let toLeftValue = findSideValue(of: top.name, side: topSide)
        let toBottomValue = findSideValue(of: left.name, side: leftSide)
        let toRightValue = findSideValue(of: bottom.name, side: bottomSide)
        let toTopValue = findSideValue(of: right.name, side: rightSide)
        
        top.matrix = changeSideValue(of: top.name, side: topSide, value: toTopValue)
        bottom.matrix = changeSideValue(of: bottom.name, side: bottomSide, value: toBottomValue)
        right.matrix = changeSideValue(of: right.name, side: rightSide, value: toRightValue)
        left.matrix = changeSideValue(of: left.name, side: leftSide, value: toLeftValue)
    }

    func changeSideValue(of name: String, side: Side, value: Array<String>) -> Matrix {
        guard var result = sections.filter({ $0.name == name }).first?.matrix else { return Matrix() }
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

    func findSideValue(of name: String, side: Side) -> Array<String> {
        var result = Array<String>()
        guard let matrix = sections.filter({ $0.name == name }).first?.matrix else { return result }
        switch side {
        case .top: return matrix[0]
        case .bottom: return matrix[2]
        case .reverseTop: return matrix[0].reversed()
        case .reverseBottom: return matrix[2].reversed()
        case .left:
            _ = (0...2).map({ result.append(matrix[$0][0]) })
            return result
        case .right:
            _ = (0...2).map({ result.append(matrix[$0][2]) })
            return result
        case .reverseLeft:
            _ = stride(from: 2, through: 0, by: -1).map({ result.append(matrix[$0][0]) })
            return result
        case .reverseRight:
            _ = stride(from: 2, through: 0, by: -1).map({ result.append(matrix[$0][2]) })
            return result
        }
    }
    
    func rotateFront(of front: inout Matrix, isReverse: Bool) {
        
        var result = Array(repeating: Array(repeating: "", count: 3), count: 3)
        
        // Transpose
        for i in 0...2 {
            for j in 0...2 {
                result[j][i] = front[i][j]
            }
        }
        
        if isReverse {
            front = [result[2], result[1], result[0]] // -90
        } else {
            front = [result[0].reversed(), result[1].reversed(), result[2].reversed()] // 90
        }
    }
    
}
