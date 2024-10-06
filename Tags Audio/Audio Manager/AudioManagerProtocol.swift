//
//  AudioManagerProtocol.swift
//  Tags Audio
//
//  Created by Ramon Kelvin on 01/10/24.
//

import Foundation

protocol AudioManagerProtocol {
    var isPlaying: Bool { get set }
    var timeStamps: [TimeStamp] { get set }
    
    func addTimeStamp()
    func removeTimeStamp(at timestamp: TimeStamp)
    func updateTimeStamp(timeStamp: TimeStamp, newname: String)
    
    func setup()
    func play()
    func updatetTime()
    func seekAudio(to time: TimeInterval)
    func pause()
    func stop()
}
