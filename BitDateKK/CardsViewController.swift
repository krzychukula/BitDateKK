//
//  CardsViewController.swift
//  BitDateKK
//
//  Created by Krzysztof Kula on 24/06/15.
//  Copyright (c) 2015 Krzysztof Kula. All rights reserved.
//

import UIKit
import Parse

class CardsViewController: UIViewController,
            SwipeViewDelegate {
    
    struct Card {
        let cardView: CardView
        let swipeView: SwipeView
    }
    
    let frontCardTopMargin: CGFloat = 0
    let backCardTopMardin: CGFloat = 10
    
    @IBOutlet weak var cardStackView: UIView!
    
    var backCard: Card?
    var frontCard: Card?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cardStackView.backgroundColor = UIColor.clearColor()
        
        backCard = createCard(backCardTopMardin)
        cardStackView.addSubview(backCard!.swipeView)
        
        frontCard = createCard(frontCardTopMargin)
        cardStackView.addSubview(frontCard!.swipeView)
        
        
//        let testObject = PFObject(className: "TestObject")
//        testObject["foo"] = "bar"
//        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            println("Object has been saved.")
//        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "nav-header"))
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: .Plain, target: self, action: "goToProfile:")
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func createCardFrame(topMargin: CGFloat) -> CGRect {
        return CGRect(x: 0, y: topMargin, width: cardStackView.frame.width, height: cardStackView.frame.height)
    }
    
    private func createCard(topMargin: CGFloat) -> Card {
        let cardView = CardView()
        let swipeView = SwipeView(frame: createCardFrame(topMargin))
        swipeView.delegate = self
        swipeView.innerView = cardView
        return Card(cardView: cardView, swipeView: swipeView)
    }
    
    func goToProfile(button: UIBarButtonItem){
        pageController.goToPreviousVC()
    }
    
    //MARK: SwipeViewDelegate
    func swipeLeft() {
        println("left")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
        }
    }
    
    func swipeRight() {
        println("right")
        
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
        }
    }

}
