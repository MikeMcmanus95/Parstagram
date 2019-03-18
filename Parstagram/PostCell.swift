//
//  PostCell.swift
//  Parstagram
//
//  Created by Michael Mcmanus on 3/16/19.
//  Copyright © 2019 Michael Mcmanus. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    var liked:Bool = false
    var isZooming = false
    var originalImageCenter:CGPoint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
        // Initialization code
    }
    
    
   @objc func pinch(sender:UIPinchGestureRecognizer) {
    
    if sender.state == .began {
        let currentScale = self.photoView.frame.size.width / self.photoView.bounds.size.width
        let newScale = currentScale*sender.scale
            if newScale > 1 {
                self.isZooming = true
            }
    }
        if sender.state == .changed {
            guard let view = sender.view else {return}
            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                      y: sender.location(in: view).y - view.bounds.midY)
            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: sender.scale, y: sender.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            let currentScale = self.photoView.frame.size.width / self.photoView.bounds.size.width
            var newScale = currentScale*sender.scale

            if newScale < 1 {
                newScale = 1
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                self.photoView.transform = transform
                sender.scale = 1
            }
            else {
                view.transform = transform
                sender.scale = 1
            }
        }
        else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            guard let center = self.originalImageCenter else {return}
            UIView.animate(withDuration: 0.3, animations: {
                self.photoView.transform = CGAffineTransform.identity
                self.photoView.center = center
            }, completion: { _ in
                self.isZooming = false
            })
        }
    }
    
    @objc func pan(sender: UIPanGestureRecognizer) {
        if self.isZooming && sender.state == .began {
            self.originalImageCenter = sender.view?.center
        }
        else if self.isZooming && sender.state == .changed {
            let translation = sender.translation(in: self)
                if let view = sender.view {
                    view.center = CGPoint(x:view.center.x + translation.x,
                                          y:view.center.y + translation.y)
                }
            sender.setTranslation(CGPoint.zero, in: self.photoView.superview)
        }
        
    }
    

    
    func setUpView() {
        
        photoView.isUserInteractionEnabled = true
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        pinch.delegate = self
        self.photoView.addGestureRecognizer(pinch)
        captionLabel.layer.zPosition = -1
        usernameLabel.layer.zPosition = -1
        likeButton.layer.zPosition = -1
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan(sender:)))
        pan.delegate = self
        self.photoView.addGestureRecognizer(pan)
        
    }
    @objc
    
    @IBAction func likePost(_ sender: Any) {
        let toBeLiked = !liked
        
        if (toBeLiked){
            print("Success!")
            self.setLiked(true)
        }
        else {
            print("Unliked.")
            self.setLiked(false)
        }
    }
    
    
    func setLiked(_ isLiked:Bool) {
        liked = isLiked
        
        if(liked)
        {
            likeButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }
        else
        {
            likeButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
