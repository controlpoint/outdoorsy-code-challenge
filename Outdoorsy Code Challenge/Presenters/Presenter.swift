//
//  Presenter.swift
//  Outdoorsy Code Challenge
//
//  Created by Alonzo Wilkins on 6/10/20.
//  Copyright © 2020 Anchor Point. All rights reserved.
//

import UIKit

protocol PresenterProtocol: AnyObject {
    
    func didUpdateData()
}

class Presenter: NSObject {

    weak var delegate: PresenterProtocol?
    var resultsArray: [ModelObject] = []

    func textFieldDidUpdateText(text: String) {
        
        DownloadManager.shared.performSearch(text) { [weak self] (error, result) in
            
            guard let strongSelf = self else { return }
            
            if let error = error {
                
                print("ERROR in '\(#function) \(#line)':  error encountered: \(error)")
                // FIXME: handle error in UI
            }
            
            strongSelf.resultsArray = result ?? []
            strongSelf.delegate?.didUpdateData()
        }
    }
    
    func configureCell(cell: ResultTableViewCell, at indexPath: IndexPath) {
        
        guard let object = resultsArray[safe: indexPath.row] else { return }
        
        cell.resultLabel.text = object.name
    }
}
