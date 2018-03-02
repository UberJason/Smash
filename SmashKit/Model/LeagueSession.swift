//
//  Session.swift
//  SmashKit
//
//  Created by Jason Ji on 2/26/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation
import CoreData

public class LeagueSession: NSManagedObject {
    public var numberOfGroups: Int { return groupResults?.count ?? 0 }
    public var numberOfPlayers: Int { return groupResults?.map { $0.players }.flatMap { $0 }.count ?? 0 }
    
    public var date: Date? {
        get {
            return dateCD
        }
        set {
            dateCD = newValue
        }
    }
    public var reportURL: String? {
        get {
            return reportURLCD
        }
        set {
            reportURLCD = newValue
        }
    }
    
    public var groupResults: [GroupResult]? {
        get {
            return groupResultsCD?.allObjects as? [GroupResult]
        }
        set {
            if let newValue = newValue {
                addToGroupResultsCD(NSSet(array: newValue))
            }
        }
    }
    
    public convenience init(date: Date? = nil, reportURL: String? = nil, managedObjectContext: NSManagedObjectContext) {
        self.init(context: managedObjectContext)
        self.date = date
        self.reportURL = reportURL
    }
    
    public convenience init(date: Date?, groupResults: [GroupResult], managedObjectContext: NSManagedObjectContext) {
        self.init(context: managedObjectContext)
        self.date = date
        addToGroupResultsCD(NSSet(array: groupResults))
    }
    
    public func group(for player: Player) -> GroupResult? {
        return groupResults?.filter { $0.players.map { $0.name }.contains(player.name) }.first
    }
}

extension LeagueSession {
    public static func ==(lhs: LeagueSession, rhs: LeagueSession) -> Bool {
        return lhs.date == rhs.date && lhs.reportURL == rhs.reportURL
    }
}

