import Foundation
import SwiftUI

//struct Event: Codable {
//    let name: String
//    let date: Date
//}
//
//let event = Event(name: "Swift Conference", date: Date())
//
//do {
//    let jsonData = try JSONEncoder().encode(event)
//    let jsonString = String(data: jsonData, encoding: .utf8)
//    print(jsonString ?? "Unable to convert to string")
//} catch {
//    print("Encoding failed: \(error)")
//}

// set as well as directory
struct Product: Hashable {
    let id: Int
    let name: String
}
let p1 = Product(id: 1, name: "MacBook")
let p2 = Product(id: 1, name: "MacBook")

let products: Set = [p1, p2]
print(products.count)

//Comparing values for UI updates or conditions
struct Point: Equatable {
    let x: Int
    let y: Int
}

let p11 = Point(x: 1, y: 2)
let p12 = Point(x: 1, y: 2)

print(p11 == p12)

struct Task: Identifiable {
    let id = UUID()
    let title: String
}

let tasks = [
    Task(title: "Buy Milk"),
    Task(title: "Submit Report")
]

List(tasks) { task in
    Text(task.title)
}

struct Book: CustomStringConvertible {
    let title: String
    var description: String {
        return "📘 \(title)"
    }
}

print(Book(title: "Swift Mastery"))
