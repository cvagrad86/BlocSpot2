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


class PlacesDetailViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var detailMapView: MKMapView!
    
    //var newPlace = [NSManagedObject]()
    let newPlace = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var placeLongitude = Double()
    var placeLatitude = Double()
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var mapItemData:MKMapItem!
    var savedAnnotation:MKAnnotation!
    
    
    var locationManager = CLLocationManager()
    
    //need a var to accept the coordinates from the vc
   
    //want to get the map to center on the place chosen in previous window
    
    
    @IBOutlet weak var notesLabel: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var locationLabel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        centerMapOnLocation(initialLocation)
        
        print(placeLatitude)
        print(placeLongitude)
        
        
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
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Places"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView!.canShowCallout = false
        
        return annotationView
    }
    
    @IBAction func savePlaceDetails(sender: AnyObject) {
        
        //when this is clicked, it saves this data AND the lat and long data as Core Data
        let placeDescription = NSEntityDescription.entityForName("Places", inManagedObjectContext: newPlace)

        let place = Places(entity: placeDescription!, insertIntoManagedObjectContext:  newPlace)
        //let placeDet = PlacesDetails(entity: placeDescription!, insertIntoManagedObjectContext: newPlace)

        place.name = nameLabel.text
        place.location = locationLabel.text
        
        print(place.name)
        print(place.location)
        
        do {
            try place.managedObjectContext!.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        //placeDet.notes = notesLabel.text
/*
        var error: NSError?

        try newPlace.save(&error)

        if let err = error {
            
            let a = UIAlertController(title: "Error", message: err.localizedFailureReason, preferredStyle: UIAlertControllerStyle.ActionSheet)
            a.view
            
        } else {
            
            let a = UIAlertController(title: "Success", message: "Your new place has been saved", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            a.show()

*/
}

    
       
        
    }

