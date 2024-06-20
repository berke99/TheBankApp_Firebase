//
//  CreateAccountVC.swift
//  thebankappdeneme
//
//  Created by Berke Kesgin on 20.06.2024.
//
    
import UIKit
    
class CreateAccountVC: UIViewController {
    
    //MARK: - UI Elements
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobilePhoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    //MARK: - Properties
    
    let authenticationVM = AuthenticationViewModel()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Functions
        
    //MARK: - Actions

    /// Firebase Kullanıcı Oluşturur
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        
        // kullanıcının girdiği değerler boş veya nil Değildir!
        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
              let lastName = lastNameTextField.text, !lastName.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let mobilePhone = mobilePhoneTextField.text, !mobilePhone.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("veri kayıt edilemez nil geldi!")
            return
        }
        
        authenticationVM.createUserAccount(firstName: firstName, lastName: lastName, email: email, mobilePhone: mobilePhone, password: password)
        
        
        
    }
    
    
}
