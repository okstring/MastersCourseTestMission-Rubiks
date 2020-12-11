import Foundation

struct FlatCubeGame {
    var cube: Cube
    
    init(cube: Cube) {
        self.cube = cube
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
                
                executeCommand(command)
                cube.printCube()
            }
            
            if exit { break }
        }
    }
    
    private mutating func executeCommand(_ command: String) {
        switch command {
        case "U": horisonPush(row: .topRow, direction: .left);
        case "U'": horisonPush(row: .topRow, direction: .right)
        case "R": verticalPush(col: .rightRow, direction: .up)
        case "R'": verticalPush(col: .rightRow, direction: .down)
        case "L": verticalPush(col: .leftRow, direction: .down)
        case "L'": verticalPush(col: .leftRow, direction: .up)
        case "B": horisonPush(row: .bottomRow, direction: .right)
        case "B'": horisonPush(row: .bottomRow, direction: .left)
        default: print("command가 올바르지 않습니다")
        }
    }
    
    private mutating func verticalPush(col: SideLineToMove, direction: VerticalPushDirection) {
        if direction == .up {
            let topValue = col == .rightRow ? cube.matrix[0][col.rawValue] : cube.matrix[0][col.rawValue]
            cube.matrix[0][col.rawValue] = cube.matrix[1][col.rawValue]
            cube.matrix[1][col.rawValue] = cube.matrix[2][col.rawValue]
            cube.matrix[2][col.rawValue] = topValue
        } else if direction == .down {
            let bottomValue = col == .rightRow ? cube.matrix[2][col.rawValue] : cube.matrix[2][col.rawValue]
            cube.matrix[2][col.rawValue] = cube.matrix[1][col.rawValue]
            cube.matrix[1][col.rawValue] = cube.matrix[0][col.rawValue]
            cube.matrix[0][col.rawValue] = bottomValue
        }
    }
    
    private mutating func horisonPush(row: UpperAndLowerLineToMove, direction: HorizonPushDirection) {
        if direction == .right {
            let lastValue = cube.matrix[row.rawValue].removeLast()
            cube.matrix[row.rawValue] = [lastValue] + cube.matrix[row.rawValue]
        } else if direction == .left {
            let firstValue = cube.matrix[row.rawValue].removeFirst()
            cube.matrix[row.rawValue] = cube.matrix[row.rawValue] + [firstValue]
        }
    }
    
    

}
