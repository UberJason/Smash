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
    
    public var firstName: String {
        get {
            return String(name.split(separator: " ").first!)
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
                profileImageCD = newValue.jpegData(compressionQuality: 1.0)
            }
            else {
                profileImageCD = nil
            }
        }
    }
    
    public static func newOrExistingPlayer(name: String, managedObjectContext: NSManagedObjectContext) throws -> Player {
        let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
        let players = try managedObjectContext.fetch(fetchRequest)
        return players.filter { $0.name == name }.first ?? Player(name: name, managedObjectContext: managedObjectContext)
    }
    
    public convenience init(name: String, managedObjectContext: NSManagedObjectContext) {
        self.init(context: managedObjectContext)
        self.name = name
        
        #if os(iOS)
        // Just for me :)
        if name == "Jason Ji" {
            initials = "JJ"
            profileImage = UIImage(named: "jason", in: Bundle(for: type(of: self)), compatibleWith: nil)
        }
        #endif
    }
}

public func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.name == rhs.name
}
public func !=(lhs: Player, rhs: Player) -> Bool {
    return lhs.name != rhs.name
}
