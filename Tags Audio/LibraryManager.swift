//
//  LibraryManager.swift
//  Tags Audio
//
//  Created by Ramon Kelvin on 04/10/24.
//
import SwiftUI

class LibraryManager: ObservableObject {
    @Published var musics: [Music] = []
    var persistenceManager: PersistanceManager? = nil
    
    func getPersistedData() {
        if let pm = self.persistenceManager {
            if let musics = try? pm.fetchMusics() {
                self.musics = musics
            }
        }
    }
    
    func addMusic(path: (URL)) {
        let newMusic: Music = Music(name: path.deletingPathExtension().lastPathComponent , path: path.absoluteString)
        self.musics.append(newMusic)
        self.musics.sort(by: {$1.name > $0.name})
        
        if let pm = self.persistenceManager {
            try? pm.addMusic(music: newMusic)
        }
        
    }
    
    func deleteMusic(music: Music) {
        self.musics.removeAll(where: {$0.id == music.id})
        
        if let pm = self.persistenceManager {
            try? pm.deleteMusic(music: music)
        }
    }
    
    func editMusic(music: Music, newName: String) {
        let theOne = self.musics.first(where: {$0.id == music.id})
        theOne?.name = newName
        
        if let pm = persistenceManager {
            if let chosen = theOne {
                try? pm.updateMusic(music: chosen)
            }
            
        }
    }
    
}
