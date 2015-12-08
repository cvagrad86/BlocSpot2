//
//  PlacesDetailTableTableViewController.swift
//  BlocSpot2
//
//  Created by Eric Chamberlin on 12/6/15.
//  Copyright © 2015 Eric Chamberlin. All rights reserved.
//

import UIKit
import CoreData


class PlacesDetailTableTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchControllerDelegate {

    
    let newPlace = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
   var vcPlaces = [Places]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var error:NSError?
        
        let request = NSFetchRequest(entityName: "Places")
        
        vcPlaces  = (try! newPlace.executeFetchRequest(request)) as! [Places]
        
        self.tableView.reloadData()
        
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        //possibly default this to show the various locations automatically based on valley?
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vcPlaces.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("placeCell", forIndexPath: indexPath) as UITableViewCell
        
        _ = vcPlaces[indexPath.row]
        
        cell.textLabel?.text = newPlace.name
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        print(newPlace.name)
        
        return cell

    }
    
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
