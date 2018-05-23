//
//  ShareFeedTableCell.swift
//  PurdueShare
//
//  Created by Shivan Desai on 5/22/18.
//  Copyright © 2018 Shiva Productions. All rights reserved.
//

import UIKit

class ShareFeedTableCell: UITableViewCell {

    
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var productName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
