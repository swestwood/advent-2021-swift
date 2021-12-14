import Foundation

func cost(_ arr: [Int], _ position: Int) -> Int {
    var total = 0
    for val in arr {
        total += abs(position - val)
    }
    return total
}

func part1(_ values: [Int]) {
    // The best one is just the median
    let median = values[values.count / 2]
    let medianCost = cost(values, median)
    print("Part 1: Best cost is \(medianCost) with value \(median)")
}

var costs = [0, 1]
func stepCost(_ step: Int) -> Int {
    // 1 - 1
    // 2 - 3
    // 3 - 6
    // 4 - 10
    // 5 - 15
    // 6 - 21
    while costs.count <= step {
        costs.append(costs.last! + costs.count)
    }
    return costs[step]
}

func costPart2(_ arr: [Int], _ position: Int) -> Int {
    var total = 0
    for val in arr {
        total += stepCost(abs(position - val))
    }
    return total
}

func part2(_ values: [Int]) {
    var current = values[values.count / 2] // might as well start at the median
    let direction = costPart2(values, current - 1) < costPart2(values, current + 1) ? -1 : 1
    var currentCost = costPart2(values, current)
    while true {
        let nextCost = costPart2(values, current + direction)
        if currentCost < nextCost {
            print("Checking \(current) vs \(current + direction), result was \(currentCost) vs \(nextCost)")
            print("Part 2: Best cost is \(currentCost) with value \(current)")
            break
        }
        currentCost = nextCost
        current = current + direction
    }
}

var values = try! String(contentsOfFile: "./data/day07.txt").components(separatedBy: ",").compactMap { Int($0)! }
values.sort()
part1(values)
part2(values)
