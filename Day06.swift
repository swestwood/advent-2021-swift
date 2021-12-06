import Foundation

func sum(_ arr: [Int]) -> Int {
    return arr.reduce(0, +)
}

let initialAges = try! String(contentsOfFile: "./data/day06.txt").components(separatedBy: ",").compactMap { Int($0)! }
print(initialAges)

let MAX_TIMER = 8
let NUM_DAYS = 256 // 80 for part 1
var timers = Array(repeating: 0, count: MAX_TIMER + 1)
for age in initialAges {
    timers[age] += 1
}

print(timers)
for _ in 0 ..< NUM_DAYS {
    let spawned = timers[0]
    for i in 1 ... MAX_TIMER {
        timers[i - 1] = timers[i]
    }
    timers[8] = spawned // the new fish
    timers[6] += spawned // the resetting fish
}

print("Number of fish after \(NUM_DAYS) days: \(sum(timers))")
