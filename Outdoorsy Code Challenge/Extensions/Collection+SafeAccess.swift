//
//  Collection+SafeAccess.swift
//  Project A Revision H
//
//  Created by Alonzo Wilkins on 7/12/19.
//  Copyright © 2019 Anchor Point. All rights reserved.
//

import UIKit

extension Collection where Indices.Iterator.Element == Index {
    
    subscript (safe index: Index) -> Iterator.Element? {
        
        return indices.contains(index) ? self[index] : nil
    }
}
