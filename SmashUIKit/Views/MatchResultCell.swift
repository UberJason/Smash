//
//  MatchResultCell.swift
//  SmashUIKit
//
//  Created by Jason Ji on 2/25/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import UIKit

public enum MatchArrowStyle {
    case upperArrow, lowerArrow
}

public struct MatchResultCellParams {
    public let upperPlayerName: String
    public let lowerPlayerName: String
    public let upperScore: Int
    public let lowerScore: Int
    public let upperFont: UIFont
    public let lowerFont: UIFont
    public let upperTextColor: UIColor
    public let lowerTextColor: UIColor
    public let ratingChangeString: String
    public let ratingChangeColor: UIColor
    public let matchResultStyle: MatchArrowStyle
    
    public init(upperPlayerName: String, lowerPlayerName: String, upperScore: Int, lowerScore: Int, upperFont: UIFont, lowerFont: UIFont, upperTextColor: UIColor = .black, lowerTextColor: UIColor = .defeatGray, ratingChangeString: String, ratingChangeColor: UIColor = .victoryGreen, matchResultStyle: MatchArrowStyle = .upperArrow) {
        self.upperPlayerName = upperPlayerName
        self.lowerPlayerName = lowerPlayerName
        self.upperScore = upperScore
        self.lowerScore = lowerScore
        self.upperFont = upperFont
        self.lowerFont = lowerFont
        self.upperTextColor = upperTextColor
        self.lowerTextColor = lowerTextColor
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
    
    public func configure(with params: MatchResultCellParams) {
        upperPlayerLabel.text = params.upperPlayerName
        lowerPlayerLabel.text = params.lowerPlayerName
        
        upperScoreLabel.text = "\(params.upperScore)"
        lowerScoreLabel.text = "\(params.lowerScore)"
        
        [upperPlayerLabel, upperScoreLabel].forEach { $0?.font = params.upperFont; $0?.textColor = params.upperTextColor }
        [lowerPlayerLabel, lowerScoreLabel].forEach { $0?.font = params.lowerFont; $0?.textColor = params.lowerTextColor }
        
        ratingLabel.text = params.ratingChangeString
        ratingLabel.textColor = params.ratingChangeColor
        
        upperArrowConstraint.isActive = params.matchResultStyle == .upperArrow
        lowerArrowConstraint.isActive = params.matchResultStyle == .lowerArrow
        setNeedsLayout()
    }
    
}
