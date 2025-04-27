//
//  ui_advancedApp.swift
//  ui-advanced
//
//  Created by Akash Kumar S on 25/04/25.
//

import SwiftUI

@main
struct ui_advancedApp: App {
    @StateObject private var settings = UserSetting()
    var body: some Scene {
        WindowGroup {
//            MainTabView()
//            ContentsView().environmentObject(settings)
//            ColorAwareView()
//            AppStroagePreview()
            SceneStoragePreview()
        }
    }
}
