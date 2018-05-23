//
//  FirstViewController.swift
//  PurdueShare
//
//  Created by Shivan Desai on 3/9/18.
//  Copyright © 2018 Shiva Productions. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SwiftKeychainWrapper

struct user{
    var firstName : String
    var lastName : String
    var profilePictureURL : String
    var XCoordinate : String
    var YCoordinate : String
}

class FirstViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var StreetAddress: UITextField!
    let manager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        manager.delegate = self
        manager.desiredAccuracy =  kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveLocation(_ sender: Any) {
        var locat = manager.location
        if ((StreetAddress.text == "" || state.text == "" || zip.text == "" || city.text == "") && locationLabel.text == ""){
            let alertController = UIAlertController(title: "Alert", message: "Please enter your address", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default Action"), style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        else if(locationLabel.text == ""){
            let loc = "\(StreetAddress.text!), \(city.text!), \(state.text!), United States"
            print("LLLloc: \(loc)")
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(loc) { (placemarks, error) in
                if placemarks != nil && placemarks?.first?.location != nil{
                    let placemarks = placemarks
                    let location = placemarks?.first?.location
                    print("LLLLOCATION: \(location)")
                    locat = location!
                    var lat = locat!.coordinate.latitude
                    var long = locat!.coordinate.longitude
                    let uid: String = KeychainWrapper.standard.string(forKey: KEY_UID)!
                    DataService.instance.REF_USERS.child(uid).child("location").child("lat").setValue(lat)
                    DataService.instance.REF_USERS.child(uid).child("location").child("long").setValue(long)
                }
                else {
                    let alertController = UIAlertController(title: "Alert", message: "Coordinates not found. Please click on the 'Get my location' button", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default Action"), style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        else{
            locat = manager.location!
            var lat = locat!.coordinate.latitude
            var long = locat!.coordinate.longitude
            let uid: String = KeychainWrapper.standard.string(forKey: KEY_UID)!
            DataService.instance.REF_USERS.child(uid).child("location").child("lat").setValue(lat)
            DataService.instance.REF_USERS.child(uid).child("location").child("long").setValue(long)
        }
        
    }
    @IBAction func getLocation(_ sender: Any) {
        print("LLocation: \(manager.location)")
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) in
            if (error != nil){
                print("Reverse coder failed with error" + (error?.localizedDescription)!)
                return
            }
            if placemarks!.count > 0{
                let pm = placemarks![0] as CLPlacemark
                
                if pm != nil{
                    let locality = pm.locality
                    let adminArea = pm.administrativeArea
                    let country = pm.country
                    let postalCode = pm.postalCode
                    print("locality: \(locality), adminArea: \(adminArea), name: \(pm.name), region: \(pm.region), subLoc: \(pm.subLocality) ,sunAdmin: \(pm.subAdministrativeArea)" )
                    if pm.subLocality != nil{
                    self.locationLabel.text = "\(pm.name!), \(pm.subLocality!)), \(pm.locality!), \(pm.administrativeArea!))"
                    }
                    else{
                        self.locationLabel.text = "\(pm.name!), \(pm.locality!), \(pm.administrativeArea!)"
                    }
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: " + error.localizedDescription)
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
