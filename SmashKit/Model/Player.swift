//
//  Player.swift
//  SmashKit
//
//  Created by Jason Ji on 2/23/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation
import CoreData

public class Player: NSManagedObject {
    public var name: String {
        get {
            return nameCD ?? ""
        }
        set {
            nameCD = newValue
        }
    }
    
    public convenience init(name: String, managedObjectContext: NSManagedObjectContext) {
        self.init(context: managedObjectContext)
        self.name = name
    }
}

public func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.name == rhs.name
}
