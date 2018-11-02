//
//  ScoreInterfaceController.swift
//  SmashWatch Extension
//
//  Created by Jason Ji on 11/1/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import WatchKit
import Foundation

struct GameScoreModel {
    
}

class GameScoreInterfaceController: WKInterfaceController {

    @IBOutlet weak var player1ScorePicker: WKInterfacePicker!
    @IBOutlet weak var player2ScorePicker: WKInterfacePicker!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        initializePickers()
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func initializePickers() {
        player1ScorePicker.setItems(scorePickerItems())
        player2ScorePicker.setItems(scorePickerItems())
        
    }
    
    func scorePickerItems() -> [WKPickerItem] {
        return Array(1 ... 30).map { return WKPickerItem(title: "\($0)") }
    }

}
