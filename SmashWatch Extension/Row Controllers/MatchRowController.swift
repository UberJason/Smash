//
//  MatchRowController.swift
//  SmashWatch Extension
//
//  Created by Jason Ji on 11/2/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import WatchKit
import SmashKitWatch

class MatchRowController: NSObject {
    
    @IBOutlet weak var primaryLabel: WKInterfaceLabel!
    @IBOutlet weak var secondaryLabel: WKInterfaceLabel!
    
    func configure(with match: ScorekeepingMatch, number: Int, primaryPlayer: Player) {
        primaryLabel.setText("Match #\(number)")
        secondaryLabel.setText(match.summaryDescription(for: primaryPlayer))
    }
}
