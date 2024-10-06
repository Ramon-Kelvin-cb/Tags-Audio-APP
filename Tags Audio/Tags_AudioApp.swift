//
//  Tags_AudioApp.swift
//  Tags Audio
//
//  Created by Ramon Kelvin on 01/10/24.
//

import SwiftUI
import SwiftData
import AVFoundation

@main
struct Tags_AudioApp: App {
    var body: some Scene {
        WindowGroup {
//            RootView()
//                .modelContainer(for: [TimeStamp.self, Music.self])
            ContentView(AudioManager: AudioController(music: .init(name: "Música Robôs", path: "Demo Robo")))
                .modelContainer(for: [TimeStamp.self])
        }
        
    }
}
