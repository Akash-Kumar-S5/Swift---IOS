//import Foundation
//
//print("1")
//print("outside Task", Thread.isMainThread ? "on main" : "off main")
//Task() {
////    try? await Task.sleep(nanoseconds: 1_000_000_000)
//    print("2")
//    print("Inside Task", Thread.isMainThread ? "on main" : "off main")
//}
//print("3")
//
//func fetchData() async -> String {
//    // Simulate network delay
////    try? await Task.sleep(nanoseconds: 1_000_000_000)
//    return "Sample Data"
//}
//Task.detached {
//    let result = await fetchData()
//    print("Data fetched: \(result)")
//}
//
//let task = Task {
//    await performCancellableTask()
//}
//
//task.cancel()
//
//// Asynchronous function that checks for cancellation
//func performCancellableTask() async {
//    for i in 1...10 {
//        if Task.isCancelled {
//            print("Task was cancelled")
//            return
//        }
//        print("Processing \(i)")
//        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
//    }
//}

//import Foundation
////
////// MARK: 1. Fire-and-forget child Task
//Task {
//    print("[1] Fire-and-forget:", Thread.isMainThread ? "on main" : "off main")
//}
//
//// MARK: 2. Value-returning Task
//let valueTask = Task<Int, Never> {
////    try? await Task.sleep(nanoseconds: 300_000_000)
//    return 42
//}
//Task {
//    let answer = await valueTask.value
//    print("[2] Returned value:", answer)
//}
//
//// MARK: 3. Detached Task (unstructured)
//Task.detached {
//    print("[3] Detached:", Thread.isMainThread ? "on main" : "off main")
//}
//
//// MARK: 4. Task with explicit priority
//Task(priority: .high) {
//    print("[4] High-priority task")
//}
//
//// MARK: 5. TaskGroup for parallel work
//Task {
//    let words = ["apple", "banana", "cherry"]
//    let results = await withTaskGroup(of: String.self) { group in
//        for w in words {
//            group.addTask { w.uppercased() }
//        }
//        var out = [String]()
//        for await up in group {
//            out.append(up)
//        }
//        return out
//    }
//    print("[5] TaskGroup results:", results)
//}
//
//// MARK: 6. @MainActor Task
//@MainActor func updateUI() {
//    print("[6] UI update on main:", Thread.isMainThread)
//}
//Task { updateUI() }
//
//// MARK: 7. Cancellable Task
//let cancelable = Task {
//    for i in 1...5 {
//        try Task.checkCancellation()
//        print("[7] Step", i)
//        try await Task.sleep(nanoseconds: 200_000_000)
//    }
//    print("[7] Completed all steps")
//}
//DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//    cancelable.cancel()
//    print("[7] Requested cancellation")
//}

//Mark- Priority Examples
import Foundation

// Simulate a time-consuming task
func simulateWork(taskName: String, duration: UInt64) async {
    print("Started \(taskName) on thread: \(Thread.isMainThread)")
    try? await Task.sleep(nanoseconds: duration)
    print("Finished \(taskName) on thread: \(Thread.isMainThread)")
}

// Launch tasks with varying priorities
func runTasksWithDifferentPriorities() {
    Task(priority: .background) {
        await simulateWork(taskName: "Background Task", duration: 1_000_000_000)
    }

    Task(priority: .utility) {
        await simulateWork(taskName: "Utility Task", duration: 1_000_000_000)
    }

    Task(priority: .userInitiated) {
        await simulateWork(taskName: "User Initiated Task", duration: 1_000_000_000)
    }

    Task(priority: .high) {
        await simulateWork(taskName: "High Priority Task", duration: 1_000_000_000)
    }

    Task(priority: .medium) {
        await simulateWork(taskName: "Medium Priority Task", duration: 1_000_000_000)
    }

    Task(priority: .low) {
        await simulateWork(taskName: "Low Priority Task", duration: 1_000_000_000)
    }
    
    Task.detached {
        await simulateWork(taskName: "detached", duration: 1_000_000_000)
    }
}

// Entry point
runTasksWithDifferentPriorities()

//// Keep the main thread alive to allow asynchronous tasks to complete
//RunLoop.main.run(until: Date().addingTimeInterval(5))
