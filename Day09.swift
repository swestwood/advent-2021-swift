import Foundation

func isGreaterOrEqual(_ rows: [[Int]], _ val: Int, _ r: Int, _ c: Int) -> Bool {
    if !inRange(r: r, c: c, rows: rows) {
        return false
    }
    return val >= rows[r][c]
}

let NWSE = [[-1, 0], [1, 0], [0, 1], [0, -1]]

func isLowPoint(_ rows: [[Int]], _ r: Int, _ c: Int) -> Bool {
    let val = rows[r][c]
    for change in NWSE {
        if isGreaterOrEqual(rows, val, r + change[0], c + change[1]) {
            return false
        }
    }
    return true
}

func part1(_ rows: [[Int]]) {
    var sum = 0
    var numLowPoints = 0
    for r in 0 ..< rows.count {
        for c in 0 ..< rows[r].count {
            if isLowPoint(rows, r, c) {
                numLowPoints += 1
                sum += 1 + rows[r][c]
                // print("found low point at \(r) \(c) \(rows[r][c])")
            }
        }
    }
    print("num low points: \(numLowPoints) with risk \(sum)")
}

struct Point: Hashable {
    let r: Int
    let c: Int
}

func inRange(r: Int, c: Int, rows: [[Int]]) -> Bool {
    return !(r < 0 || c < 0 || r >= rows.count || c >= rows[0].count)
}

func getBasinSize(_ rows: [[Int]], _ point: Point, _ startSize: Int, _ explored: inout Set<Point>) -> Int {
    if explored.contains(point) || !inRange(r: point.r, c: point.c, rows: rows) {
        return startSize
    }
    if rows[point.r][point.c] == 9 {
        return startSize // barrier
    }
    explored.insert(point)
    var size = startSize
    size += 1
    for change in NWSE {
        size = getBasinSize(rows, Point(r: point.r + change[0], c: point.c + change[1]), size, &explored)
    }
    explored.insert(point)
    return size
}

func part2(_ rows: [[Int]]) {
    // find the lowpoint, then count the size of its basin
    var basins: [Int] = []
    for r in 0 ..< rows.count {
        for c in 0 ..< rows[r].count {
            if isLowPoint(rows, r, c) {
                var explored = Set<Point>()
                let basinSize = getBasinSize(rows, Point(r: r, c: c), 0, &explored)
                basins.append(basinSize)
            }
        }
    }
    let biggestBasins = basins.sorted(by: >)
    let product = biggestBasins[0] * biggestBasins[1] * biggestBasins[2]
    print("product of 3 biggest basins: \(product)")
}

let contents = try! String(contentsOfFile: "./data/day09.txt")
let rows = contents.components(separatedBy: .newlines).map { Array($0).compactMap { Int(String($0))! }}

part1(rows)
part2(rows)
