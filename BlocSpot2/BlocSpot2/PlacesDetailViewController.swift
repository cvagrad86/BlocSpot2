//
//  PlacesDetailViewController.swift
//  BlocSpot2
//
//  Created by Eric Chamberlin on 12/3/15.
//  Copyright © 2015 Eric Chamberlin. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation


class PlacesDetailViewController: UIViewController {

    @IBOutlet weak var detailMapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
   
    //want to get the map to center on the place chosen in previous window
    
    let initialLocation = CLLocation(latitude: 42.988566, longitude: 0.460573)
    
    @IBOutlet weak var notesLabel: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var locationLabel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        centerMapOnLocation(initialLocation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    //want to get the map to center on the place chosen in previous window
    
    let regionRadius: CLLocationDistance = 200000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        detailMapView.setRegion(coordinateRegion, animated: true)
        detailMapView.showsCompass = true
        detailMapView.showsScale = true
    }
    
    
    @IBAction func savePlaceDetails(sender: AnyObject) {
        
        //when this is clicked, it saves this data AND the lat and long data as Core Data
        
    }
    

}
