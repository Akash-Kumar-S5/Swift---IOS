import UIKit
import Foundation

var greeting = "Hello, playground"
print(greeting)

var x: Int
x=10
x += 1
print(x)

// if condion

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
