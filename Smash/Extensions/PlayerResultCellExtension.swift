//
//  PlayerResultCellExtension.swift
//  Smash
//
//  Created by Jason Ji on 4/6/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import UIKit
import SmashKit
import SmashUIKit

extension PlayerResultCell {
    func configure(with groupResult: GroupResult?, player: Player?) {
        guard let player = player,
            let groupResult = groupResult,
            let initialRating = groupResult.initialRating(for: player),
            let finalRating = groupResult.finalRating(for: player) else { return }
        
        let netRatingChange = finalRating - initialRating
        let netRatingChangeString = netRatingChange >= 0 ? "(+\(netRatingChange))" : "(–\(-1*netRatingChange))"
        let netRatingLabelColor = netRatingChange < 0 ? UIColor.defeatRed : UIColor.victoryGreen
        
        let matchWins = groupResult.matchWins(for: player)
        let matchLosses = groupResult.matchLosses(for: player)
        
        let totalWins = groupResult.gameWins(for: player)
        let totalLosses = groupResult.gameLosses(for: player)
        
        let overallRecord = "\(matchWins) - \(matchLosses) | \(totalWins) - \(totalLosses)"
        
        configure(with: PlayerResultCellParams(name: player.name, record: overallRecord, ratingString: "\(finalRating)", ratingChangeString: netRatingChangeString, ratingChangeColor: netRatingLabelColor))
    }
}
