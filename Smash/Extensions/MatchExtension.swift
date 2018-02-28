//
//  MatchExtension.swift
//  Smash
//
//  Created by Jason Ji on 2/28/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import UIKit
import SmashKit
import SmashUIKit

extension Match {
    var upperFont: UIFont {
        return winner == player1 ? UIFont.systemFont(ofSize: 17.0, weight: .semibold) : UIFont.systemFont(ofSize: 17.0, weight: .regular)
    }
    
    var lowerFont: UIFont {
        return winner == player2 ? UIFont.systemFont(ofSize: 17.0, weight: .semibold) : UIFont.systemFont(ofSize: 17.0, weight: .regular)
    }
    
    var upperTextColor: UIColor {
        return winner == player1 ? UIColor.black : UIColor.defeatGray
    }
    
    var lowerTextColor: UIColor {
        return winner == player2 ? UIColor.black : UIColor.defeatGray
    }
    
    func ratingChangeString(for player: Player) -> String? {
        guard contains(player: player) else { return nil }
        if player1 == player {
            return p1RatingChange >= 0 ? "+\(p1RatingChange)" : "–\(-1*p1RatingChange)"
        }
        else {
            return p2RatingChange >= 0 ? "+\(p2RatingChange)" : "–\(-1*p2RatingChange)"
        }
    }
    
    func ratingChangeColor(for player: Player) -> UIColor? {
        guard contains(player: player) else { return nil }
        
        return winner == player ? .victoryGreen : .defeatRed
    }
    
    var matchArrowStyle: MatchArrowStyle {
        return player1 == winner ? .upperArrow : .lowerArrow
    }
}
