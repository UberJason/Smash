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
            let finalRating = groupResult.finalRating(for: player),
            let matches = groupResult.matches(for: player) else {
                configureForAbsence(player: player)
                return
        }
        
        let netRatingChange = finalRating - initialRating
        let netRatingChangeString = netRatingChange >= 0 ? "(+\(netRatingChange))" : "(–\(-1*netRatingChange))"
        let netRatingLabelColor = netRatingChange < 0 ? UIColor.defeatRed : UIColor.victoryGreen
        
        let matchWins = matches.filter { $0.winner == player }.count
        let matchLosses = matches.filter { $0.winner != player }.count
        let matchRecord = "\(matchWins) – \(matchLosses)"
        
        let totalWins = matches.map { $0.wins(for: player) }.flatMap { $0 }.reduce(0, +)
        let totalLosses = matches.map { $0.losses(for: player) }.flatMap { $0 }.reduce(0, +)
        let gameRecord = "\(totalWins) – \(totalLosses)"
        
        configure(image: player.profileImage, name: player.name, initialRating: "\(initialRating)", finalRating: "\(finalRating)", netRatingChange: netRatingChangeString, netRatingLabelColor: netRatingLabelColor, matchRecord: matchRecord, gameRecord: gameRecord)
    }
    
    func configureForAbsence(player: Player?) {
        guard let player = player else { return }
        
        configure(image: player.profileImage, initials: player.initials, name: player.name, initialRating: "Did Not Play", finalRating: "", netRatingChange: "", netRatingLabelColor: .clear, matchRecord: "--", gameRecord: "--", hideArrow: true)
    }
}
