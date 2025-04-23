import Foundation

func greet(name: String) -> String {
    return "Hello, \(name)!"
}
let message = greet(name: "Akash")

func join(_ a: String, with b: String) -> String {
    return a + b
}
join("Hello, ", with: "World")

func add(firstNo a: Int, secondNo b: Int) -> Int {
    return a + b
}
add(firstNo: 10,secondNo: 20)

func power(_ base: Int, raisedTo exp: Int = 2) -> Int {
    return Int(pow(Double(base), Double(exp)))
}
print(power(3, raisedTo: 3))

func sum(_ numbers: Int...) -> Int {
    numbers.reduce(0, +)
}
sum(1, 2, 3, 4, 5)

let randomNo = [1, 3, 5, 7]
let result = randomNo.reduce(0, +)

func swapInts(_ a: inout Int, _ b: inout Int) { //can change the value from the variable
    let tmp = a; a = b; b = tmp
}
var x = 1, y = 2
swapInts(&x, &y)
print(x, y)

enum Direction: Int{
    case north = 1, south, east, west
}
let dir: Direction = .south
print(dir)
//print(Direction(rawValue: 2))

enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}
var code = Barcode.upc(8, 85909, 51226, 3)
//code = .qrCode("ABCDEFGHIJKLMNOP")
switch code {
    case .upc(let a, let b, let c, let d):
        print("UPC: \(a)-\(b)-\(c)-\(d)")
case .qrCode(let str):
        print("QR: \(str)")
}

enum Light {
    case red, yellow, green
    func action() -> String {
        switch self {
        case .red:    return "Stop"
        case .yellow: return "Caution"
        case .green:  return "Go"
        }
    }
}

print(Light.red.action())


//closure

let add: (Int, Int) -> Int = { (a: Int, b: Int) -> Int in
    return a + b
}
add(2, 3)

let mul:(Int, Int) -> Int = { (a, b) in a * b }
mul(3, 4)

let words = ["swift", "closure", "enum"]
let sorted = words.sorted { $0.count > $1.count }


func perform(task: () -> Void) {
    print("Before")
    task()
    print("After")
}
perform {
    print("Doing work")
}

var completions : [() -> Void] = []
@MainActor func register(completion: @escaping () -> Void) {
    completions.append(completion)
}

register {
    let word = "Hello, world!"
    print(word)
}

for i in completions {
    print(i)
}
