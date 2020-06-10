//
//  Presenter.swift
//  Outdoorsy Code Challenge
//
//  Created by Alonzo Wilkins on 6/10/20.
//  Copyright © 2020 Anchor Point. All rights reserved.
//

import UIKit

protocol PresenterProtocol: AnyObject {
    
}

class Presenter: NSObject {

    weak var delegate: PresenterProtocol?
}
