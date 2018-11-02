//
//  ScorekeepingSession.swift
//  SmashKit
//
//  Created by Jason Ji on 11/1/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation
import CoreData


// TODO: Match CoreData object only stores wins/losses and the parsing matrix, not Game objects
// Eventually need to reconcile this data model
// For now, we make ScorekeepingSession keep a set of ScorekeepingMatch objects and none of this is in Core Data yet

public class ScorekeepingSession {
    public var matches = [ScorekeepingMatch]()
    public var date: Date
    
    public init(date: Date = Date()) {
        self.date = date
    }

}
