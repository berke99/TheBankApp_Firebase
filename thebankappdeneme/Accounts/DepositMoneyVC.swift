//
//  DepositMoneyVC.swift
//  thebankappdeneme
//
//  Created by Berke Kesgin on 21.06.2024.
//

import UIKit

class DepositMoneyVC: UIViewController {
    

    //MARK: - UI Elements
    
    @IBOutlet weak var amountTextField: UITextField!
    
    //MARK: - Properties
    
    let accountViewModel = AccountViewModel()

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    //MARK: - Functions
    
    
    
    //MARK: - Actions

    /// Firebase Banka Hesabına Para Ekler
    @IBAction func depositMoneybuttonTapped(_ sender: Any) {
                
    }
    
    

}
