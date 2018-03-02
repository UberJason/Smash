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

}
