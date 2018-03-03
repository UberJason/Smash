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
        guard let groupResult = match.groupResult,
            let ratingChangeString = match.ratingChangeString(for: player),
            let ratingChangeColor = match.ratingChangeColor(for: player),
            let p1FinalRating = groupResult.finalRating(for: match.player1),
            let p2FinalRating = groupResult.finalRating(for: match.player2)
            else { fatalError("This match doesn't contain this player, what are you doing??") }
        
        let upperPlayerName = "\(match.player1.name) (\(p1FinalRating))"
        let lowerPlayerName = "\(match.player2.name) (\(p2FinalRating))"
        
        let params = MatchResultCellParams(upperPlayerName: upperPlayerName,
                                           lowerPlayerName: lowerPlayerName,
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
