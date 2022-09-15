//
//  MeaningsInteractor.swift
//  TestStringManipulations
//
//  Created by 1964058 on 22/08/22.
//

import Foundation

var baseURL = "http://www.nactem.ac.uk/software/acromine/dictionary.py?sf="

enum APIError:String {
    case dataError
    case emptyData
    case parseError
}

class MeaningsInteractor : presenterToInteractorProtocol {
    var apiManager: APIManager!
    
    var presenter: interactorToPresenterProtocol?
        
    func fetchMeaninings(with searchText: String) {
        guard !searchText.isEmpty, let url = URL(string:baseURL + searchText) else {
            DispatchQueue.main.async {
                self.presenter?.didFailFetch(error: NSError(domain: APIError.dataError.rawValue, code: 1001, userInfo: nil))
            }
            return
        }
        apiManager.loadData(from: url) { [weak self] result in
            switch result {
            case .data(let data):
                do {
                    var meanings = [MeaningCellViewModel]()
                    let meaning:[Meaning] = try JSONDecoder().decode([Meaning].self, from: data)
                    if meaning.isEmpty {
                        print("Empty Data")
                        DispatchQueue.main.async {
                            self?.presenter?.didFetchedMeanings(meanings: [])
                        }
                        return
                    } else {
                        var lfs:[lfs] = []
                        if let first = meaning.first, let meanings = first.lfs {
                            lfs = meanings
                        }
                        for item in lfs {
                            meanings.append(MeaningCellViewModel(meaningText: item.lf))
                        }
                        DispatchQueue.main.async {
                            self?.presenter?.didFetchedMeanings(meanings: meanings)
                        }
                        return
                    }
                } catch let parseError {
                    print(parseError.localizedDescription)
                    DispatchQueue.main.async {
                        self?.presenter?.didFailFetch(error: NSError(domain: APIError.parseError.rawValue, code: 1002, userInfo: nil))
                    }
                    return
                }
            case .error(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self?.presenter?.didFailFetch(error: NSError(domain:error.localizedDescription, code: 1003, userInfo: nil))
                }
                return
            }
        }
    }
}
