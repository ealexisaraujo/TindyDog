//
//  LoginViewController.swift
//  TindyDog
//
//  Created by Enrique Alexis Lopez Araujo on 06/03/18.
//  Copyright © 2018 alexisaraujo. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func subLoginBtnAction(_ sender: Any) {
        if self.registerMode {
            self.loginBtn.setTitle("Login", for: .normal)
            self.loginCopyLbl.text = "Eres Nuevo?"
            self.subLoginBtn.setTitle("Registrate", for: .normal)
            self.registerMode = false
        } else {
            self.loginBtn.setTitle("Crear Cuenta", for: .normal)
            self.loginCopyLbl.text = "Ya tienes Cuenta?"
            self.subLoginBtn.setTitle("Login", for: .normal)
            self.registerMode = true
        }
    }
    
    @IBOutlet weak var subLoginBtn: UIButton!
    @IBOutlet weak var loginCopyLbl: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    func showAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func loginActionBtn(_ sender: Any) {
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            self.showAlert(title: "Error", message: "Alguno de los campos esta vacio")
            
        } else {
            if let email = self.emailTextField.text{
                if let password = self.passwordTextField.text {
                    if registerMode {
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self.showAlert(title: "Error", message: error!.localizedDescription)
                            } else {
                                print("cuenta creada")
                                if let user = user{
                                    let userData = ["provider": user.providerID, "email": user.email!, "profileimage": "https://i.imgur.com/LrdJ0SO.jpg", "displayName": "Crispeta"] as [String: Any]
                                    
                                    DatabaseService.instance.createFirebaseDBUser(uid: user.uid, userData: userData)
                                }
                            }
                        })
                    } else {
                        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self.showAlert(title: "Error", message: error!.localizedDescription)
                            } else {
                                print("login")
                            }
                        })
                    }
                }
            }
        }
    }
    var registerMode = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bindKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    @objc func handleTap(sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
