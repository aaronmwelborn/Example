//
//  AddMemberViewController.swift
//  Example
//
//  Created by Aaron Welborn on 4/12/18.
//  Copyright © 2018 Aaron Welborn. All rights reserved.
//

import UIKit
import Alamofire

class AddMemberViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var submit: UIButton!
    
    var jsonResponse = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.username.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueMemberVehiclesFromAddMember {
            let embedded = self.jsonResponse["_embedded"] as! [String:Any]?
            let vehicleRepo = embedded?["vehicleRepo"] as! [Any]?
            let repoArray = vehicleRepo?[0] as! [String:Any]?
            let memberId = repoArray?["memberId"] as! String?
            let memberVehicles = repoArray?["vehicles"] as! [Dictionary<String,Any>]?
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
    
    @IBAction func didTapSubmit(sender: Any?) {
        let parameters: Parameters = [
            "memberId":username.text!,
            "vehicles":[]
            ]
        Alamofire.request(getDomain + associatedVehiclesURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
        getMemberVehicles() { response in
            self.jsonResponse = response
            self.performSegue(withIdentifier: segueMemberVehiclesFromAddMember, sender: self)
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
