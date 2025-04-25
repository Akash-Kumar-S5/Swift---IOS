import SwiftUI

struct sumOfDigitsView: View {
    @State var digits: Int? = nil
    @State @sumOfDigits var sum: Int = 0
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cross")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Sum Of Digits")
            
            
            TextField("Enter digits", value: $digits, format: .number)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .padding()
        
            Button("Convert"){
                sum = digits ?? 0
            }
            .buttonStyle(.borderedProminent)
           
            if sum > 0 {
                Text("Sum of digits: \(sum)")
            }
        }
        .padding()
    }
}

#Preview {
    sumOfDigitsView()
}

@propertyWrapper
struct sumOfDigits {
    private var digits: Int
    var wrappedValue: Int {
        set {
            digits = newValue
        }
        get {
            return Int(String(digits).reduce(into: 0) { result, char in
                result += Int(String(char)) ?? 0
            })
        }
    }
    init(wrappedValue: Int) {
        digits = wrappedValue
    }
}
