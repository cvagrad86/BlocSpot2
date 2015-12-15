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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //var locations = [Places].self
        /*
        var annotations = [MKPointAnnotation]()
        
        for dictionary in allPlaces {
            let latitude = CLLocationCoordinate2D.self
            let longitude = CLLocationCoordinate2D.self
            let coordinate = CLLocationCoordinate2D.self
            let name = "name" as String
            let annotation = MKPointAnnotation()
            //annotation.coordinate = coordinate
            annotation.title = "\(name)"
            annotations.append(annotation)
            
            placesMapView.addAnnotations(annotations)
        }
        
        */
    }
    
   // override func viewDidAppear(animated: Bool) {
        
         //mapViewWillStartLoadingMap(placesMapView)
   // }
    /*
    func showAllPlaces(){
        var newplaces = Places.MR_findAll()
        
        for index in 0..<newplaces.count{
            var lat = Double(allPlaces[index].latitude!)
            var long = Double(allPlaces[index].longitude!)
            let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double((lat as! NSString).doubleValue), longitude: Double((long as! NSString).doubleValue))
            var newAnotation = MKPointAnnotation()
            newAnotation.coordinate = location
            newAnotation.title = "place"
            placesMapView.addAnnotation(newAnotation)
            
           print("Places \(newplaces.count)")
            print("map loaded")
        }
    }
    */
    
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






