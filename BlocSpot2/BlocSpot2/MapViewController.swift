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
    
    var allPlaces: [Places] = []
    var allPlacesLong: Double!
    var allPlacesLat: Double!
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
    
    var placeSelected:String?
    
    let sortKeyName   = "name"
    let sortKeyRating = "beerDetails.rating"
    let wbSortKey     = "wbSortKey"

    //let initialLocation = CLLocation(latitude: 42.988566, longitude: 0.460573)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAllPlaces()
        self.placesMapView.delegate = self

        //centerMapOnLocation(initialLocation)
        
        for (index, element) in allPlaces.enumerate()
        {
            print("there are this many places \(allPlaces.count)")
            
            var name = element.name
            var gpsX = element.longitude as! Double
            var gpsY = element.latitude as! Double
            let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: gpsX, longitude: gpsY)
            //var newAnotation = MKPointAnnotation()
            self.pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = location
            pointAnnotation.title = name
            //placesMapView.addAnnotation(newAnotation)
            
            //let name1 = allPlaces[0].name
            //newAnotation.title = name1

            let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
            placesMapView.addAnnotation(pointAnnotation)
            
        }
        
       
        title = ("Pyrenees Rando \(allPlaces.count)")
     
}
    
    let regionRadius: CLLocationDistance = 200000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        placesMapView.setRegion(coordinateRegion, animated: true)
        placesMapView.showsCompass = true
        placesMapView.showsScale = true
    }
    


    func fetchAllPlaces() {
        let sortKey = NSUserDefaults.standardUserDefaults().objectForKey(wbSortKey) as? String
        let ascending = (sortKey == sortKeyRating) ? false : true
        allPlaces = Places.MR_findAllSortedBy(sortKey, ascending: ascending) as! [Places]
    }

    //adds pins?
   
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "PinDetails"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView!.canShowCallout = true
        let btn = UIButton(type: .DetailDisclosure)
        annotationView!.rightCalloutAccessoryView = btn
        
        return annotationView
        
    }
    //setting the map to show the various places available
   
    func fitMapViewToAnnotaionList(annotations: [MKPointAnnotation]) -> Void {
        let mapEdgePadding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        var zoomRect:MKMapRect = MKMapRectNull
        
        for index in 0..<annotations.count {
            let annotation = annotations[index]
            var aPoint:MKMapPoint = MKMapPointForCoordinate(annotation.coordinate)
            var rect:MKMapRect = MKMapRectMake(aPoint.x, aPoint.y, 0.1, 0.1)
            
            if MKMapRectIsNull(zoomRect) {
                zoomRect = rect
            } else {
                zoomRect = MKMapRectUnion(zoomRect, rect)
            }
        }
        
        placesMapView.setVisibleMapRect(zoomRect, edgePadding: mapEdgePadding, animated: true)
    }

    func saveContext() {
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if(segue.identifier == "PinDetails") {
            let nav = segue.destinationViewController as! UINavigationController
            let yourNextViewController = nav.topViewController as! PlacesDetailViewController
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






