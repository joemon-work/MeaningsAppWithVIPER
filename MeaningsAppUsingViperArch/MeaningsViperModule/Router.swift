//
//  Router.swift
//  TestStringManipulations
//
//  Created by 1964058 on 22/08/22.
//

import Foundation
import UIKit

class MeaningsRouter:presenterToRouterProtocol {
    
    static func createModule()->ViewController {
        let vc:ViewController = mainstoryboard.instantiateViewController(withIdentifier: "MeaningsViewController") as! ViewController
        var presenter:viewToPresenterProtocol & interactorToPresenterProtocol = MeaningsPresenter()
        var interactor:presenterToInteractorProtocol = MeaningsInteractor()
        let router:presenterToRouterProtocol = MeaningsRouter()
    
        
        vc.presenter = presenter
        presenter.view = vc
        presenter.router = router
        presenter.interator = interactor
        interactor.presenter = presenter
        interactor.apiManager = APIManager()
        
        return vc
        
    }
    
    static var mainstoryboard: UIStoryboard {
            return UIStoryboard(name:"Main",bundle: Bundle.main)
        }
}
