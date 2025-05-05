import Foundation

print("1. Start - \(Thread.isMainThread ? "Main Thread" : "Background Thread")")

// Main queue (runs on the main thread)
DispatchQueue.main.async {
    print("2. On Main Queue - \(Thread.isMainThread ? "Main Thread" : "Background Thread")")
}

//  Global queue (background thread)
DispatchQueue.global().async {
    print("3. On Background Queue - \(Thread.isMainThread ? "Main Thread" : "Background Thread")")
}

//  Custom serial queue
let customSerialQueue = DispatchQueue(label: "com.example.serial")
customSerialQueue.async {
    print("4. Custom Serial Queue - \(Thread.isMainThread ? "Main Thread" : "Background Thread")")
}

//  Custom concurrent queue
let customConcurrentQueue = DispatchQueue(label: "com.example.concurrent", attributes: .concurrent)
customConcurrentQueue.async {
    print("5. Custom Concurrent Queue - \(Thread.isMainThread ? "Main Thread" : "Background Thread")")
}

print("6. End")

@MainActor func printMainActor() {
    print("7. MainActor - \(Thread.isMainThread ? "Main Thread" : "Background Thread")")
}

printMainActor()


//print("1. Start - \(Date())")
//
//DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//    print("2. Delayed on Main Queue - \(Date())")
//}
//
//DispatchQueue.global().async {
//    print("3. Background Task - \(Date())")
//}
//
//print("4. End - \(Date())")
