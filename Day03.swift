import Foundation

func part1(_ report: [String]) {
    let entryLength = report[0].count
    // Count up how many 1s are at each position
    var sums = Array(repeating: 0, count: entryLength)
    for entry in report {
        for i in 0 ..< entry.count {
            sums[i] += numberAtIndex(entry, i)
        }
    }
    // If more than half of a position was ones, that position ends up one
    var gamma = 0
    var epsilon = 0
    let half = report.count / 2
    for (i, sum) in sums.enumerated() {
        let powerOfTwo = Int(pow(Double(2), Double(entryLength - i - 1)))
        if sum > half {
            gamma += powerOfTwo
        } else {
            epsilon += powerOfTwo
        }
    }
    print(sums)
    print(gamma)
    print(epsilon)
    print("Gamma times epsilon: \(gamma * epsilon)")
}

func binaryValue(_ str: String) -> Int {
    // Take a string like "11001" and convert it to an int
    var total = 0
    for i in 0 ..< str.count {
        let val = numberAtIndex(str, i)
        if val == 1 {
            let powerOfTwo = Int(pow(Double(2), Double(str.count - i - 1)))
            total += powerOfTwo
        }
    }
    return total
}

func numberAtIndex(_ str: String, _ i: Int) -> Int {
    // Cast str[i] to an int
    return Int(String(str[str.index(str.startIndex, offsetBy: i)]))!
}

func getPopular(_ entries: Set<String>, _ position: Int, reverse: Bool = false) -> Set<String> {
    // Look at each entry and return only the entries that have a 1 or 0 at that position,
    // depending on whether 1 or 0 is more popular amongst all the entries in the set.
    // Reverse returns entries with the unpopular number instead.
    if entries.count == 1 {
        return entries
    }
    var ones = Set<String>()
    var zeros = Set<String>()
    var count = 0
    for item in entries {
        if numberAtIndex(item, position) == 0 {
            zeros.insert(item)
        } else {
            ones.insert(item)
            count += 1
        }
    }
    let moreOnes = count * 2 >= entries.count // 1s win ties
    if moreOnes {
        return reverse ? ones : zeros
    }
    return reverse ? zeros : ones
}

func part2(_ entries: [String]) {
    let entryLength = entries[0].count
    var oxygenRating = 0
    var co2Rating = 0
    var popular = Set(entries)
    var uncommon = Set(entries)
    for i in 0 ..< entryLength {
        popular = getPopular(popular, i)
        uncommon = getPopular(uncommon, i, reverse: true)
        if popular.count == 1 {
            let oxygen = popular.sorted()[0]
            oxygenRating = binaryValue(oxygen)
            print("Oxygen generator rating: \(oxygen) = \(oxygenRating)")
        }
        if uncommon.count == 1 {
            let co2 = uncommon.sorted()[0]
            co2Rating = binaryValue(co2)
            print("CO2 scrubber rating: \(co2) = \(co2Rating)")
        }
    }
    print("oxygen * co2 rating = \(oxygenRating * co2Rating)")
}

let contents = try! String(contentsOfFile: "./data/day03.txt")
let entries = contents.components(separatedBy: .newlines)

print("read data")
part1(entries)
part2(entries)
