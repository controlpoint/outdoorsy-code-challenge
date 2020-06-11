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
        
        guard text.count > 0 else {
            
            resultsArray = []
            return
        }
        
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
        cell.resultImageView.image = nil
        
        if let image = object.image {
            
            cell.resultImageView.image = image
        }
        else {
            
            // Right now we're keeping all images in memeory and re-downloading them with every key press
            // We should cache the images either in memory or by saving to disk
            // Since a quick caching solution would likely blow up the memory footprint, we'll skip this step for now
            // FIXME: implement image caching
            DownloadManager.shared.downloadImage(from: object.imageURL) { (error, image) in
                
                // we'll treat the object name as a unique identifier to ensure that we aren't setting the image to the incorrect cell.
                // FIXME: find a better way to do this
                guard cell.resultLabel.text == object.name else { return }
                
                object.image = image
                cell.resultImageView.image = image
            }
        }
    }
}
