//
//  TableViewController.swift
//  Memorable Places
//
//  Created by Mark Torres on 4/5/16.
//  Copyright © 2016 HSoft Inc. All rights reserved.
//

import UIKit

// TODO: Change cell prototype
// TODO: Show more information in pin bubble

class TableViewController: UITableViewController {
	
	@IBOutlet var placesList: UITableView!

	override func viewDidLoad() {
        super.viewDidLoad()
		// MARK: Load data from storage
		if let savedPlaces = stdUserDefaults.objectForKey("places") as? NSData {
			places = NSKeyedUnarchiver.unarchiveObjectWithData(savedPlaces) as! [Place]
		}
		if places.count == 0 {
			places = sampleData
		}

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("PlaceCell", forIndexPath: indexPath)
		
		// Configure the cell...
		cell.textLabel?.text = places[indexPath.row].name
		
		return cell
	}
	
	override func viewWillAppear(animated: Bool) {
		placesList.reloadData()
	}
	
	// Override to support editing the table view.
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			// Delete from array before
			places.removeAtIndex(indexPath.row)
			// Delete the row from the data source
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
			// Save
			save()
		} else if editingStyle == .Insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		}
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "newPlace" {
			// TODO
			mapPlace = Place()
		}
		if segue.identifier == "viewPlace" {
			// TODO
		}
	}
	
	override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		mapPlace = places[indexPath.row]
		return indexPath
	}
	
	// MARK: Save
	
	func save() {
		let savedData = NSKeyedArchiver.archivedDataWithRootObject(places)
		stdUserDefaults.setObject(savedData, forKey: "places")
	}
}
