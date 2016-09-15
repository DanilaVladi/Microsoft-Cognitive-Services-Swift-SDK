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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let identifier = tableView.cellForRow(at: indexPath)!.textLabel!.text!
        
      
            
        switch identifier {
            
        case "Powered by Microsoft Cognitive Services":
            let url = URL(string: "https://microsoft.com/cognitive-services/")!
            if #available(iOS 9.0, *) {
                let sfViewController = SFSafariViewController(url: url)
                self.present(sfViewController, animated: true, completion: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
            
        case "Analyze Image", "OCR":
            self.performSegue(withIdentifier: identifier, sender: self)
            
            
        default:
            let alert = UIAlertController(title: "Missing", message: "This hasn't been implemented yet.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        let text = demos[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = text

        
        if text == "Powered by Microsoft Cognitive Services" {
            cell.accessoryType = .none
            cell.textLabel?.textColor = .blue
        }
        else {
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.textColor = .black
        }
        
        return cell
    }
    
    // MARK: - UITableViewDataSource Delegate
    
    
    let demos = ["Analyze Image","Get Thumbnail","List Domain Specific Model","OCR","Recognize Domain Specfic Content","Tag Image", "Powered by Microsoft Cognitive Services"]
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.navigationItem.title = demos[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
        tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
    }

}

