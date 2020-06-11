//
//  ViewController.swift
//  Outdoorsy Code Challenge
//
//  Created by Alonzo Wilkins on 6/10/20.
//  Copyright © 2020 Anchor Point. All rights reserved.
//

import UIKit

let cellIdentifier = "cell"

class ViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: Presenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter = Presenter()
        presenter?.delegate = self
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var updatedText = ""
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            
           updatedText = text.replacingCharacters(in: textRange, with: string)
        }

        presenter?.textFieldDidUpdateText(text: updatedText)
        
        return true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter?.resultsArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ResultTableViewCell else {
            
            return UITableViewCell()
        }
        
        presenter?.configureCell(cell: cell, at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: PresenterProtocol {
    
    func didUpdateData() {
        
        self.tableView.reloadData()
    }
}
