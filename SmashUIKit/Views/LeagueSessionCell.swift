//
//  LeagueSessionCell.swift
//  SmashUIKit
//
//  Created by Jason Ji on 3/2/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import UIKit

public class LeagueSessionCell: UITableViewCell {

    @IBOutlet public weak var dateLabel: UILabel!
    @IBOutlet public weak var subtitleLabel: UILabel!
    
    public func configure(dateString: String, subtitle: String) {
        dateLabel.text = dateString
        subtitleLabel.text = subtitle
    }
}
