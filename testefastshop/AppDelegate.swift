//
//  AppDelegate.swift
//  testefastshop
//
//  Created by Gabriel Sousa on 09/10/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let servicoFilme = ServicosFilme()
        let filmesViewModel = FilmeViewModel(servicoFilmes: servicoFilme)
        let storyboard = UIStoryboard(name: "FilmesStoryboard", bundle: nil)
        guard let filmesViewController = storyboard.instantiateViewController(identifier: "FilmesViewController") as? FilmesViewController else { return false }
        
        filmesViewController.setup(viewModel: filmesViewModel)
        let navigationController = UINavigationController(rootViewController: filmesViewController)
        
        navigationController.navigationBar.isTranslucent = true
                
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        window?.rootViewController = navigationController
        navigationController.navigationBar.isHidden = true
        
        window?.makeKeyAndVisible()
        
        return true
    }
}

