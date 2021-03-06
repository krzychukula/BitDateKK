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
        let user: User
    }
    
    let frontCardTopMargin: CGFloat = 0
    let backCardTopMardin: CGFloat = 10
    
    @IBOutlet weak var cardStackView: UIView!
    @IBOutlet weak var nahButton: UIButton!
    @IBOutlet weak var yeahButton: UIButton!
    
    var backCard: Card?
    var frontCard: Card?
    
    var users: [User]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cardStackView.backgroundColor = UIColor.clearColor()
        
        
        fetchUnviewedUsers({ users in
            self.users = users
            
            if let card = self.popCard() {
                self.frontCard = card
                self.cardStackView.addSubview(self.frontCard!.swipeView)
            }
            
            if let card = self.popCard() {
                self.backCard = card
                self.backCard?.swipeView.frame = self.createCardFrame(self.backCardTopMardin)
                self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
            }
            
        })
        
        nahButton.setImage(UIImage(named: "nah-button-pressed"), forState: UIControlState.Highlighted)
        yeahButton.setImage(UIImage(named: "yeah-button-pressed"), forState: UIControlState.Highlighted)
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
    
    @IBAction func nahButtonPressed(sender: UIButton) {
        
        if let card = frontCard {
            card.swipeView.swipe(SwipeView.Direction.Left)
        }
    }
    @IBAction func yeahButtonPressed(sender: UIButton) {
        if let card = frontCard {
            card.swipeView.swipe(SwipeView.Direction.Right)
        }
    }
    

    private func createCardFrame(topMargin: CGFloat) -> CGRect {
        return CGRect(x: 0, y: topMargin, width: cardStackView.frame.width, height: cardStackView.frame.height)
    }
    
    private func createCard(user: User) -> Card {
        let cardView = CardView()
        
        cardView.name = user.name
        user.getPhoto({ image in
            cardView.image = image
        })
        
        
        let swipeView = SwipeView(frame: createCardFrame(0))
        swipeView.delegate = self
        swipeView.innerView = cardView
        return Card(cardView: cardView, swipeView: swipeView, user: user)
    }
    
    private func popCard() -> Card? {
        if users != nil && users?.count > 0 {
            return createCard(users!.removeLast())
        }
        return nil
    }
    
    private func switchCards(){
        if let card = backCard {
            frontCard = card
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.frontCard!.swipeView.frame = self.createCardFrame(self.frontCardTopMargin)
            })
        }
        if let card = self.popCard() {
            self.backCard = card
            self.backCard?.swipeView.frame = self.createCardFrame(self.backCardTopMardin)
            self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
        }
    }
    
    func goToProfile(button: UIBarButtonItem){
        pageController.goToPreviousVC()
    }
    
    //MARK: SwipeViewDelegate
    func swipeLeft() {
        println("left")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            saveSkip(frontCard.user)
            switchCards()
        }
    }
    
    func swipeRight() {
        println("right")
        
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            saveLiked(frontCard.user)
            switchCards()
        }
    }

}
