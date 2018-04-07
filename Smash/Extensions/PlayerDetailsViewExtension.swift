//
//  PlayerDetailsViewExtension.swift
//  Smash
//
//  Created by Jason Ji on 3/2/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation

import SmashKit
import SmashUIKit

extension PlayerDetailsView {
    func configure(with groupResult: GroupResult?, player: Player?) {
        guard let player = player else { return }
        
        guard let groupResult = groupResult,
            let initialRating = groupResult.initialRating(for: player),
            let finalRating = groupResult.finalRating(for: player) else {
                configureForAbsence(player: player)
                return
        }
        
        let netRatingChange = finalRating - initialRating
        let netRatingChangeString = netRatingChange >= 0 ? "(+\(netRatingChange))" : "(–\(-1*netRatingChange))"
        let netRatingLabelColor = netRatingChange < 0 ? UIColor.defeatRed : UIColor.victoryGreen
        
        let matchWins = groupResult.matchWins(for: player)
        let matchLosses = groupResult.matchLosses(for: player)
        let matchRecord = "\(matchWins) – \(matchLosses)"
        
        let totalWins = groupResult.gameWins(for: player)
        let totalLosses = groupResult.gameLosses(for: player)
        let gameRecord = "\(totalWins) – \(totalLosses)"
        
        let initials = String(player.name.split(separator: " ").map({ $0.first }).compactMap({ $0 }))
        
        configure(image: player.profileImage, initials: initials, name: player.name, initialRating: "\(initialRating)", finalRating: "\(finalRating)", netRatingChange: netRatingChangeString, netRatingLabelColor: netRatingLabelColor, matchRecord: matchRecord, gameRecord: gameRecord)
    }
    
    func configureForAbsence(player: Player?) {
        guard let player = player else { return }
        
        configure(image: player.profileImage, initials: player.initials, name: player.name, initialRating: "Did Not Play", finalRating: "", netRatingChange: "", netRatingLabelColor: .clear, matchRecord: "--", gameRecord: "--", hideArrow: true)
    }
}
