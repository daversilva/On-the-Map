//
//  StudentLocationTableViewCell.swift
//  On the Map
//
//  Created by David Rodrigues on 27/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstLastName: UILabel!
    @IBOutlet weak var mediaUrl: UILabel!
    @IBOutlet weak var imagePin: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
