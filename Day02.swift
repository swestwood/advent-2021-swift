import Foundation

struct Direction: Hashable {
    let dir: String
    let amount: Int
}

func part1(directions: [Direction]) {
    var horizontal = 0
    var depth = 0
    for direction in directions {
        switch direction.dir {
        case "forward":
            horizontal += direction.amount
        case "up":
            depth -= direction.amount
        case "down":
            depth += direction.amount
        default:
            fatalError("unrecognized direction")
        }
    }
    print("Part 1: Horizontal: \(horizontal), depth \(depth), product \(horizontal * depth)")
}

func part2(directions _: [Direction]) {
    var horizontal = 0
    var depth = 0
    var aim = 0
    for direction in directions {
        switch direction.dir {
        case "forward":
            horizontal += direction.amount
            depth += aim * direction.amount
        case "up":
            aim -= direction.amount
        case "down":
            aim += direction.amount
        default:
            fatalError("unrecognized direction")
        }
    }
    print("Part 2: Horizontal: \(horizontal), depth \(depth), product \(horizontal * depth)")
}

let contents = try! String(contentsOfFile: "./data/day02.txt")
let directions = contents.components(separatedBy: .newlines)
    .map { $0.components(separatedBy: " ") }
    .map { Direction(dir: $0[0], amount: Int($0[1])!) }
print("read data")
part1(directions: directions)
part2(directions: directions)
