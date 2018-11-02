//
//  GameRowController.swift
//  SmashWatch Extension
//
//  Created by Jason Ji on 11/2/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import WatchKit
import SmashKitWatch

class GameRowController: NSObject {

    @IBOutlet weak var primaryLabel: WKInterfaceLabel!
    @IBOutlet weak var secondaryLabel: WKInterfaceLabel!
    
    func configure(with game: Game, number: Int, primaryPlayer: Player) {
        primaryLabel.setText("Game \(number)")
        secondaryLabel.setText(game.outcomeDescription(for: primaryPlayer))
    }
}
