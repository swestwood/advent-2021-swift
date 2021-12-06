import Foundation

struct Board {
    var id: Int
    var rows: [[Int]]
    func won(drawn: Set<Int>) -> Bool {
        // Check if any of the rows are all contained in the drawn numbers
        for r in rows {
            var wonRow = true
            for num in r {
                if !drawn.contains(num) {
                    wonRow = false
                    break
                }
            }
            if wonRow {
                return true
            }
        }
        // Check if any of the cols are all contained in the drawn numbers
        for c in 0 ..< rows[0].count {
            var wonCol = true
            for r in rows {
                if !drawn.contains(r[c]) {
                    wonCol = false
                    break
                }
            }
            if wonCol {
                return true
            }
        }
        return false
    }

    func score(drawn: Set<Int>, lastDrawn: Int) -> Int {
        var score = 0
        for r in rows {
            for num in r {
                if !drawn.contains(num) {
                    score += num
                }
            }
        }
        return score * lastDrawn
    }
}

func part1(boards: [Board], draws: [Int]) {
    var drawn = Set<Int>()
    for draw in draws {
        drawn.insert(draw)
        for board in boards {
            if board.won(drawn: drawn) {
                print("won!")
                print(board.score(drawn: drawn, lastDrawn: draw))
                return
            }
        }
    }
}

func part2(boards: [Board], draws: [Int]) {
    var drawn = Set<Int>()
    var wonBoards = Set<Int>()
    for draw in draws {
        drawn.insert(draw)
        for board in boards {
            if wonBoards.contains(board.id) {
                // Ignore this board, it's already won
                continue
            }
            if board.won(drawn: drawn) {
                // This is the last board to win
                if wonBoards.count == boards.count - 1 {
                    print("the last board to win!")
                    print(board.score(drawn: drawn, lastDrawn: draw))
                    return
                }
                wonBoards.insert(board.id)
            }
        }
    }
}

let contents = try! String(contentsOfFile: "./data/day04.txt")
let entries = contents.components(separatedBy: .newlines)
let draws = entries[0].components(separatedBy: ",").map { Int($0)! }
var boards: [Board] = []
var rows: [[Int]] = []
var id = 0
for i in 2 ... entries.count {
    // Append the last board, don't miss the last one in the file
    if i == entries.count || entries[i] == "" {
        boards.append(Board(id: id, rows: rows))
        rows = []
        id += 1
        continue
    }
    rows.append(entries[i].components(separatedBy: .whitespaces).compactMap(Int.init))
}

print("read data")
print("Part 1")
part1(boards: boards, draws: draws)
print("Part 2")
part2(boards: boards, draws: draws)
