import Foundation

struct FlatCube {
    typealias CubeMatrix = Array<Array<String>>
    private var cube: CubeMatrix
    
    init(cube: Array<Array<String>>) {
        self.cube = cube
        self.printCube()
    }
    
    private enum VerticalPushDirection {
        case up
        case down
    }
    
    private enum HorizonPushDirection {
        case right
        case left
    }
    
    private enum UpperAndLowerLineToMove: Int {
        case topRow = 0
        case bottomRow = 2
    }
    
    private enum SideLineToMove: Int {
        case rightRow = 2
        case leftRow = 0
    }
    
    mutating func playFlatCube() {
        var exit = false
        
        while true {
            print("\nCUBE> ", terminator: "")
            var input = readLine() ?? ""
            
            while input != "" {
                var command = String(input.removeFirst())
                if command == "Q" {
                    exit = true
                    print("Bye~")
                    break
                }
                
                if let reverseSign = input.first {
                    if reverseSign == "'" { command.append(input.removeFirst()) }
                }
                print("\n\(command)")
                
                switch command {
                case "U": horisonPush(row: .topRow, direction: .left); 
                case "U'": horisonPush(row: .topRow, direction: .right)
                case "R": verticalPush(col: .rightRow, direction: .up)
                case "R'": verticalPush(col: .rightRow, direction: .down)
                case "L": verticalPush(col: .leftRow, direction: .down)
                case "L'": verticalPush(col: .leftRow, direction: .up)
                case "B": horisonPush(row: .bottomRow, direction: .right)
                case "B'": horisonPush(row: .bottomRow, direction: .left)
                default:
                    exit = true
                    print("command가 올바르지 않습니다")
                    break
                }
                printCube()
            }
            
            if exit { break }
        }
    }
    
    private mutating func verticalPush(col: SideLineToMove, direction: VerticalPushDirection) {
        if direction == .up {
            let topValue = col == .rightRow ? cube[0][col.rawValue] : cube[0][col.rawValue]
            cube[0][col.rawValue] = cube[1][col.rawValue]
            cube[1][col.rawValue] = cube[2][col.rawValue]
            cube[2][col.rawValue] = topValue
        } else if direction == .down {
            let bottomValue = col == .rightRow ? cube[2][col.rawValue] : cube[2][col.rawValue]
            cube[2][col.rawValue] = cube[1][col.rawValue]
            cube[1][col.rawValue] = cube[0][col.rawValue]
            cube[0][col.rawValue] = bottomValue
        }
    }
    
    private mutating func horisonPush(row: UpperAndLowerLineToMove, direction: HorizonPushDirection) {
        if direction == .right {
            let lastValue = cube[row.rawValue].removeLast()
            cube[row.rawValue] = [lastValue] + cube[row.rawValue]
        } else if direction == .left {
            let firstValue = cube[row.rawValue].removeFirst()
            cube[row.rawValue] = cube[row.rawValue] + [firstValue]
        }
    }
    
    
    private func printCube() {
        for row in cube {
            print(row.joined(separator: " "), terminator: "\n")
        }
    }
}
