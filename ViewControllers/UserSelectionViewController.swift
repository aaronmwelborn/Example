//
//  UserSelectionViewController.swift
//  Example
//
//  Created by Aaron Welborn on 4/11/18.
//  Copyright © 2018 Aaron Welborn. All rights reserved.
//

import UIKit
import Alamofire

class UserSelectionViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var errorText: UILabel!
    
    var jsonResponse = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.username.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "brand-banner-generic.png")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(UserSelectionViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UserSelectionViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.errorText.textColor = .white
        self.errorText.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueMemberVehicles {
            let embedded = self.jsonResponse["_embedded"] as! [String:Any]?
            let vehicleRepo = embedded?["vehicleRepo"] as! [Any]?
            let repoArray = vehicleRepo?[0] as! [String:Any]?
            let memberId = repoArray?["memberId"] as! String?
            let memberVehicles = repoArray?["vehicles"] as! [Dictionary<String,Any>]?
            print("JSON_RESPONSE:: \(embedded!)")
            let destinationViewController = segue.destination as! CarSelectionViewController
            destinationViewController.vehicles = memberVehicles!
            destinationViewController.memberId = memberId!
        }
    }
    
    func getMemberVehicles(completion: @escaping ([String : Any]) -> Void) {
        if let memberId = username.text {
            Alamofire.request(getDomain + associatedVehiclesURL + findByMemberId + memberId).responseJSON { response in
                completion(response.result.value as! [String: Any])
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  //if desired
        performAction()
        return true
    }
    
    func performAction() {
        didTapSubmit(sender: self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @IBAction func didTapSubmit(sender: Any?) {
        getMemberVehicles() { response in
            self.jsonResponse = response
            let embedded = self.jsonResponse["_embedded"] as! [String:Any]?
            let vehicleRepo = embedded?["vehicleRepo"] as! [Any]?
            if (vehicleRepo?.count)! > 0 {
                self.performSegue(withIdentifier: segueMemberVehicles, sender: self)
            } else {
                self.errorText.text = "User Not Found!"
                self.errorText.textColor = .red
            }
        }
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
