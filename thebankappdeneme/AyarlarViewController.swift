//
//  AyarlarViewController.swift
//  thebankappdeneme
//
//  Created by Berke Kesgin on 18.06.2024.
//

import UIKit
import FirebaseAuth

class AyarlarViewController: UIViewController {

    //MARK: - UI Elements
    
    
    //MARK: - Properties
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Functions
    
    
    //MARK: - Actions

    // self.performSegue(withIdentifier: "toMainView", sender: nil)

    @IBAction func logOutButtonTapped(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "toMainView", sender: nil)
        }catch{
            print("Error signing out")
        }

        
    }
    

}
