//
//  ResultTableViewCell.swift
//  Outdoorsy Code Challenge
//
//  Created by Alonzo Wilkins on 6/10/20.
//  Copyright © 2020 Anchor Point. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        resultImageView.layer.cornerRadius = 6
    }

}
