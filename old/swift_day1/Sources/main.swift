// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

enum Mode: String {
    case forward, backward
}

func findNumber(_ rawInput: String, mode: Mode) -> String {
    var tmpParsed = ""
    let input: String
    switch mode {
    case .forward:
        input = rawInput
    case .backward:
        input = String(rawInput.reversed())
    }
    for char in input {
        print("already parsed \(tmpParsed), next: \(char)")
        if char.isNumber {
            return String(char)
        } else {
            // "on" -> "one" -> 1
            switch mode {
            case .forward:
                tmpParsed += String(char)
            case .backward:
                tmpParsed = String(char) + tmpParsed
            }
            let foundNumber = stringIsNumber(tmpParsed)
            if !foundNumber.isEmpty {
                return foundNumber
            }
        }
    }
    return ""
}

/// "one" -> 1
func stringIsNumber(_ input: String) -> String {
    let possibleNumbers = [("one", "1"), ("two", "2"), ("three", "3"), ("four", "4"), ("five", "5"), ("six", "6"), ("seven", "7"), ("eight", "8"), ("nine", "9")]
    
    for (number, replaceInt) in possibleNumbers {
        if input.contains(number) {
            return replaceInt
        }
    }
    return ""
}


enum ToolError: Error {
    case provideExactlyOneArgument
}

// MARK: - Main

let args = CommandLine.arguments
guard args.count == 2 else {
    throw ToolError.provideExactlyOneArgument
}

let filename = args.last!
let path = "./\(filename)"
    // Get the contents
let input = try String(contentsOfFile: path, encoding: .utf8)
//let input = "oneeight9two\nhaei1er9eap"

let lines = input.split(separator: "\n").map({ String($0) })

var result = 0
for line in lines {
    print("start parsing: \(line)")
    let firstNumber = findNumber(line, mode: .forward)
    let lastNumber = findNumber(line, mode: .backward)
    
//    let firstNumber = String(clearedLine.first(where: { $0.isNumber })!)
//    let lastNumber = String(line.reversed().first(where: { $0.isNumber })!)
    let combined = String(firstNumber) + String(lastNumber)
    
    result += Int(combined) ?? 0
    print("ℹ️  \(line) && , \(firstNumber) \(lastNumber) -> \(combined)")
}


print("++++ Solution: \(result) ++++")
