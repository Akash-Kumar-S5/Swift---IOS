struct Point {
    var x: Double
    var y: Double
    var z: Double = 0
}

var p1 = Point(x: 1.0, y: 2.0)
print(p1)

// constructor
class Vehicle {
    var make: String
    var year: Int

    init(make: String, year: Int) {
        self.make = make
        self.year = year
    }
    
    func result() -> String {
        return make + " " + String(year)
    }
}

let car1 = Vehicle(make: "Toyota", year: 2020)
print(car1.make)
print(car1.result())


//generic
func swapValues<T>(_ a: inout T, _ b: inout T) {
    let tmp = a; a = b; b = tmp
}

var x = 1, y = 2
swapValues(&x, &y) 
