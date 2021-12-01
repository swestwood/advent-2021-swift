import Foundation

func part1(nums: [Int]) {
    var increases = 0
    var previous = -1 // all integers in the file are positive
    for num in nums {
        if previous > 0, num > previous {
            increases += 1
        }
        previous = num
    }
    print("Part 1 increases: \(increases)")
}

let WINDOW_SIZE = 3
func part2(nums: [Int]) {
    var increases = 0
    var windowSum = 0
    for (i, num) in nums.enumerated() {
        let prevWindowSum = windowSum
        if i - WINDOW_SIZE >= 0 {
            windowSum -= nums[i - WINDOW_SIZE]
        }
        windowSum += num
        if i >= WINDOW_SIZE, windowSum > prevWindowSum {
            increases += 1
        }
    }
    print("Part 2 sliding window increases: \(increases)")
}

let contents = try! String(contentsOfFile: "./data/day01.txt")
let nums = contents.components(separatedBy: .newlines).compactMap(Int.init)
print("read data")
part1(nums: nums)
part2(nums: nums)
