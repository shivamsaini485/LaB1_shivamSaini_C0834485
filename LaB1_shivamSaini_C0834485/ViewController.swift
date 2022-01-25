//
//  ViewController.swift
//  LaB1_shivamSaini_C0834485
//
//  Created by Shivam Saini on 2022-01-18.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var crossScoreLabel: UILabel!
    @IBOutlet weak var noughtScoreLabel: UILabel!
    
    var board = [String]()
    var activePlayer = ""
    
    var tapCalled: UIButton!
    
    var crossScore:Int = 0
    var noughtScore:Int = 0
    
    var savedScore: ScoreBoard!
    
    var rules = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        loadBoard()
        loadScore()
        becomeFirstResponder()
    }
    
    func loadScore(){
        let request: NSFetchRequest<ScoreBoard> = ScoreBoard.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            let score = try context.fetch(request)
            if score.count > 0 {
                savedScore = score.first
                crossScore = Int(savedScore.crossScore!) ?? 0
                crossScoreLabel.text = String(crossScore)
                noughtScore = Int(savedScore.noughtScore!) ?? 0
                noughtScoreLabel.text = String(noughtScore)
                
            }
        } catch {
            print("Error loading \(error.localizedDescription)")
        }
        
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        //SHAKE MOTION BEGAN
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        //SHAKE MOTION ENDED
        
        if(motion == .motionShake && activePlayer == "X"){
            tapCalled.setTitle(nil, for: .normal)
            tapCalled.isEnabled = true
            activePlayer = "O"
        }
        else if(motion == .motionShake && activePlayer == "O"){
            tapCalled.setTitle(nil, for: .normal)
            tapCalled.isEnabled = true
            activePlayer = "X"
        }
        
    }
    
    @objc func swipeGesture(){
        reset()
    }
    
    
    @IBAction func buttonTouched(_ sender: UIButton) {
        let index = buttons.index(of: sender)!
        
        
        
        if activePlayer == "X"{
            tapCalled = sender
            sender.setTitle("O", for: .normal)
            activePlayer = "O"
            //to freeze it so not able to make move again
            board[index] = "X"
        }else{
            tapCalled = sender
            sender.setTitle("X", for: .normal)
            activePlayer = "X"
            board[index] = "O"
        }
        winner()
    }
    func winner(){
        for rule in rules {
            let player1 = board[rule[0]]
            let player2 = board[rule[1]]
            let player3 = board[rule[2]]
            
            if player1 == player2, player2  == player3,!player1.isEmpty {
                if activePlayer == "X" {
                    crossScore += 1
                    crossScoreLabel.text = String(crossScore)
                } else {
                    noughtScore += 1
                    noughtScoreLabel.text = String(noughtScore)
                }
                
                if savedScore == nil {
                    savedScore = ScoreBoard(context: context)
                }
                savedScore.noughtScore = String(noughtScore)
                savedScore.crossScore = String(crossScore)
                do {
                    try context.save()
                } catch {
                    print("Error \(error.localizedDescription)")
                }
                print("winner is \(player2)")
                showAlert(msg: "WoW \(player3) you've won ")
                return
            }
        }
         
        if !board.contains(""){
            showAlert(msg: " the game is tied try again")
        
    }
    }
    func showAlert(msg: String) {
        let alert = UIAlertController(title: "Winner", message: "Hurray! you have won", preferredStyle: .alert)
        let action = UIAlertAction(title: "NewGame", style: .default) { _ in self.reset()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
        
        func reset() {
            board.removeAll()
            loadBoard()
            
            for button in buttons {
                button.setTitle(nil, for: .normal)
            }
            
        }
    
    
    func loadBoard(){
        for i in 0..<buttons.count{
        board.append("")
    }
}

}

