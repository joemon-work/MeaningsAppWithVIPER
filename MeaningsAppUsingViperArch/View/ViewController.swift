//
//  ViewController.swift
//  MeaningsAppUsingViperArch
//
//  Created by 1964058 on 29/08/22.
//

import UIKit

class ViewController: UIViewController, Loadable {
    
    @IBOutlet weak var meaningTableView:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    var presenter:viewToPresenterProtocol?
    var searchResults:[MeaningCellViewModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.showsCancelButton = true
        searchBar.searchTextField.clearButtonMode = .never
        meaningTableView.estimatedRowHeight = 44
        meaningTableView.delegate = self
    }
    
    func clearList() {
        searchResults = []
        self.meaningTableView.reloadData()
    }
    
    func checkSearchTextLength(searchText:String) -> Bool {
        guard (searchText.count >= 2 && searchText.count < 5) else {
            return false
        }
        return true
    }
}

extension ViewController:presenterToViewProtocol {
    func showMeanings(searchResults: [MeaningCellViewModel]) {
        self.searchResults = searchResults
        DispatchQueue.main.async {
            self.hideLoadingView()
            self.meaningTableView.reloadData()
        }
    }
    
    func showError(message: String?) {
        DispatchQueue.main.async {
            self.hideLoadingView()
            if let error = message {
                self.showError(message: error)
            }
        }
    }
}



extension ViewController:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if let model = self.searchResults, model.isEmpty {
            let noDataLabel: UILabel  = UILabel()
            tableView.backgroundView  = noDataLabel
            noDataLabel.translatesAutoresizingMaskIntoConstraints = false
            noDataLabel.widthAnchor.constraint(equalToConstant: meaningTableView.bounds.width).isActive = true
            noDataLabel.heightAnchor.constraint(equalToConstant: meaningTableView.bounds.height).isActive = true
            noDataLabel.centerXAnchor.constraint(equalTo: meaningTableView.centerXAnchor).isActive = true
            noDataLabel.centerYAnchor.constraint(equalTo: meaningTableView.centerYAnchor).isActive = true
            
            noDataLabel.text          = "No meanings available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.separatorStyle  = .none
        } else {
            tableView.separatorStyle = .singleLine
            numOfSections = 1
            tableView.backgroundView = nil
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = self.searchResults else {
            return 0
        }
                  
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "meaningCell", for: indexPath) as! MeaningTableViewCell
        if let list = self.searchResults {
            let cellModel = list[indexPath.row]
            cell.meaning.text = cellModel.meaningText
        }
        return cell
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
}

extension ViewController:UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.clearList()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.isEmpty != true else {
            self.showAlert(with: "Please enter any text")
            self.clearList()
            return
        }
        let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if checkSearchTextLength(searchText: searchText) {
            self.showLoadingView()
            presenter?.fetchMeaninings(with: searchText)
        }
    }
}

extension ViewController {
    
    func showAlert(with message:String) {
        let alert = UIAlertController(title: "Meanings", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
