import UIKit
import Foundation

var greeting = "Hello, playground"
print(greeting)

var x: Int
x=10
x += 1
print(x)

// if condition

if x == 11 {
    print("greater than")
} else {
    print( "less than")
}


// guard
func greet(_ name: String?) {
    guard let name = name, !name.isEmpty else {
        print("No name provided.")
        return
    }
    print("Hello, \(name)!")
}
greet("")
greet("akash")

// switch (with tuples & ranges)
let point = (x: 90, y: 0)
switch point {
case (0, 0):
    print("Origin")
case (_, 0):
    print("On the x-axis")
case (0, _):
    print("On the y-axis")
case (-2...2, -2...2):
    print("Inside the box")
default:
    print("Outside the box")
}

// for-in over a range
for i in 1...5 {
    print(i)
}

// for-in over a collection
let names = ["Anna", "Brian", "Craig"]
for name in names {
    print("Hello, \(name)!")
}

// while / repeat‑while
var count = 3
while count > 0 {
    print(count)
    count -= 1
}
repeat {
    print("Liftoff!")
} while count > 0

// Array
var fruits: [String] = ["Apple", "Banana", "Cherry"]
fruits.append("Date")
let first = fruits[0]       // "Apple"

// Dictionary
var ages: [String: Int] = ["Alice": 30, "Bob": 25]
ages["Charlie"] = 22
if let aliceAge = ages["Alice"] {
    print("Alice is \(aliceAge).")
}

// Set
var uniqueNumbers: Set<Int> = [1, 2, 3, 2, 1]
uniqueNumbers.insert(4)     // now {1,2,3,4}
for n in uniqueNumbers {
    print(n)
}

// Common operations
let evenFruits = fruits.filter { $0.count % 2 == 0 }
let nameList = ages.keys.sorted()
let total = uniqueNumbers.reduce(0, +)
