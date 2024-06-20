//
//  MainVC.swift
//  thebankappdeneme
//
//  Created by Berke Kesgin on 20.06.2024.
//

import UIKit
import FirebaseAuth

class MainVC: UIViewController {
    
    //MARK: - UI Elements
    
    //MARK: - Properties

    var userID: String? = Auth.auth().currentUser?.uid
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userID = userID else { return }
        
        // Do any additional setup after loading the view.
    }
    //MARK: - Functions
    
    //MARK: - Actions


}
