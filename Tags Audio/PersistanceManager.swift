//
//  DatabaseProtocol.swift
//  Tags Audio
//
//  Created by Ramon Kelvin on 02/10/24

//  Persisting only the timestamps
import SwiftData
import Foundation

class PersistanceManager {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    //    Create
    func addTimestamp(timestamp: TimeStamp) throws {
        self.context.insert(timestamp)
    }
    
    
    //    Read
    func fetchTimeStamps(fromMusic musicName: String) throws -> [TimeStamp] {
        let request = FetchDescriptor<TimeStamp>(predicate: #Predicate {$0.musicName == musicName},
                                                 sortBy: [SortDescriptor(\.time, order: .forward)])
        return try self.context.fetch(request)
    }
    
    //    Update
    func updateTimestamp(timestamp: TimeStamp) throws {
        try context.save()
    }
    
    //    Delete
    func deleteTimestamp(timestamp: TimeStamp) throws {
        context.delete(timestamp)
        try context.save()
    }
    
    //    Create
    func addMusic(music: Music) throws {
        self.context.insert(music)
    }
    
    
    //    Read
    func fetchMusics() throws -> [Music] {
        let request = FetchDescriptor<Music>(sortBy: [SortDescriptor(\.name, order: .forward)])
        return try self.context.fetch(request)
    }
    
    //    Update
    func updateMusic(music: Music) throws {
        try context.save()
    }
    
    //    Delete
    func deleteMusic(music: Music) throws {
        context.delete(music)
        try context.save()
    }
    
}
