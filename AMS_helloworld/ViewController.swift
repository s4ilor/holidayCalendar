//
//  ViewController.swift
//  AMS_helloworld
//
//  Created by Paweł Olbrycht on 14/01/2020.
//  Copyright © 2020 Paweł Olbrycht. All rights reserved.
//

import UIKit

class HolidaysTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var listOfHolidays = [HolidayDetails]() {
        
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = "\(self.listOfHolidays.count) Holidays found"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
       
    }
    @IBAction func onClickSafariButton(_ sender: UIBarButtonItem) {
        guard let url = URL(string: "https://calendarific.com/") else { return }
        UIApplication.shared.open(url)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfHolidays.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let holiday = listOfHolidays[indexPath.row]
        cell.textLabel?.text = holiday.name
        cell.detailTextLabel?.text = holiday.date.iso
        
        return cell
    }


}

extension HolidaysTableViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchBarText = searchBar.text else {
            print("Mo text")
            return
        }
        let holidayRequest = HolidayRequest(countryCode: searchBarText)
        holidayRequest.getHolidays { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let holidays):
                self?.listOfHolidays = holidays
            }
        }
        
    }
    
}
