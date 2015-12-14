//
//  PlacesDetailNotesViewController.swift
//  BlocSpot2
//
//  Created by Eric Chamberlin on 12/11/15.
//  Copyright © 2015 Eric Chamberlin. All rights reserved.
//
import UIKit
import CoreData
import MapKit
import CoreLocation


class PlacesDetailNotesViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var placeLocationLabel: UILabel!
    @IBOutlet weak var placeMapView: MKMapView!
    @IBOutlet weak var placeLongitudeLabel: UILabel!
    @IBOutlet weak var placeLatitudeLabel : UILabel!
    
    var places: [Places]!
    var placeSelected:String?
    var placeLocation: String?
    var placeLongitude: Double!
    var placeLatitude: Double!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var mapItemData:MKMapItem!
    var savedAnnotation:MKAnnotation!
    var inititalLocation:CLLocationCoordinate2D!
    var locationManager = CLLocationManager()
    
    let sortKeyName   = "name"
    let sortKeyRating = "beerDetails.rating"
    let wbSortKey     = "wbSortKey"
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fetchAllPlaces()
        
        placeLabel.text = placeSelected
        placeLocationLabel.text = placeLocation
        placeLongitudeLabel.text = "Long. \(placeLongitude)"
        placeLatitudeLabel.text = "Lat. \(placeLatitude)"
        
        let startingLocation = CLLocationCoordinate2DMake(placeLatitude, placeLongitude)
        
        centerMapOnLocation(startingLocation)
        
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = CLLocationCoordinate2DMake(placeLatitude, placeLongitude)
        dropPin.title = placeLabel.text
        dropPin.subtitle = placeLocationLabel.text
        
        placeMapView.addAnnotation(dropPin)
        placeMapView.delegate = self
        
    }
    
    let regionRadius: CLLocationDistance = 100000
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D.init(latitude: placeLatitude, longitude: placeLongitude),
            regionRadius * 1.5 , regionRadius * 1.5)
        placeMapView.setRegion(coordinateRegion, animated: true)
        placeMapView.showsCompass = true
        placeMapView.showsScale = true
    
    }
    
    func fetchAllPlaces() {
        
        // Retrieve the current sort key.
        let sortKey = NSUserDefaults.standardUserDefaults().objectForKey(wbSortKey) as? String
        
        // Do not sort in ascending order if sorting by rating (i.e., sort descending).
        // Otherwise (i.e. sorting alphabetically), sort in ascending order.
        let ascending = (sortKey == sortKeyRating) ? false : true
        
        // Fetch records from Entity Beer using a MagicalRecord method.
        places = Places.MR_findAllSortedBy(sortKey, ascending: ascending) as! [Places]
        
        print(places.description)
    }

    
    
}

