//
//  SignInVC.swift
//  thebankappdeneme
//
//  Created by Berke Kesgin on 20.06.2024.
//

import UIKit
import FirebaseAuth

class SignInVC: UIViewController {

    //MARK: - UI Elements
    
    @IBOutlet weak var emailTextFiled: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - Properties
    
    let authenticationVM = AuthenticationViewModel()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //MARK: - Functions
    
    func performSegueForToMainVC(){
        performSegue(withIdentifier: "toMainVC", sender: nil)
    }
    
    
    //MARK: - Actions
    
    /// Kullanıcı Firebase Girişi Yapar
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        // email ve password kontrolü sağlando
        guard let emailText = emailTextFiled.text, !emailText.isEmpty,
              let passwordText = passwordTextField.text, !passwordText.isEmpty else {
            print("Email or Password field is empty")
            return
        }
        
        // firebase ile sisteme giriş yap
        authenticationVM.sigInFunc(email: emailText, password: passwordText){ [weak self] result in

            switch result {
            case .success(_):
                self!.performSegueForToMainVC()
            case .failure(let error):
                print("fail oldu: \(error)")
            }
            
        }
        
    }
    
    /// CreateAccount VC Sayfasına Gider
    @IBAction func toCreateAccountButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toCreateAccountVC", sender: nil)
    }
    

}
