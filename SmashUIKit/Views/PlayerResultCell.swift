//
//  PlayerResultCell.swift
//  SmashUIKit
//
//  Created by Jason Ji on 4/6/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import UIKit

public struct PlayerResultCellParams {
    public let name: String
    public let record: String
    public let ratingString: String
    public let ratingChangeString: String
    public let ratingChangeColor: UIColor
    
    public init(name: String, record: String, ratingString: String, ratingChangeString: String, ratingChangeColor: UIColor = .victoryGreen) {
        self.name = name
        self.record = record
        self.ratingString = ratingString
        self.ratingChangeString = ratingChangeString
        self.ratingChangeColor = ratingChangeColor
    }
}

public class PlayerResultCell: UITableViewCell {
    
    @IBOutlet public weak var nameLabel: UILabel!
    @IBOutlet public weak var recordLabel: UILabel!
    @IBOutlet public weak var ratingLabel: UILabel!
    @IBOutlet public weak var changeLabel: UILabel!
    
    public func configure(with params: PlayerResultCellParams) {
        nameLabel.text = params.name
        recordLabel.text = params.record
        ratingLabel.text = params.ratingString
        changeLabel.text = params.ratingChangeString
        changeLabel.textColor = params.ratingChangeColor
    }
}
