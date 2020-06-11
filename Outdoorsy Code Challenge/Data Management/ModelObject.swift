//
//  ModelObject.swift
//  Outdoorsy Code Challenge
//
//  Created by Alonzo Wilkins on 6/10/20.
//  Copyright © 2020 Anchor Point. All rights reserved.
//

import UIKit

class ModelObject {

    let name: String
    let imageURL: URL
    var image: UIImage?
    
    init(name: String, imageURL: URL) {
        
        self.name = name
        self.imageURL = imageURL
    }
}
