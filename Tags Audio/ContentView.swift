//
//  ContentView.swift
//  Tags Audio
//
//  Created by Ramon Kelvin on 01/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @ObservedObject var AudioManager : AudioController
    
    
    @State private var selecteedTimeStamp: TimeStamp?
    @State private var isEditing: Bool = false
    
        
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20){
                Text(AudioManager.audioName)
                    .font(.title)
                    .foregroundColor(.white)
                
                VStack(spacing: 20){
                    HStack {
                        Image(systemName: "flag")
                            .font(.largeTitle)
                            .colorInvert()
                            .onTapGesture {
                                AudioManager.addTimeStamp()
                            }
                        Spacer()
                        Image(systemName: AudioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.largeTitle)
                            .colorInvert()
                            .onTapGesture {
                                AudioManager.isPlaying ? AudioManager.pause() : AudioManager.play()
                            }
                    }
                    
                    Slider(value: Binding(get: {
                        AudioManager.currentTime
                    }, set: { newValue in
                        AudioManager.seekAudio(to: newValue)
                    }), in: 0...AudioManager.totalTime)
                    .accentColor(.white)
                    
                    
                    HStack {
                        Text(AudioManager.timeString(.current))
                            .foregroundColor(.white)
                        Spacer()
                        Text(AudioManager.timeString(.total))
                            .foregroundColor(.white)
                    }
                    
                    List{ ForEach(AudioManager.timeStamps) { timestamp in
                        Button(action: {AudioManager.seekAudio(to: timestamp.time)}) {
                            TimeStampRow(timeStamp: timestamp)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                selecteedTimeStamp = timestamp
                                isEditing.toggle()
                            } label: {Label("Edit", systemImage: "pencil")}
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                AudioManager.removeTimeStamp(at: timestamp)
                            } label: {Label("Delete", systemImage: "trash.fill")}
                        }
                    }
                    }
                    .sheet(isPresented: $isEditing, content: {
                        if let timestampToEdit = selecteedTimeStamp {
                            EditiTimeStampView(timestamp: $AudioManager.timeStamps[AudioManager.timeStamps.firstIndex(where: {$0.id == timestampToEdit.id})!],
                                               isEditing: $isEditing,
                                               manager: AudioManager)
                            .presentationDetents([.medium, .fraction(0.3)])
                        }
                    })
                    .cornerRadius(20)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                
            }
            .padding(30)
        }
        .onAppear {
            if AudioManager.persistenceManager == nil {
                AudioManager.persistenceManager = PersistanceManager(context: modelContext)
                AudioManager.getPersistedData()
            }
        }
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            AudioManager.updatetTime()
        }
    }
    
    
    
}

