//
//  unitTestingApp.swift
//  unitTesting
//
//  Created by Akash Kumar S on 29/04/25.
//

import SwiftUI

@main
struct unitTestingApp: App {
    var body: some Scene {
        WindowGroup {
            PostListView(viewModel: PostViewModel())
        }
    }
}
