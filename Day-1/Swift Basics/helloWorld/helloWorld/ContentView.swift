//
//  ContentView.swift
//  helloWorld
//
//  Created by Akash Kumar S on 22/04/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("lovely world")
                .padding()
                .background(Color.red, in: RoundedRectangle(cornerRadius: 99))
            
            Button("Button") {
                
            }
            .padding()
            .background(Color.yellow, in: RoundedRectangle(cornerRadius: 99))
            
            
            Text("Above the World")
                .padding()
                .background(Color.green, in: RoundedRectangle(cornerRadius: 99))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
