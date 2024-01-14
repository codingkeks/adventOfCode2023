// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

// https://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift
extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
//struct NumberPosition {
//    let index: Int
//    let value: Int
//    let length: Int
//}

struct Number {
    var indicies: [Int]
    var valueStr: String
    var value: Int { Int(valueStr) ?? 0}
    
    
    var description: String { "\(indicies),\(valueStr)"}
}

//struct Point {
//    var x: Int
//    var y: Int
//    
//    init(_ x: Int, _ y: Int) {
//        self.x = x
//        self.y = y
//    }
//    
//    var description: String { "\(x),\(y)"}
//}

print("Hello, world!")

let args = CommandLine.arguments
guard args.count == 2 else {
    fatalError("no argument provided")
}

let filename = args.last!
let path = "./\(filename)"
    // Get the contents
let input = try String(contentsOfFile: path, encoding: .utf8).dropLast()

/*
 467..114..
 ...*......
 ..35..633.
 ......#...
 617*......
 .....+.58.
 ..592.....
 ......755.
 ...$.*....
 .664.598..
 */
//let input = "467..114..\n...*......\n..35..633.\n......#...\n617*......\n.....+.58.\n..592.....\n......755.\n...$.*....\n.664.598.."

let lines = input.components(separatedBy: "\n")
//print("lines: \(lines)")


private func checkIndiciesForSymbolNextToNumberInLine(_ checkIndicies: [Int], _ previousLine: String, _ number: Number) {
    for checkIndicy in checkIndicies {
        let checkedChar = Character(previousLine[checkIndicy])
        if !checkedChar.isNumber && checkedChar != "." {
//            print(" add: \(number.value) ", terminator: "")
            result += number.value
        }
    }
}

var result = 0
for (currentLineIndex, currentLine) in lines.enumerated() {
    let previousLine: String = currentLineIndex - 1 >= 0 ? lines[currentLineIndex - 1] : ""
    let followingLine: String = currentLineIndex + 1 < lines.count ? lines[currentLineIndex + 1] : ""
   
    print("\(currentLine)", terminator: " ")
    
    
    // find number in currentline
    var foundNumbersInLine: [Number] = []
    var currentlyAddingNumber: Number?
    for (charIndex, char) in currentLine.enumerated() {
        if !char.isNumber {
            // add number if nothing follows
            if let numberFinished = currentlyAddingNumber {
                foundNumbersInLine.append(numberFinished)
                currentlyAddingNumber = nil
            }
        } else {
            
            // extend number
            if let numberToExtend = currentlyAddingNumber {
                var tmpNumber = numberToExtend
                tmpNumber.indicies.append(charIndex)
                tmpNumber.valueStr += String(char)
                
                currentlyAddingNumber = tmpNumber
                if charIndex == currentLine.count - 1 {
                    foundNumbersInLine.append(tmpNumber)
                    currentlyAddingNumber = nil
                }
            } else {
                // start with new number
                currentlyAddingNumber = Number(indicies: [charIndex], valueStr: String(char))
            }
        }
    }
    print("Found numbers: \(foundNumbersInLine.map { $0.valueStr })", terminator: "")
    
    for number in foundNumbersInLine {
        var checkIndicies: [Int] = []
        
        let previousFirstNumberIndex = number.indicies[0] - 1
        if previousFirstNumberIndex >= 0 { checkIndicies.append(previousFirstNumberIndex) }
        number.indicies.forEach { checkIndicies.append($0) }
        let followingLastNumberIndex = number.indicies.last! + 1
        if followingLastNumberIndex < currentLine.count { checkIndicies.append(followingLastNumberIndex) }
//        print("check indicies: \(checkIndicies)", terminator: "")
        
        let isPreviousLineAvailable = currentLineIndex - 1 >= 0
        if isPreviousLineAvailable {
            checkIndiciesForSymbolNextToNumberInLine(checkIndicies, previousLine, number)
        }
        
        var sameLineIndicies: [Int] = []
        if let sameLinePrevIndex = checkIndicies.first { sameLineIndicies.append(sameLinePrevIndex) }
        if let sameLineFollowIndex = checkIndicies.last { sameLineIndicies.append(sameLineFollowIndex) }
//        print("check indicies same line: \(sameLineIndicies)", terminator: "")
        checkIndiciesForSymbolNextToNumberInLine(sameLineIndicies, currentLine, number)

        let isFollowingLineAvailable = currentLineIndex + 1 < lines.count
        if isFollowingLineAvailable {
            checkIndiciesForSymbolNextToNumberInLine(checkIndicies, followingLine, number)
        }

    }
//    print("intermediate result: \(result)", terminator: "")
    print("")
}
print("solution: \(result)")
