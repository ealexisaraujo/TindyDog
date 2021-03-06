//
//  MatchViewController.swift
//  TindyDog
//
//  Created by Enrique Alexis Lopez Araujo on 19/03/18.
//  Copyright © 2018 alexisaraujo. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController {

    @IBOutlet weak var copyMatchLbl: UILabel!
    @IBOutlet weak var secondUserMatchImage: UIImageView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var fisrtUserMatchImage: UIImageView!
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var currentUserProfile: UserModel?
    var currentMatch: MatchModel?
    
    
    
    @IBAction func doneBtnAction(_ sender: Any) {
        if let currentMatch = self.currentMatch {
            if currentMatch.matchIsAccepted {
                
            } else {
                DatabaseService.instance.updateFirebaseDBMatch(uid: currentMatch.uid)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.secondUserMatchImage.round()
        self.fisrtUserMatchImage.round()
        
        if let match = self.currentMatch {
            print("match: \(match)")
            if let profile = self.currentUserProfile{
                var secondID: String = ""
                if profile.uid == match.uid{
                    secondID = match.uid2
                } else {
                    secondID = match.uid
                }
                
                DatabaseService.instance.getUserProfile(uid: secondID, handler: { (secondUser) in
                    if let secondUser = secondUser {
                        if profile.uid == match.uid{
                            // init match
                            self.fisrtUserMatchImage.sd_setImage(with: URL(string:profile.profileImage), completed: nil)
                            self.secondUserMatchImage.sd_setImage(with: URL(string:secondUser.profileImage), completed: nil)
                            self.copyMatchLbl.text = "Esperando a \(secondUser.displayName)"
                            self.doneBtn.alpha = 0
                        } else {
                            // match
                            self.fisrtUserMatchImage.sd_setImage(with: URL(string:secondUser.profileImage), completed: nil)
                            self.secondUserMatchImage.sd_setImage(with: URL(string:profile.profileImage), completed: nil)
                            self.copyMatchLbl.text = "Tu mascota le gusta a \(secondUser.displayName)"
                            self.doneBtn.alpha = 1
                        }
                        if match.matchIsAccepted{
                            self.copyMatchLbl.text = "\(profile.displayName) y \(secondUser.displayName) quieren conocerse "
                            self.doneBtn.setTitle("Compartir", for: .normal)
                            self.doneBtn.alpha = 1
                        }
                    }
                })
            }
        }
        // Do any additional setup after loading the view.
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
