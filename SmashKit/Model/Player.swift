//
//  Player.swift
//  SmashKit
//
//  Created by Jason Ji on 2/23/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation
import CoreData
import SmashUIKit

public class Player: NSManagedObject {
    public var name: String {
        get {
            return nameCD ?? ""
        }
        set {
            nameCD = newValue
        }
    }
    
    public var initials: String? {
        get {
            return initialsCD
        }
        set {
            initialsCD = newValue
        }
    }
    
    public var profileImage: UIImage? {
        get {
            guard let profileImageData = profileImageCD else { return nil }
            return UIImage(data: profileImageData)
        }
        set {
            if let newValue = newValue {
                profileImageCD = UIImageJPEGRepresentation(newValue, 1.0)
            }
            else {
                profileImageCD = nil
            }
        }
    }
    
    public convenience init(name: String, managedObjectContext: NSManagedObjectContext) {
        self.init(context: managedObjectContext)
        self.name = name
        
        // Just for me :)
        if name == "Jason Ji" {
            initials = "JJ"
            profileImage = UIImage(named: "jason", in: Bundle.smashUIKit, compatibleWith: nil)
        }
    }
}

public func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.name == rhs.name
}
public func !=(lhs: Player, rhs: Player) -> Bool {
    return lhs.name != rhs.name
}
