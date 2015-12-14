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
import CoreData

//need 

//start thinking about the opening screen

//uisegmentedcontrol = + button on top all the time

//have saved places show up on map

//have tableview clickable

//ability to add a notes page

//custom table view cells

//auto layout checks




class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func showSearchBar(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
        }
    
    var locationManager = CLLocationManager()
    var places = Places!.self
    
    //starts map overlooking Pyrenees
    let initialLocation = CLLocation(latitude: 42.988566, longitude: 0.460573)
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var mapItemData:MKMapItem!
    
    var garonneOverlay:MKPolygon!
    var placeSelected:String?
    
    
    
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
        
        //fetchAllPlaces()
        
        
    }
    
   // override func viewDidAppear(animated: Bool) {
        //print(placeSelected)
       // let newCoordinate: CLLocationCoordinate2D =
       // self.pointAnnotation = MKPointAnnotation()
        
    //}
    let regionRadius: CLLocationDistance = 200000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.showsCompass = true
        mapView.showsScale = true
    }
    /*
    func fetchAllPlaces() {
      let oldPlace = Places.MR_importFromArray([AnyObject])
    
            // Create annotations for each one
            for oldPlace in Places {
                let aPlace = Places as Places
                let coord = CLLocationCoordinate2D(latitude: Places.latitude, longitude: Places.longitude);
                let placeAnnotation = placeAnnotation(coordinate: coord,
                    title: Places.name,
                    subtitle: Places.location)
                    
                mapView.addAnnotation(placeAnnotation)
            }
        }
        
    */
   
   
    
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
    
    //local search
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        //1
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if(segue.identifier == "PinDetails") {
            let nav = segue.destinationViewController as! UINavigationController
            let yourNextViewController = nav.topViewController as! PlacesDetailViewController
            
            //let  = segue.destinationViewController as! PlacesDetailViewController
            
                yourNextViewController.placeLatitude = (pointAnnotation.coordinate.latitude)
                yourNextViewController.placeLongitude = (pointAnnotation.coordinate.longitude)
            
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            performSegueWithIdentifier("PinDetails", sender: self)
            
        }
    }
    
 
    
    
}

