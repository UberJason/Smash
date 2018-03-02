//
//  PlayerDetailsView.swift
//  SmashUIKit
//
//  Created by Jason Ji on 3/2/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import UIKit

public class PlayerDetailsView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var profileImageView: IconFallbackImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var initialRatingLabel: UILabel!
    @IBOutlet weak var finalRatingLabel: UILabel!
    @IBOutlet weak var netRatingChangeLabel: UILabel!
    @IBOutlet weak var matchRecordLabel: UILabel!
    @IBOutlet weak var gameRecordLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    func sharedInit() {
        Bundle(for: type(of: self)).loadNibNamed("PlayerDetailsView", owner: self, options: nil)
        guard let contentView = contentView else { return }
        addSubviewFullFrame(contentView)
    }

    public func configure(image: UIImage? = nil, initials: String? = nil, name: String, initialRating: String, finalRating: String, netRatingChange: String, netRatingLabelColor: UIColor, matchRecord: String, gameRecord: String, hideArrow: Bool = false) {
        profileImageView.image = image
        profileImageView.fallbackText = initials
        nameLabel.text = name
        initialRatingLabel.text = initialRating
        finalRatingLabel.text = finalRating
        netRatingChangeLabel.text = netRatingChange
        netRatingChangeLabel.textColor = netRatingLabelColor
        matchRecordLabel.text = matchRecord
        gameRecordLabel.text = gameRecord
        arrowImageView.alpha = hideArrow ? 0.0 : 1.0
    }
    
    
}
