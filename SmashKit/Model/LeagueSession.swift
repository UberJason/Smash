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
    public var numberOfGroups: Int? { return groupResults?.count }
    public var numberOfPlayers: Int? { return groupResults?.map { $0.players }.flatMap { $0 }.count }
    
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
            let results = groupResultsCD?.allObjects as? [GroupResult]
            return results?.count == 0 ? nil : results
        }
        set {
            if let newValue = newValue {
                addToGroupResultsCD(NSSet(array: newValue))
            }
        }
    }
    
    public var containsResults: Bool {
        return groupResults != nil
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
        return groupResults?.filter { $0.players.contains { $0 == player } }.first
    }
}

extension LeagueSession {
    public static func ==(lhs: LeagueSession, rhs: LeagueSession) -> Bool {
        return lhs.date == rhs.date && lhs.reportURL == rhs.reportURL
    }
}

