import Foundation

struct Point {
    var x: Int
    var y: Int
}

struct Line {
    var start: Point
    var end: Point
    var isHorizontal: Bool {
        return start.y == end.y
    }

    var isVertical: Bool {
        return start.x == end.x
    }

    var isForwardDiagonal: Bool {
        // Shaped like /
        return start.x - end.x == (start.y - end.y) * -1
    }

    var isBackDiagonal: Bool {
        // Shaped like \
        return start.x - end.x == start.y - end.y
    }

    var maxX: Int {
        return max(start.x, end.x)
    }

    var maxY: Int {
        return max(start.y, end.y)
    }

    var minX: Int {
        return min(start.x, end.x)
    }

    var minY: Int {
        return min(start.y, end.y)
    }
}

func printDiagram(_ diagram: [[Int]]) {
    for row in diagram {
        print(row)
    }
}

let contents = try! String(contentsOfFile: "./data/day05.txt")
let vents = contents.components(separatedBy: .newlines)
var lines: [Line] = []
for vent in vents {
    let points = vent.components(separatedBy: " -> ")
    let start = points[0].components(separatedBy: ",").compactMap(Int.init)
    let end = points[1].components(separatedBy: ",").compactMap(Int.init)
    lines.append(Line(start: Point(x: start[0], y: start[1]), end: Point(x: end[0], y: end[1])))
}

let maxX = (lines.max { $0.maxX < $1.maxX })!.maxX
let maxY = (lines.max { $0.maxY < $1.maxY })!.maxY
print(maxX)
print(maxY)

// Upper left is 0, 0, lower right is maxX, maxY. indexed by [row][col] aka [y][x]
var diagram: [[Int]] = []
for _ in 0 ... maxY {
    diagram.append(Array(repeating: 0, count: maxX + 1))
}

// printDiagram(diagram)

for line in lines {
    if line.isHorizontal {
        let row = line.start.y
        for col in line.minX ... line.maxX {
            diagram[row][col] += 1
        }
    }
    if line.isVertical {
        let col = line.start.x
        for row in line.minY ... line.maxY {
            diagram[row][col] += 1
        }
    }
    if line.isBackDiagonal {
        // line is shaped like "\", start at upper left and go to lower right
        var col = line.minX
        for row in line.minY ... line.maxY {
            diagram[row][col] += 1
            col += 1 // Keep up with the 45 deg change
        }
    }
    if line.isForwardDiagonal {
        // line is shaped like "/", start from upper right and go to lower left
        var col = line.maxX
        for row in line.minY ... line.maxY {
            diagram[row][col] += 1
            col -= 1 // Keep up with the 45 deg change
        }
    }
}

// printDiagram(diagram)

var overlaps = 0
for r in diagram {
    for num in r {
        if num > 1 {
            overlaps += 1
        }
    }
}

print("number of overlapping points: \(overlaps)")
