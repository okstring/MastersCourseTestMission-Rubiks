import Foundation

struct Cube {
    typealias CubeMatrix = Array<Array<String>>
    var matrix: CubeMatrix
    
    init(cube: CubeMatrix) {
        self.matrix = cube
        self.printCube()
    }
    
    func printCube() {
        for row in matrix {
            print(row.joined(separator: " "), terminator: "\n")
        }
    }
}
