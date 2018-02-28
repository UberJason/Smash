//
//  MatchResultCellExtension.swift
//  Smash
//
//  Created by Jason Ji on 2/28/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import UIKit
import SmashKit
import SmashUIKit

extension MatchResultCell {
    func configure(with match: Match, preferredPlayer player: Player) {
        guard let ratingChangeString = match.ratingChangeString(for: player),
            let ratingChangeColor = match.ratingChangeColor(for: player)
            else { fatalError("This match doesn't contain this player, what are you doing??") }
        
        let params = MatchResultCellParams(upperPlayerName: match.player1.name,
                                           lowerPlayerName: match.player2.name,
                                           upperScore: match.player1Wins,
                                           lowerScore: match.player2Wins,
                                           upperFont: match.upperFont,
                                           lowerFont: match.lowerFont,
                                           upperTextColor: match.upperTextColor,
                                           lowerTextColor: match.lowerTextColor,
                                           ratingChangeString: ratingChangeString,
                                           ratingChangeColor: ratingChangeColor,
                                           matchResultStyle: match.matchArrowStyle)
        
        configure(with: params)
    }
}
