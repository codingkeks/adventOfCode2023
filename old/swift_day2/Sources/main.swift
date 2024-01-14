// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

struct CubeKind {
    enum Color: String {
        case red, green, blue
        static var allCases: [Self] = [.red, .green, blue]
        static var allCasesString: [String] = allCases.map({ $0.rawValue })
    }
    
    let color: Color
    let amount: Int
    
    init(color: Color, amount: Int) {
        self.color = color
        self.amount = amount
    }
    
    init(text: String) {
//        print("Parsing cube: \(text)")
        color = Color(rawValue: Color.allCasesString.first(where: { text.contains($0) })!)!
        amount = Int(text.replacingOccurrences(of: color.rawValue, with: "").replacingOccurrences(of: " ", with: ""))!
    }
    
    var description: String {
        "\(amount), \(color.rawValue)"
    }
}

struct Game {
    let id: String
    let rounds: [[CubeKind]]
    let cubeSets: [CubeSet]
    
    init(_ input: String) {
        // Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        let gameAndRoundsSplitted = input.replacingOccurrences(of: "Game ", with: "").components(separatedBy: ": ")
        id = gameAndRoundsSplitted.first!
        
        // 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        let roundStrings = gameAndRoundsSplitted.last!.components(separatedBy: "; ")
        rounds = roundStrings.map {
            $0.components(separatedBy: ", ").map { CubeKind(text: String($0)) }
        }
        
        cubeSets = roundStrings.map {
            CubeSet($0)
        }
    }
    
    var description: String {
        "Game \(id): \(rounds.map { $0.map { $0.description } })"
    }
}


// MARK: - Part 1

func checkIfGameIsPossible(_ game: Game) -> Bool {
    let rounds = game.rounds
    for round in rounds {
        for cube in round {
            if checkIfCubeIsInBag(cube: cube) == false {
                return false
            }
        }
    }
    return true
}

func checkIfCubeIsInBag(cube: CubeKind) -> Bool {
    for availableCube in bag {
        if cube.color == availableCube.color {
            if cube.amount <= availableCube.amount {
                // all good
            } else {
                // not possible
                return false
            }
        }
    }
    return true
}

// MARK: - Part 2

// "3 blue, 4 red; 1 red, 2 green"
struct CubeSet {
    var blue: Int = 0
    var red: Int = 0
    var green: Int = 0
    
    // "3 blue, 4 red"
    init(_ input: String) {
        // "3 blue"
        for inputCubeKind in input.components(separatedBy: ", ") {
            let splittedInput = inputCubeKind.components(separatedBy: " ") // ["1", "blue"]
            let amount = splittedInput.first!
            let color = splittedInput.last!
            switch color {
            case "blue":
                blue = Int(amount) ?? 0
            case "red":
                red = Int(amount) ?? 0
            case "green":
                green = Int(amount) ?? 0
            default:
                fatalError("CubeSet parsing failed!: \(input)")
            }
        }
    }
}

//func checkLowestBagNeeded(for game: Game) -> (b: Int, r: Int, g: Int) {
func checkMagicNumber(for game: Game) -> Int {
    var highestBlue: Int = 0
    var highestRed: Int = 0
    var highestGreen: Int = 0
    
    // find highest of each round
    for cubeSet in game.cubeSets {
        if cubeSet.blue > highestBlue { highestBlue = cubeSet.blue }
        if cubeSet.red > highestRed { highestRed = cubeSet.red }
        if cubeSet.green > highestGreen { highestGreen = cubeSet.green }
    }
    let magicNumber = highestBlue * highestRed * highestGreen
    print("b\(highestBlue) r\(highestRed) g\(highestGreen) --> ✨ \(magicNumber)")
    return magicNumber
}

// MARK: - main
enum ToolError: Error { case provideExactlyOneArgument }
print("--- Day 2: Cube Conundrum ---")

let args = CommandLine.arguments
guard args.count == 2 else {
    throw ToolError.provideExactlyOneArgument
}

let filename = args.last!
let path = "./\(filename)"
    // Get the contents
let input = try String(contentsOfFile: path, encoding: .utf8)
//let input = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green\nGame 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue\nGame 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red\nGame 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red\nGame 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

let bag = "12 red, 13 green, 14 blue".components(separatedBy: ", ").map({ CubeKind(text: String($0)) })
//print("🧳 bag: \(bag.map({ $0.description }))")

// separate games
let gameLines: [String] = Array(input.components(separatedBy: "\n").map({ String($0) }).dropLast())
//let gameLines: [String] = Array(input.components(separatedBy: "\n").map({ String($0) }))
print(gameLines)

//var combinedGameIdsPossible = 0
var sumOfMagicNumbers = 0
for gameLine in gameLines {
    print("🚀")
//    print("🧳 bag: \(bag.map({ $0.description }))")
    print("\(gameLine)")
    let game = Game(gameLine)
    
    // Part 1
//    let gameIsPossible = checkIfGameIsPossible(game)
//    if gameIsPossible {
//        print("game \(game.id) is possible ✅")
//        combinedGameIdsPossible += Int(game.id) ?? 0
//    } else {
//        print("game \(game.id) is NOT possible ⛔️")
//    }
    
    // Part 2
    let magicNumber = checkMagicNumber(for: game)
    print("✨ \(magicNumber)")
    sumOfMagicNumbers += magicNumber
}

//print("🏁 Solution: \(combinedGameIdsPossible)")
print("🏁 Solution: \(sumOfMagicNumbers)")

