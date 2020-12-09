import Foundation

struct PushOutWord {
    private var word: String = ""
    private var direction: String = ""
    private var absNumber: Int = 0
    
    mutating func startPushOutWord() {
        while true {
            print("> ", terminator: "")
            let read = readLine()
            guard let input = read else { continue }
            
            guard input != "quit" else { break }
            
            let splitWord = input.split(separator: " ")
            if !isThreeValue(splitWord) { continue }

            self.word = String(splitWord[0])
            self.direction = String(splitWord[2]).uppercased()
            guard let number = Int(splitWord[1]) else {
                print("올바른 정수가 아닙니다")
                continue
            }
            
            if !isIntegerInRange(number) { continue }
            if !isLOrR(self.direction) { continue }
            self.absNumber = changeDirectionToMatchNegativeNumber(number)
            
            if self.direction == "L" {
                var count = 0
                while count < self.absNumber {
                    let firstCharacter = self.word.removeFirst()
                    self.word = "\(self.word)\(firstCharacter)"
                    count += 1
                }
                print(self.word)
                
            } else if self.direction == "R" {
                var count = 0
                while count < self.absNumber {
                    let lastCharacter = word.removeLast()
                    word = "\(lastCharacter)\(self.word)"
                    count += 1
                }
                print(self.word)
            }
        }
    }
    
    private func isThreeValue(_ splitWord: [String.SubSequence]) -> Bool {
        if splitWord.count != 3 {
            print("올바른 입력이 아닙니다 단어 하나, 정수 숫자 하나, L 또는 R을 띄어서 입력해주세요")
            return false
        }
        return true
    }
    
    private func isIntegerInRange(_ number: Int) -> Bool {
        if number < -100 || number >= 100 {
            print("올바른 정수 범위가 아닙니다 -100 <= N < 100 사이를 입력해주세요")
            return false
        }
        return true
    }
    
    private func isLOrR(_ direction: String) -> Bool {
        if direction != "L" && direction != "R" {
            print("올바른 방향이 아닙니다 L 또는 R을 입력해주세요")
            return false
        }
        return true
    }
    
    private mutating func changeDirectionToMatchNegativeNumber(_ number: Int) -> Int {
        if number < 0 {
            switch direction {
            case "L": self.direction = "R"
            case "R": self.direction = "L"
            default: break
            }
        }
        return abs(number)
    }
}
