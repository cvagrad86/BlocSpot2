//
//  ViewController.swift
//  BlocSpot2
//
//  Created by Eric Chamberlin on 12/3/15.
//  Copyright © 2015 Eric Chamberlin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation




class ViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    //starts map overlooking Pyrenees
    
    let initialLocation = CLLocation(latitude: 42.988566, longitude: 0.460573)
    
    var searchController:UISearchController!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var mapItemData:MKMapItem!
    
    
    
    // MARK: - location manager to authorize user location for Maps app
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerMapOnLocation(initialLocation)
        checkLocationAuthorizationStatus()
        
        let addSpot = UILongPressGestureRecognizer(target: self, action: "action:")
        addSpot.minimumPressDuration = 1
        mapView.addGestureRecognizer(addSpot)
        
        mapView.delegate = self
        
        
        
        
    }
    
    let regionRadius: CLLocationDistance = 200000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.showsCompass = true
        mapView.showsScale = true
    }
    
    
   
    
    func action(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            let touchPoint = gestureRecognizer.locationInView(mapView)
            let newCoordinate: CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            self.pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = newCoordinate
            pointAnnotation.title = "New Place Added"
            pointAnnotation.subtitle = "click i to add details"
            let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
            self.mapView.addAnnotation(pinAnnotationView.annotation!)
            print(pointAnnotation.coordinate)
            
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        let identifier = "PinDetails"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView!.canShowCallout = true
        let btn = UIButton(type: .DetailDisclosure)
        annotationView!.rightCalloutAccessoryView = btn
        
        //adding this create the push segue immediately, but still does not send the lat/long values
        //self.performSegueWithIdentifier("UserInfo", sender: self)
        
        return annotationView
        
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "PinDetails") {
            
            let yourNextViewController = segue.destinationViewController as! PlacesDetailViewController
            
            //this returns 0.0
            //if let senderObject = self.pointAnnotation {
                yourNextViewController.placeLatitude = (pointAnnotation.coordinate.latitude)
                yourNextViewController.placeLongitude = (pointAnnotation.coordinate.longitude)
            
                
            //}
            
            //these return 0.0
            //yourNextViewController.placeLongitude = (pinAnnotationView.annotation?.coordinate.longitude)!
            //yourNextViewController.placeLatitude = (pinAnnotationView.annotation?.coordinate.latitude)!

            
            //this creates a crash
            //yourNextViewController.placeLongitude = CLLocationCoordinate2DMake(self.pointAnnotation.coordinate.latitude, self.pointAnnotation.coordinate.longitude)
            
            //this creates a crash - unexpectedly found nil while unwrapping an optional value. 
            //yourNextViewController.placeLatitude = (pointAnnotation.coordinate.latitude)
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            performSegueWithIdentifier("PinDetails", sender: self)
            
        }
    }
    
    
}
