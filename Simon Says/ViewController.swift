//
//  ViewController.swift
//  Simon Says
//
//  Created by yaron mordechai on 18/03/2020.
//  Copyright © 2020 yaron mordechai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var colorsButton: [CircularButton]!
    @IBOutlet weak var actionButton: UIButton!
    
    
    @IBOutlet var playerLabels: [UILabel]!
    
    @IBOutlet var scoreLabels: [UILabel]!
    
    var currnetPlayer = 0
    var scores = [0,0]
    var sequenceIndex = 0
    var colorSequence = [Int]()
    var colorsToTap = [Int]()
    var gameEnded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        colorsButton = colorsButton.sorted(){
            $0.tag < $1.tag
        }
        playerLabels = playerLabels.sorted(){
                   $0.tag < $1.tag
        }
        scoreLabels = scoreLabels.sorted(){
                          $0.tag < $1.tag
        }
        createNewGame()

        
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameEnded {
            gameEnded = false
            createNewGame()
        }
    }

    
    func createNewGame(){
        
        colorSequence.removeAll()
        
        actionButton.setTitle("Start Game", for:.normal)
        actionButton.isEnabled = true
        
        //seting colors to be disenabled and dim
        for colorButton in colorsButton {
            colorButton.alpha = 0.5
            colorButton.isEnabled = false
        }
        
        currnetPlayer = 0
        scores = [0,0]
        
        //the first player->playerLabels[0] dim to max
        playerLabels[currnetPlayer].alpha = 1.0
        //the second player ->playerLabels[1] dim to mid
        playerLabels[1].alpha = 0.75
        
        updateScoreLabels()
        
    }
    
    //update the score
    func updateScoreLabels(){
    
        // taking the index and label from score labels
        // from createNewGame function-> index=0 label=0 => insreting "0" to label
        
        for (index,label) in scoreLabels.enumerated(){
            label.text = "\(scores[index])"
        }
        
        
    }
    //switching players
    func switchPlayers(){
        //seting alpha to mid to the current playerLabels
        playerLabels[currnetPlayer].alpha = 0.75
        //changing the turn of the current player to the next player
        currnetPlayer = currnetPlayer == 0 ? 1 : 0
        playerLabels[currnetPlayer].alpha = 1.0
    }
    

    // adding new color to the colorSequence array
    func AddNewColor(){
        
        colorSequence.append(Int(arc4random_uniform(UInt32(4))))
        
    }
    //playSequence
    func playSequence(){
        // flash the color if sequenceIndex < colorSequence.count
        if sequenceIndex < colorSequence.count{
            flash(button: colorsButton[colorSequence[sequenceIndex]])
            sequenceIndex += 1
        }
        // when sequenceIndex >= colorSequence.count
        else{
            colorsToTap = colorSequence
            view.isUserInteractionEnabled = true
            actionButton.setTitle("Tap the Circles", for: .normal)
            for button  in colorsButton {
                button.isEnabled = true
            }
        }
    }
    //flash the color and the calling the playSequence to continue to the next  color
    func flash(button: CircularButton){
        UIView.animate(withDuration: 0.5, animations: {
            button.alpha = 1.0
            button.alpha = 0.5
        }) { (bool) in
            self.playSequence()
        }
    }
    func endGame(){
        
        let message =  currnetPlayer == 0 ? "Player 2 Wins!" : "Player 1 Wins!"
        actionButton.setTitle(message,for: .normal)
        gameEnded = true
        
        
    }
    @IBAction func colorButtonHeandler(_ sender: CircularButton) {
        if sender.tag == colorsToTap.removeFirst(){
            
        }
        else{
            for button in colorsButton{
                button.isEnabled = false
                
            }
            endGame()
            return
        }
        if colorsToTap.isEmpty{
            for button in colorsButton{
                button.isEnabled = false

        }
            scores[currnetPlayer] += 1
            updateScoreLabels()
            switchPlayers()
            actionButton.setTitle("Continue", for: .normal)
            actionButton.isEnabled = true
    }
    }
    
    @IBAction func actionButtonHandler(_ sender: UIButton) {
        sequenceIndex = 0
        actionButton.setTitle("Memorize", for: .normal)
        actionButton.isEnabled = false
        view.isUserInteractionEnabled = false
        AddNewColor()
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + .seconds(1)) {
            self.playSequence()
        }
    }
}

