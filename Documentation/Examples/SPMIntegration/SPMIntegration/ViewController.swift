//
//  ViewController.swift
//  SPM Integration
//
//  Created by Pablo Bartolome on 24/3/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Waiting..."
    }

    @IBAction func didTapButton(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.label.text = "Done"
        }
    }
}

