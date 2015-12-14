//
//  MapViewController.swift
//  BlocSpot2
//
//  Created by Eric Chamberlin on 12/14/15.
//  Copyright © 2015 Eric Chamberlin. All rights reserved.
//


import MapKit
import CoreLocation
import MagicalRecord
import CoreData


//@objc(Places)

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {
    
    @IBOutlet weak var placesMapView: MKMapView!
    
    var allPlaces: Places!
    var allPlacesLong: NSNumber!
    var allPlacesLat: NSNumber!
    
    //var NSArray *allPlaces = [Places MR_findAll];
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
   // override func viewDidAppear(animated: Bool) {
        
         //mapViewWillStartLoadingMap(placesMapView)
   // }
    

    
    func saveContext() {
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    /*
    func mapViewWillStartLoadingMap(mapView: MKMapView) {
        Places.MR_requestAll()
        
            var name = Places.valueForKey("name") as! String
            var gpsX = Places.valueForKey("latitude")
            var gpsY = Places.valueForKey("Longitude")
            let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double((gpsX as! NSString).doubleValue), longitude: Double((gpsY as! NSString).doubleValue))
            var newAnotation = MKPointAnnotation()
            newAnotation.coordinate = location
            
            newAnotation.title = name
            placesMapView.addAnnotation(newAnotation)
           
        
    }
*/
    }


