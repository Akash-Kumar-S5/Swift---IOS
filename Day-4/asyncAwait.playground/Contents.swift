import Foundation
import SwiftUI

func orderPizza() async -> String {
    print("Placing order...")
    await Task.sleep(3 * 1_000_000_000) // Wait for 3 seconds
    return "Pizza is ready!"
}

func haveDinner() async {
    print("Starting dinner...")
    let pizza = await orderPizza()
    print(pizza)
    print("Dinner is served!")
}

//Task {
//    await haveDinner()
//}


let defaults = UserDefaults.standard

// Store values
defaults.set(true,  forKey: "hasOnboarded")
defaults.set(42,    forKey: "launchCount")
defaults.set("en",  forKey: "preferredLanguage")


let hasOnboarded      = defaults.bool(forKey: "hasOnboarded")
let launchCount       = defaults.integer(forKey: "launchCount")
let preferredLanguage = defaults.string(forKey: "preferredLanguage") ?? "en"

