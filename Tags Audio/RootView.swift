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
    
    @State private var importing: Bool = false
    
    
    var body: some View {
        NavigationStack {
            Button("Import") {
                self.importing.toggle()
            }
            .fileImporter(
                isPresented: $importing,
                allowedContentTypes: [.audio]) { result in
                    switch result {
                    case .success(let file):
                        let canAcess = file.startAccessingSecurityScopedResource()
                        
                        if !canAcess {
                            print("Could not access file")
                            return
                        }
                        
                        library.addMusic(path: file)
                        file.stopAccessingSecurityScopedResource()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            
            
            List { ForEach(library.musics) { music in
                NavigationLink(destination: ContentView(AudioManager: .init(music: music))) {
                    Text(music.name)
                }
            }
                
                
                
            }.onAppear() {
                if library.persistenceManager == nil {
                    library.persistenceManager = PersistanceManager(context: modelContext)
                    library.getPersistedData()
                }
            }
        }
    }
}
