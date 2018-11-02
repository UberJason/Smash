//
//  ScorekeepingSession.swift
//  SmashKit
//
//  Created by Jason Ji on 11/1/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation
import CoreData

public class ScorekeepingSession: NSManagedObject {
    public convenience init(matches: [Match], managedObjectContext: NSManagedObjectContext) {
        self.init(context: managedObjectContext)
        addToMatchesCD(NSSet(array: matches))
    }
    
    public var matches: [Match]? {
        get {
            let matches = matchesCD?.allObjects as? [Match]
            return matches?.count == 0 ? nil : matches
        }
        set {
            if let newValue = newValue {
                addToMatchesCD(NSSet(array: newValue))
            }
        }
    }
    
    public var date: Date? {
        get {
            return dateCD
        }
        set {
            dateCD = newValue
        }
    }
}
