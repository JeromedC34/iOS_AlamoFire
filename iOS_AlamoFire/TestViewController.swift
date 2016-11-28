//
//  TestViewController.swift
//  iOS_AlamoFire
//
//  Created by imac on 28/11/2016.
//  Copyright © 2016 imac. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class TestViewController: UIViewController {

    @IBOutlet weak var uiTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var url:String = "http://jsonplaceholder.typicode.com"
        url = url + "/posts"
        Alamofire.request(url).responseArray { (response: DataResponse<[Post]>) in
            if let postsResponse = response.result.value {
                for post in postsResponse {
                    self.uiTextView.text = self.uiTextView.text + post.title + "\n"
                }
            } else {
                print("ERROR")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
