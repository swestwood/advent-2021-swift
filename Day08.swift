import Foundation

// Maps from # of segments to the number
let unique = [2: 1, 4: 4, 3: 7, 7: 8]

func part1(_ data: [[String]]) {
    let outputs = data.map { $0[1].components(separatedBy: " ") }
    var numUnique = 0
    for output in outputs {
        for entry in output {
            if unique[entry.count] != nil {
                numUnique += 1
            }
        }
    }
    print("num unique is \(numUnique)")
}

func normalize(_ entry: String) -> String {
    return String(entry.sorted())
}

func onlyMember(_ set: Set<Character>) -> String {
    return String(Array(set)[0])
}

func part2(_ data: [[String]]) {
    var sum = 0
    for line in data {
        print("\(line) = \(decode(line))")
        sum += decode(line)
    }
    print("total output sum: \(sum)")
}

func allIdentified(_ mapping: [String: String]) -> Set<Character> {
    return Set(mapping.keys.map { Character($0) })
}

func decode(_ line: [String]) -> Int {
    let input = line[0].components(separatedBy: " ")
    let output = line[1].components(separatedBy: " ")

    var counts: [Int: [String]] = [:]
    // Build up a map of {2: ['ab'], 3: 'abc'} etc
    for entry in input {
        let normalized = normalize(entry)
        if counts[normalized.count] == nil {
            counts[normalized.count] = []
        }
        if !counts[normalized.count]!.contains(normalized) {
            counts[normalized.count]!.append(normalized)
        }
    }

    /*
      Map each letter to its canonical letter in this arrangement:
       dddd
      e    a
      e    a
       ffff
      g    b
      g    b
       cccc
     */
    var mapping: [String: String] = [:]
    var decoder: [String: Int] = [:] // Map from normalized string to represented int
    // first look at the 1s, to figure out what maps to a and b
    // then look at 7 (length 3), now we have d (top)
    let oneStr = counts[2]![0]
    let sevenStr = counts[3]![0]
    let fourStr = counts[4]![0]
    let eightStr = counts[7]![0]
    decoder[oneStr] = 1
    decoder[sevenStr] = 7
    decoder[fourStr] = 4
    decoder[eightStr] = 8
    let oneSet = Set(oneStr)
    let sevenSet = Set(sevenStr)
    let fourSet = Set(fourStr)
    let eightSet = Set(eightStr)
    mapping[onlyMember(sevenSet.subtracting(oneSet))] = "d" // top

    // next look at length 6 = 6s and 9s and 0s
    // one of these has all but one, contained in the 1 a/b list -- that segment is a (top right) the other is b (bottom right)
    // the other two one have both a and b but missing one other segment -- that is g (bottom left) for 9 and f (middle) for zero.
    // look at 4 (unique) to determine which is which.

    // [7: ["abcdefg"], 4: ["acdg"], 5: ["abdef", "abcde", "abceg"], 3: ["cde"], 6: ["bcdefg", "abcdeg", "abcefg"], 2: ["cd"]]

    // ["f": "g",
    // "e": "d"
    // "a": "f"
    // "d": "a" x
    // "c": "c"]
    for lengthSix in counts[6]! {
        let lengthSixSet = Set(lengthSix)
        if lengthSixSet.intersection(oneSet).count == 2 {
            if lengthSixSet.intersection(fourSet).count == 4 {
                // Nine
                decoder[lengthSix] = 9
                mapping[onlyMember(eightSet.subtracting(lengthSixSet))] = "g" // bottom left

            } else {
                // Zero
                decoder[lengthSix] = 0
                mapping[onlyMember(eightSet.subtracting(lengthSixSet))] = "f" // middle
            }
        } else {
            // Six
            decoder[lengthSix] = 6
            mapping[onlyMember(eightSet.subtracting(lengthSixSet))] = "a" // top right
            mapping[onlyMember(oneSet.intersection(lengthSixSet))] = "b" // bottom right
        }
    }
    // now we have a, b, d, g, f. still need bottom and left top.
    // left top is just whatever in 4 is not yet identified.
    // bottom is whatever remains that is unidentified. (don't even need to look at length 5s)
    mapping[onlyMember(fourSet.subtracting(allIdentified(mapping)))] = "e" // top left
    mapping[onlyMember(eightSet.subtracting(allIdentified(mapping)))] = "c" // bottom

    assert(mapping.count == 7, "Uh oh - mapping is missing an entry \(mapping) \(counts)")

    // now we are done figuring out the mapping, add 2, 3, 5 to the decoder
    for lengthFive in counts[5]! {
        // get the normalized canonical string for this normalized uncanonical string
        let result = normalize(lengthFive.map { mapping[String($0)]! }.joined())
        if result == "abcdf" {
            // Three
            decoder[lengthFive] = 3
        } else if result == "acdfg" {
            // Two
            decoder[lengthFive] = 2

        } else {
            // Five
            decoder[lengthFive] = 5
        }
    }
    // print(mapping)
    // print(decoder)

    // now decode the output
    var outputNumber = 0
    var multiplier = 1000
    for entry in output {
        let digit = decoder[normalize(entry)]!
        outputNumber += digit * multiplier
        multiplier /= 10
    }
    return outputNumber
}

let data = try! String(contentsOfFile: "./data/day08.txt").components(separatedBy: .newlines).map { $0.components(separatedBy: " | ") }

part1(data)
part2(data)
