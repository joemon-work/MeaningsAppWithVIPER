//
//  MeaningsPresenter.swift
//  TestStringManipulations
//
//  Created by 1964058 on 22/08/22.
//

import Foundation

class MeaningsPresenter:viewToPresenterProtocol {
    var view: presenterToViewProtocol?
    
    var interator: presenterToInteractorProtocol?
    
    var router: presenterToRouterProtocol?

    func fetchMeaninings(with searchText: String) {
        interator?.fetchMeaninings(with: searchText)
    }
}

extension MeaningsPresenter : interactorToPresenterProtocol {
    
    func didFetchedMeanings(meanings: [MeaningCellViewModel]) {
        view?.showMeanings(searchResults:meanings)
    }
    
    func didFailFetch(error: NSError) {
        view?.showError(message:error.localizedDescription)
    }
    
    
}
