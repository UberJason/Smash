//
//  LeagueSessionCellExtension.swift
//  Smash
//
//  Created by Jason Ji on 3/2/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import UIKit
import SmashKit
import SmashUIKit

extension LeagueSessionCell {
    func configure(with leagueSession: LeagueSession) {
        guard let date = leagueSession.date else { return }
        let dateString = Parser.sessionLongDateFormatter.string(from: date)
        var subtitle = "Tap for details"
        if let numberOfPlayers = leagueSession.numberOfPlayers, let numberOfGroups = leagueSession.numberOfGroups {
            subtitle = "\(numberOfPlayers) Players | \(numberOfGroups) Groups"
        }
        
        configure(dateString: dateString, subtitle: subtitle)
    }
}
