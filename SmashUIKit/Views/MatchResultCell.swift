//
//  MatchResultCell.swift
//  SmashUIKit
//
//  Created by Jason Ji on 2/25/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import UIKit

public enum MatchResultStyle {
    case upperArrow, lowerArrow
}

public struct MatchResultCellParams {
    public let upperPlayerName: String
    public let lowerPlayerName: String
    public let upperScore: Int
    public let lowerScore: Int
    public let upperFont: UIFont
    public let lowerFont: UIFont
    public let ratingChangeString: String
    public let ratingChangeColor: UIColor
    public let matchResultStyle: MatchResultStyle
    
    public init(upperPlayerName: String, lowerPlayerName: String, upperScore: Int, lowerScore: Int, upperFont: UIFont, lowerFont: UIFont, ratingChangeString: String, ratingChangeColor: UIColor = .victoryGreen, matchResultStyle: MatchResultStyle = .upperArrow) {
        self.upperPlayerName = upperPlayerName
        self.lowerPlayerName = lowerPlayerName
        self.upperScore = upperScore
        self.lowerScore = lowerScore
        self.upperFont = upperFont
        self.lowerFont = lowerFont
        self.ratingChangeString = ratingChangeString
        self.ratingChangeColor = ratingChangeColor
        self.matchResultStyle = matchResultStyle
    }
}

public class MatchResultCell: UITableViewCell {

    @IBOutlet weak var upperPlayerLabel: UILabel!
    @IBOutlet weak var lowerPlayerLabel: UILabel!
    
    @IBOutlet weak var upperScoreLabel: UILabel!
    @IBOutlet weak var lowerScoreLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var upperArrowConstraint: NSLayoutConstraint!
    @IBOutlet weak var lowerArrowConstraint: NSLayoutConstraint!
    
    func configure(with params: MatchResultCellParams) {
        upperPlayerLabel.text = params.upperPlayerName
        lowerPlayerLabel.text = params.lowerPlayerName
        
        upperScoreLabel.text = "\(params.upperScore)"
        lowerScoreLabel.text = "\(params.lowerScore)"
        
        [upperPlayerLabel, upperScoreLabel].forEach { $0?.font = params.upperFont }
        [lowerPlayerLabel, lowerScoreLabel].forEach { $0?.font = params.lowerFont }
        
        ratingLabel.text = params.ratingChangeString
        ratingLabel.textColor = params.ratingChangeColor
        
        upperArrowConstraint.isActive = params.matchResultStyle == .upperArrow
        lowerArrowConstraint.isActive = params.matchResultStyle == .lowerArrow
        setNeedsLayout()
    }
    
}
