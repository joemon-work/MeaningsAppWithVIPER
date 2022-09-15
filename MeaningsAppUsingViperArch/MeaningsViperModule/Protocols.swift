//
//  Protocols.swift
//  TestStringManipulations
//
//  Created by 1964058 on 22/08/22.
//

import Foundation
import UIKit

protocol viewToPresenterProtocol {
    
    var view: presenterToViewProtocol? { get set}
    var interator: presenterToInteractorProtocol? {get set}
    var router:presenterToRouterProtocol? {get set}
    
    func fetchMeaninings(with searchText:String)
    
}

protocol presenterToInteractorProtocol {
    var presenter:interactorToPresenterProtocol? {get set}
    var apiManager:APIManager! {get set}
    
    func fetchMeaninings(with searchText:String)
}

protocol presenterToViewProtocol {
    
    func showMeanings(searchResults:[MeaningCellViewModel])
    func showError(message:String?)
    
}

protocol interactorToPresenterProtocol {
    
    func didFetchedMeanings(meanings:[MeaningCellViewModel])
    func didFailFetch(error: NSError)
}

protocol presenterToRouterProtocol {
   static func createModule() -> ViewController
}

