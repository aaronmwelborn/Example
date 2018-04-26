//
//  VehicleDetailsViewController.swift
//  Example
//
//  Created by Aaron Welborn on 4/9/18.
//  Copyright © 2018 Aaron Welborn. All rights reserved.
//

import UIKit

class VehicleDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var vehicleLabel: UILabel!
    @IBOutlet var vehicleVIN: UILabel!
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var vehicle: [String: Any]!
    var vehicleName: String?
    var cards = [Dictionary<String,Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let vin = "VIN: \(vehicle["vin"] ?? "Not Available")"
        let year = vehicle["year"] ?? "0000"
        let make = vehicle["make"] ?? "Make"
        let model = vehicle["model"] ?? "Model"
        
        if let url = URL(string: (vehicle["imageUrl"] as? String)!) {
            vehicleImage.downloadedFrom(url: url)
        }
        
        vehicleLabel.text = ("\(year) \(make) \(model)").uppercased()
        vehicleVIN.text = vin.uppercased()
        
        collectionView?.register(UINib(nibName: "ActionableCard", bundle: nil), forCellWithReuseIdentifier: reuseActionableCard)
        let filePath = Bundle.main.path(forResource: "cards", ofType: "plist")
        
        if let path = filePath {
            cards = NSArray(contentsOfFile: path)! as! [Dictionary<String, String>]
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissVIew(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    //MARK: - Overrides for CollectionViewController
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300.0, height: 90.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseActionableCard, for: indexPath) as! CardCollectionViewCell
        
        cell.layer.cornerRadius = 10
        
        let card = cards[indexPath.row]
        
        if let title = card["title"] as? String,
            let subtext = card["subtext"] as? String{
            // Configure Cell
            cell.title?.text = "\(title.uppercased())"
            cell.subtext?.text = "\(subtext)"
            if let imageFromUrl = URL(string: card["imageUrl"] as! String) {
                cell.imageUrl?.downloadedFrom(url: imageFromUrl)
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueWebView {
            let indexPath = sender as! NSIndexPath
            let card = cards[indexPath.row]
            let destinationViewController = segue.destination as! WebViewController
            destinationViewController.urlString = card["cta"] as! String
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueWebView, sender: indexPath)
    }
}
