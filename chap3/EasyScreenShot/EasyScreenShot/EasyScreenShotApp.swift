//
//  EasyScreenShotApp.swift
//  EasyScreenShot
//
//  Created by Nikolai Schlegel on 11/3/23.
//

import SwiftUI

@main
struct EasyScreenShotApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    private var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
