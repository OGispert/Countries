//
//  DetailsViewController.swift
//  Countries
//
//  Created by Gispert Pelaez, Othmar on 3/12/19.
//  Copyright © 2019 Gispert Pelaez, Othmar. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var listOfStates: [String]?
    
    static func getInstance() -> DetailsViewController {
        let storybboard = UIStoryboard(name: "Main", bundle: nil)
        return (storybboard.instantiateViewController(withIdentifier: "DetailsVC")) as! DetailsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource =  self
        
        self.title = "States"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let states = listOfStates else { return UITableViewCell() }
        cell.textLabel?.text = states[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let states = listOfStates else { return 0 }
        return states.count
    }
}
