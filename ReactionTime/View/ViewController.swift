//
//  ViewController.swift
//  ReactionTime
//
//  Created by Raul de Avila JR on 25/12/19.
//  Copyright © 2019 Raul de Avila JR. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    var color = UIColor.red
    var counter = 0
    var target = 0
    var timer = Timer()
    var difference = 0
    var score = 0
    var currentScore = 0
    var round = 1
    
    @IBOutlet weak var scorePlaceholder: UILabel!
    @IBOutlet weak var roundPlaceholder: UILabel!
    @IBOutlet weak var scoreFinal: UILabel!
    
    func updateLabels() {
        self.scorePlaceholder.text = ("\(currentScore)")
        self.roundPlaceholder.text = ("\(round)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = color
        updateLabels()
    }
    
    @IBOutlet weak var estouPronto: UILabel!
    
    // método chamado a cada timeInterval do timer
    @objc func timerAction() {
        
        estouPronto.isHidden = true
        counter += 1  // incrementa o contador do timer
        if (counter == target) { // para quando chega no target
            color = UIColor.green
            playPauseImage.isHidden = true
            viewDidLoad()  // atualiza a tela
        }
    }

    
    // GAME ON - TOUCH ACTION
    @IBAction func startTimerButtonTapped(sender: UIButton) {
        
        // Tentativa de acertar o verde o mais rápido possível
        if (counter != 0) {
            
            timer.invalidate() // pausa o timer
            resultado()
                
            counter = 0
            return
        } // finaliza tentativa

        start()
    }
    
    @IBOutlet weak var playPauseImage: UIImageView!
    
    func start() {
        color = UIColor.red
        playPauseImage.isHidden = false
        playPauseImage.alpha = 0.3
        viewDidLoad()
        
        target = Int.random(in: 1000...7000)
        
        // start the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    func restart() {
        scoreFinal.isHidden = true
        mediaFinal.isHidden = true
        timer.invalidate()
        estouPronto.isHidden = false
        color = UIColor.red
        viewDidLoad()
    }
    
    func rapidoDemais() {
        
        playPauseImage.isHidden = true
        
        if (round != 5) {
            
            let alert = UIAlertController(title: "Rápido demais...", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "tentar novamente", style: .default, handler: { _ in
                self.restart()
            }))
            self.present(alert, animated: true)
            currentScore = 1000
            
        } else if (round == 5) {
            
            let alert = UIAlertController(title: "FIM DE JOGO", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "encerrar", style: .default, handler: { _ in
                self.currentScore = 1000
                self.fimDeJogo()
            } ))
            self.present(alert, animated: true)
            
        }
        
    }
    
    func noTempoCerto() {
        
        difference = counter - target
        
        if (round != 5) {
            
            let alert = UIAlertController(title: "Muito bem!", message: "Diferença: \(difference)ms", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Próxima rodada", style: .default, handler: { _ in
                self.restart()
            }))
            self.present(alert, animated: true)
            
        } else if (round == 5) {
            
            let alert = UIAlertController(title: "FIM DE JOGO", message: "Diferença: \(difference)ms", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "encerrar", style: .default, handler: { _ in
                self.fimDeJogo()
            } ))
            self.present(alert, animated: true)

        }
        
        currentScore = difference
        
    }
    
    func resultado() {
       
        if (counter < target) {
            rapidoDemais()
        } else  {
            noTempoCerto()
        }
        
        if (round == 5) {
            round = 0
            score = 0
            currentScore = 0
        }
        
        
        score = score + currentScore
        round += 1
    }
    
    func fimDeJogo(){
        exibeResultadoFinal()
        restart()
    }
    
    @IBOutlet weak var mediaFinal: UILabel!
    
    func exibeResultadoFinal(){
        self.scoreFinal.text = ("\(score)")
        scoreFinal.isHidden = false
        mediaFinal.isHidden = false
        viewDidLoad()
    }
}
