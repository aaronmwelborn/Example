//
//  WebViewController.swift
//  Example
//
//  Created by Aaron Welborn on 4/11/18.
//  Copyright © 2018 Aaron Welborn. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var urlLabel: UITextField!
    @IBOutlet var webView: UIWebView!
    
    var urlString = "http://www.google.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlLabel.text = urlString
        let url = URL(string: urlString)
        
        // Do any additional setup after loading the view.
        if let unwrappedURL = url {
            let request = URLRequest(url: unwrappedURL)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    self.webView.loadRequest(request)
                } else {
                    print("ERROR: \(error ?? "" as! Error)")
                }
            }
            task.resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissVIew(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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
