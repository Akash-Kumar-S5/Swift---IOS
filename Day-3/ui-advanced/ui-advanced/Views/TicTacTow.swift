//
//  TicTacTow.swift
//  ui-advanced
//
//  Created by Akash Kumar S on 25/04/25.
//
import SwiftUI

struct TicTacTow: View{
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Tic-Tac-Toe")
                .font(.largeTitle)
                .bold()
            
            Text("Current: X")
                .font(.title2)
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(0..<9) { idx in
                    Text(String(idx)).padding()
                }
            }
            .padding()
            
            Button("Reset Game"){
                
            }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
        }
        .padding()
    }
}

enum Player {
    case x, o
    
    var symbol: String { self == .x ? "X" : "O" }

    var next: Player { self == .x ? .o : .x }
}



#Preview {
    TicTacTow()
}
