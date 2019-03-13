//
//  ViewController.swift
//  Countries
//
//  Created by Gispert Pelaez, Othmar on 3/12/19.
//  Copyright © 2019 Gispert Pelaez, Othmar. All rights reserved.
//

import UIKit

struct Section {
    let letter: String
    let countryNames: [String]
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var myURL = "https://gist.githubusercontent.com/ebaranov/41bf38fdb1a2cb19a781/raw/fb097a60427717b262d5058633590749f366bd80/gistfile1.json"
    
    var myArr = [String]()
    var countriesWithStates = [String:[String]]()
    
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getListOfCountries()
        
        self.title = "Countries"
    }
    
    func getListOfCountries() {
        
        guard let url = URL(string: myURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (countries, response, error) in
        
            guard let dataResponse = countries, error == nil else { return }
            
            do {
                let countriesModel = try JSONDecoder().decode(GetData.self, from: dataResponse)
                
                for country in countriesModel.countries {
                    self.countriesWithStates.updateValue(country.states, forKey: country.country)
                    self.myArr.append(country.country)
                }
                
                DispatchQueue.main.async {
                    let groupedDictionary = Dictionary(grouping: self.myArr, by: {String($0.prefix(1))})
                    let keys = groupedDictionary.keys.sorted()
                    self.sections = keys.map{ Section(letter: $0, countryNames: groupedDictionary[$0]!.sorted()) }
                    self.tableView.reloadData()
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let section = sections[indexPath.section]
        let country = section.countryNames[indexPath.row]
        cell.textLabel?.text = country
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].countryNames.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].letter
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for country in countriesWithStates {
            if tableView.cellForRow(at: indexPath)?.textLabel?.text == country.key {
                if country.value.count == 0 {
                    let alert = UIAlertController(title: "Did you know?", message: "The country you selected doesn't have any states?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let detailsVC = DetailsViewController.getInstance()
                    detailsVC.listOfStates = country.value
                    self.navigationController?.pushViewController(detailsVC, animated: true)
                }
            }
        }
    }
}

