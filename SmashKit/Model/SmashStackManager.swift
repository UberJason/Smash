//
//  SmashStackManager.swift
//  SmashKit
//
//  Created by Jason Ji on 3/1/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation
import CoreData
import CoreDataStackManager

public class SmashStackManager: CoreDataStackManager {
    
    public static let shared = SmashStackManager()
    
    private init() {
        super.init(modelName: "Model", storeType: NSSQLiteStoreType, bundle: Bundle(for: type(of: self)), storeLocation: .standard)
    }
    
    public func allLeagueSessions() -> [LeagueSession]? {
        let fetchRequest: NSFetchRequest<LeagueSession> = LeagueSession.fetchRequest()
        return try? SmashStackManager.shared.managedObjectContext.fetch(fetchRequest).filter { $0.date != nil }.sorted { $0.date! > $1.date! }
    }
}
