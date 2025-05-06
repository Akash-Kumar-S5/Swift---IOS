import Combine

class SharedData {
    static let shared = SharedData()

    let subject = CurrentValueSubject<String, Never>("Initial from Subject")

    private init() {}
}
