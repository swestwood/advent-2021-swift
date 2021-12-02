import Foundation

func part1(nums: [Int]) {
    var increases = 0
    var previous: Int?
    for num in nums {
        if previous != nil, num > previous! {
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
        windowSum += num
        if i >= WINDOW_SIZE {
            windowSum -= nums[i - WINDOW_SIZE]
            if windowSum > prevWindowSum {
                increases += 1
            }
        }
    }
    print("Part 2 sliding window increases: \(increases)")
}

let contents = try! String(contentsOfFile: "./data/day01.txt")
let nums = contents.components(separatedBy: .newlines).map(Int.init)
print("read data")
part1(nums: nums)
part2(nums: nums)
