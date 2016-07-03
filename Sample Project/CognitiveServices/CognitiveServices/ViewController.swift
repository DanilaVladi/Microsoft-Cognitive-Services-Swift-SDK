//
//  ViewController.swift
//  CognitiveServices
//
//  Created by Vladimir Danila on 13/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let cognitiveServices = CognitiveServices.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - UITableView Delegate
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let identifier = tableView.cellForRowAtIndexPath(indexPath)!.textLabel!.text!
        
        if identifier == "Powered by Microsoft Cognitive Services" {
            let url = NSURL(string: "https://microsoft.com/cognitive-services/")!
            if #available(iOS 9.0, *) {
                let sfViewController = SFSafariViewController(URL: url)
                self.presentViewController(sfViewController, animated: true, completion: nil)
            } else {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        else {
            self.performSegueWithIdentifier(identifier, sender: self)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let text = demos[indexPath.row]
        cell.textLabel?.text = text

        
        if text == "Powered by Microsoft Cognitive Services" {
            cell.accessoryType = .None
            cell.textLabel?.textColor = .blueColor()
        }
        else {
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.textColor = .blackColor()
        }
        
        return cell
    }
    
    // MARK: - UITableViewDataSource Delegate
    
    
    let demos = ["Analyze Image","Describe Image","Get Thumbnail","List Domain Specific Model","OCR","Recognize Domain Specfic Content","Tag Image", "Powered by Microsoft Cognitive Services"]
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        segue.destinationViewController.navigationItem.title = demos[tableView.indexPathForSelectedRow!.row]
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
    }

}

