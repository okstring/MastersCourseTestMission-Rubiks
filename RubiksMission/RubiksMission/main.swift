import Foundation

var rubiksCube = RubiksCube()
rubiksCube.printRubiksCube()

rubiksCube.rotateSideValue(top: &rubiksCube.B, topSide: .bottom, bottom: &rubiksCube.R, bottomSide: .reverseTop, right: &rubiksCube.G, rightSide: .left, left: &rubiksCube.W, leftSide: .reverseRight)

rubiksCube.printRubiksCube()
