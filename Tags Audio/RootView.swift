//
//  RootView.swift
//  Tags Audio
//
//  Created by Ramon Kelvin on 03/10/24.
//
import SwiftUI
import AVFoundation

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    
    @ObservedObject var library : LibraryManager = LibraryManager()
    var player: AVAudioPlayer?
    
    @State private var importing: Bool = false
    @State private var url: URL?
    
    
    var body: some View {
        NavigationStack {
            Button("Import") {
                self.importing.toggle()
            }
            .fileImporter(
                isPresented: $importing,
                allowedContentTypes: [.mp3]) { result in
                    switch result {
                    case .success(let file):
                        library.addMusic(path: file)
                        var AudioManager: AudioController = AudioController(music: library.musics[0])
                        AudioManager.play()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            
//            List { ForEach(library.musics) { music in
//                NavigationLink(destination: ContentView(AudioManager: .init(music: music))) {
//                    Text(music.path)
//                }
//            }
              
            
            
            }.onAppear() {
            if library.persistenceManager == nil {
                library.persistenceManager = PersistanceManager(context: modelContext)
                library.getPersistedData()
            }
        }
    }
}

