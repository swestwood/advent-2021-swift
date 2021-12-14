import Foundation

let contents = try! String(contentsOfFile: "./data/" + #file.prefix(".swift".count).lowercased() + "txt"

// let lines = contents.components(separatedBy: .newlines).map { Array($0).compactMap { Int(String($0))! }}
