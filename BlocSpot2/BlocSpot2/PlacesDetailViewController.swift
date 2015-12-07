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
    
    var newPlace = [NSManagedObject]()
    
    var placeLongitude = Double()
    var placeLatitude = Double()
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var mapItemData:MKMapItem!
    var savedAnnotation:MKAnnotation!
    
    
    var locationManager = CLLocationManager()
    
    //need a var to accept the coordinates from the vc
   
    //want to get the map to center on the place chosen in previous window
    
    let initialLocation = CLLocation(latitude: 42.988566, longitude: 0.460573)
    
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
        
       /*
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            //Data is in this case the name of the entity
            let entity = NSEntityDescription.entityForName("Places",
                inManagedObjectContext: managedContext)
            let options = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext:managedContext)
            
            options.setValue(nameLabel, forKey: "name")
            options.setValue(locationLabel, forKey: "location")
            options.setValue(notesLabel, forKey: "notes")
            options.setValue(NSDate.self, forKey: "date")
            options.setValue(placeLongitude, forKey: "longitude")
            options.setValue(placeLatitude, forKey: "latitude")
            
            var error: NSError?
            //if !managedContext.save(error)
            //{
                //print("Could not save")
           // }
            //uncomment this line for adding the stored object to the core data array
            //name_list.append(options)
        */
    }
}
