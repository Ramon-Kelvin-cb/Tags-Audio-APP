//
//  AudioController.swift
//  Tags Audio
//
//  Created by Ramon Kelvin on 01/10/24.
//
import Foundation
import AVKit
import SwiftUI
import SwiftData



class AudioController : AudioManagerProtocol, ObservableObject {
    var persistenceManager: PersistanceManager? = nil
    var music: Music
    
    @Published var isPlaying: Bool
    @Published var player: AVAudioPlayer?
    @Published var totalTime: TimeInterval = 0.0
    @Published var currentTime: TimeInterval = 0.0
    
    @Published var timeStamps: [TimeStamp]
    
    var audioName: String
    
    
    init(music: Music) {
        self.music = music
        self.audioName = music.name
        self.timeStamps = music.timeStamps
        
        self.isPlaying = false
        self.setup()
    }
    
    func getPersistedData() {
        if let pm = self.persistenceManager {
            if let ts = try? pm.fetchTimeStamps(fromMusic: self.music.name) {
                self.timeStamps = ts
            }
        }
    }
    
    func setup() {
        self.setupAudioSession()
        guard let url =  URL(string: self.music.path) else {
            print("Não teve sucesso na criação da URL")
            return
        }
        
        let _ = url.startAccessingSecurityScopedResource()

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            self.totalTime = player?.duration ?? 0.0
            
        } catch {
            print("Error loading audio: \(error)")
        }
        
        url.stopAccessingSecurityScopedResource()
    }
    
    func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // Configura a categoria do áudio
            try audioSession.setCategory(.playback, mode: .default, options: [])
            // Ativa a sessão de áudio
            try audioSession.setActive(true)
        } catch {
            print("Erro ao configurar a sessão de áudio: \(error)")
        }
    }
    
    func updatetTime() {
        guard let player = self.player else { return }
        self.currentTime = player.currentTime
    }
    
    func seekAudio(to time: TimeInterval){
        self.player?.currentTime = time
    }
    
    func addTimeStamp() {
        let timeStamp = TimeStamp(name: "", time: self.currentTime, timeMark: self.timeString(.current), musicName: self.music.name)
        self.timeStamps.append(timeStamp)
        self.timeStamps.sort(by: {$1.time > $0.time})
        
        if let pm = self.persistenceManager {
            try? pm.addTimestamp(timestamp: timeStamp)
        }
    }

    func removeTimeStamp(at timestamp: TimeStamp) {
        self.timeStamps.removeAll(where: {$0.id == timestamp.id})
        
        if let pm = self.persistenceManager {
            try? pm.deleteTimestamp(timestamp: timestamp)
        }
    }
    
    func updateTimeStamp(timeStamp: TimeStamp, newname: String) {
        let theOne = self.timeStamps.first(where: {$0.id == timeStamp.id})
        theOne?.name = newname
        
        if let pm = persistenceManager {
            if let chosen = theOne {
                try? pm.updateTimestamp(timestamp: chosen)
            }
            
        }
    }
    
    func play() {
        if self.isPlaying {
            return
        }
        
        self.player?.play()
        self.isPlaying.toggle()
    }
    
    func pause() {
        if !self.isPlaying {
            return
        }
        self.player?.pause()
        self.isPlaying.toggle()
    }
    
    func timeString(_ what: TimeType) -> String{
        let timeUsed = what == .total ? self.totalTime : self.currentTime
        
        let minutes = Int(timeUsed) / 60
        let seconds = Int(timeUsed) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func stop() {
        if !self.isPlaying {
            return
        }
        
        self.isPlaying.toggle()
        self.player?.stop()
    }
}


enum TimeType {
    case total
    case current
}
