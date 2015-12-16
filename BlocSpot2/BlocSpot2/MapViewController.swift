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
    
    var allPlaces: [Places]!
    var allPlacesLong: Double!
    var allPlacesLat: Double!
    
    let sortKeyName   = "name"
    let sortKeyRating = "beerDetails.rating"
    let wbSortKey     = "wbSortKey"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAllPlaces()
        
        for newPlace in 1...allPlaces.count {
            print("\(allPlaces.count)")
            
            
        }
        
        
}
    
   // override func viewDidAppear(animated: Bool) {
        
         //mapViewWillStartLoadingMap(placesMapView)
   // }

    func fetchAllPlaces() {
        
        let sortKey = NSUserDefaults.standardUserDefaults().objectForKey(wbSortKey) as? String
        
        let ascending = (sortKey == sortKeyRating) ? false : true
        
        allPlaces = Places.MR_findAllSortedBy(sortKey, ascending: ascending) as! [Places]
    }

    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? MKPinAnnotationView
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            
            pin!.canShowCallout = true
            pin!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pin!.annotation = annotation
        }
        return pin
    }
    
    func saveContext() {
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    }






