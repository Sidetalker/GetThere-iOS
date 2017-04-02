//
//  ViewController.swift
//  GetThere
//
//  Created by Kevin Sullivan on 4/2/17.
//  Copyright © 2017 SideApps. All rights reserved.
//

import UIKit
import GetThereUI
import FirebaseDatabase
import FirebaseAuth
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var compassView: PaintedView!
    
    var ref: FIRDatabaseReference!
    var user: FIRUser!
    
    var locationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindDatabase()
        authenticateUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        compassView.rotate(to: 130)
    }
    
    func bindDatabase() {
        ref = FIRDatabase.database().reference()
    }

    func authenticateUser() {
        FIRAuth.auth()?.signInAnonymously() { user, error in
            guard let user = user, error == nil else {
                print("Couldn't authenticate user \(String(describing: error))")
                return
            }
            
            self.user = user
            
            self.ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { snapshot in
                self.startWatchingStuff()
                
                guard snapshot.exists() else {
                    print("User doesn't exist, we'll create it soon")
                    return
                }
                
                print("Found user: \(snapshot)")
            }) { error in
                print("Error looking up user: \(error.localizedDescription)")
            }
        }
    }
    
    func startWatchingStuff() {
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.distanceFilter = 1000
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.headingAvailable() {
            locationManager.headingFilter = 5
            locationManager.startUpdatingHeading()
        } else {
            print("No heading for you sucker")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("New heading: \(newHeading)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("No locations ffs")
            return
        }
        
        print("Most recent location (or least most recent...?\n\(location)")
    }
}

