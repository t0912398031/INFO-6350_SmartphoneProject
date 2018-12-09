//
//  MenuViewController.swift
//  final
//
//  Created by Chung-Yang Li on 12/3/18.
//  Copyright © 2018 James. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewController: UIViewController {
    
    @IBOutlet weak var signOut: UIButton!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var btnCloseMenuOverlay: UIButton!
    @IBOutlet weak var menuView: UIView!
    var btnMenu: UIButton!
    var delegate: SlideMenuDelegate?
    let userDefaults = UserDefaults()
    
    @IBAction func profile(_ sender: UIButton) {
        var pvc = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        pvc?.useremail = labelEmail.text!
        self.navigationController?.pushViewController(pvc!, animated: true)
    }
    @IBAction func signOut(_ sender: Any) {
        print("Sign out pressed")
        do{
            print("4")
            try Auth.auth().signOut()
            
            try GIDSignIn.sharedInstance()?.signOut()
            print("2")
            self.userDefaults.removeObject(forKey: "usersignedin")
            print("3")
            self.userDefaults.synchronize()
            self.dismiss(animated: true, completion: nil)
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }
        
    }
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(sender.tag)
            if(sender == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let email = Auth.auth().currentUser?.email else{return}
        labelEmail.text = email
        
        signOut.layer.cornerRadius = 10
        
        // Background
        UIGraphicsBeginImageContext(self.menuView.frame.size)
        UIImage(named: "blueBackground")?.draw(in: self.menuView.bounds)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            
            
            
            self.menuView.backgroundColor = UIColor(patternImage: image)
        }else{
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
