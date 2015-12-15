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
    
    @IBOutlet weak var placeNotes: UITextView!
    
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
        //fetchAllNotes()
        
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
        /*
        if let notes = plNotes {
            placeNotes.text = plNotes.notes
        } else {
            plNotes = PlacesDetails.MR_createEntity() as PlacesDetails
            plNotes.notes = ""
        }
*/
        
        

        
        
    }
    
    let regionRadius: CLLocationDistance = 100000
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D.init(latitude: placeLatitude, longitude: placeLongitude),
            regionRadius * 1.5 , regionRadius * 1.5)
        placeMapView.setRegion(coordinateRegion, animated: true)
        placeMapView.showsCompass = true
        placeMapView.showsScale = true
    
    }
    
    @IBAction func addNotes(sender: UIButton) {
        
        var inputTextField: UITextField?
        
        let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            // Do whatever you want with inputTextField?.text
            print("\(inputTextField?.text)")
            self.placeNotes.text = inputTextField?.text
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in }
        
        alertController.addAction(ok)
        alertController.addAction(cancel)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            inputTextField = textField
        } 
        
        
        //plNotes.notes = inputTextField?.text
        
        
        presentViewController(alertController, animated: true, completion: nil)
            
        }

    
    @IBAction func saveNotes(sender: UIButton) {
      
       
        //crashed - self.placeNotes.text = self.plNotes.notes
        //crashed - self.placeNotes.text = plNotes.notes
        //crashed - placeNotes.text = plNotes.notes
       
        
    }

   
    
    func fetchAllPlaces() {
        
        // Retrieve the current sort key.
        let sortKey = NSUserDefaults.standardUserDefaults().objectForKey(wbSortKey) as? String
        
        // Do not sort in ascending order if sorting by rating (i.e., sort descending).
        // Otherwise (i.e. sorting alphabetically), sort in ascending order.
        let ascending = (sortKey == sortKeyRating) ? false : true
        
        // Fetch records from Entity Beer using a MagicalRecord method.
        places = Places.MR_findAllSortedBy(sortKey, ascending: ascending) as! [Places]
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(true)
        
        saveContext()
    
    }
    
    func saveContext() {
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    
    


}