//
//  ViewController.swift
//  YandexViews
//
//  Created by Dmitrii Dorogov on 16.09.2023.
//

// при нажатии кнопки старт начинают появляться фигуры в произвольных местах поля, пользоватьель должен нажать на них, после истечения времени (или при нажатии на кнопку стоп) игра заканчивается и отображается счет (кол-во попаданий по треугольникам)
// фигура смещается в пределах поля через равные интервалы времени

import UIKit

class ViewController: UIViewController {
    
    @IBAction func stepperChanged(_ sender: UIStepper) { // кнопка степпер
        updateUI()
    }
    
    @IBOutlet weak var stepper: UIStepper! // степпер
    @IBOutlet weak var timeLabel: UILabel! // лэйбл "время"
    @IBOutlet weak var scoreLabel: UILabel! // лэйбл последний счёт
    @IBOutlet weak var gameFieldView: UIView! // вьюшка "игровое поле"
    @IBOutlet weak var actionButton: UIButton! // кнопка "старт"
    @IBOutlet weak var shapeX: NSLayoutConstraint! // констрейнт фигуры (по умолчанию равен 0)
    @IBOutlet weak var shapeY: NSLayoutConstraint! // констрейнт фигуры (по умолчанию равен 0)
    @IBOutlet weak var gameObject: UIImageView! // аутлет фигуры
    
    @IBAction func actionButtonTapped(_ sender: UIButton) { // кнопка "старт"
        if isGameActive {
            stopGame()
        } else {
            startGame()
        }
    }
    
    @IBAction func objectTapped(_ sender: UITapGestureRecognizer) {
        guard isGameActive else { return } // защита от нажатия пока игра не активна
            repositionImageWithTimer()
            score += 1
        }
    
    private var isGameActive = false
    private var gameTimeLeft: TimeInterval = 0
    private var gameTimer: Timer? // таймер игры
    private var timer: Timer? // таймер движения фигуры
    private let displayDuration: TimeInterval = 2 // время задержки фигуры на одном месте
    private var score = 0
    
    private func startGame () {
        score = 0
        repositionImageWithTimer()
        // gameTimer?.invalidate() // перед запуском нового таймера предыдущий необходимо остановить
        gameTimer = Timer.scheduledTimer( // настройки таймера
            timeInterval: 1, // интервал вызова функции в секундах
            target: self, // объект у которого нужно вызвать функцию (self - текущий объект)
            selector: #selector(gameTimerTick), // селектор указывает функцию которую необходимо вызвать когда-то позже
            userInfo: nil, // доп информация, которая может быть передана вызываемой функции
            repeats: true // необходимо ли повторять вызов функции
        )
        gameTimeLeft = stepper.value
        isGameActive = true
        updateUI()
    }
    private func stopGame() {
        isGameActive = false
        updateUI()
        gameTimer?.invalidate() // остановка таймера
        timer?.invalidate()
        scoreLabel.text = "Last score: \(score)" // обновляем счёт в конце игры
    }
    
    private func repositionImageWithTimer() { // перемещение фигуры
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: displayDuration,
            target: self,
            selector: #selector(moveImage),
            userInfo: nil,
            repeats: true)
        timer?.fire() // метод .fire - вызов функции сразу вначале игры а не через сколько-то секунд
        
    }
    
    private func updateUI() {
        gameObject.isHidden = !isGameActive // фигура появляется только после начала игры
        stepper.isEnabled = !isGameActive // кнопка степпер активна только вне игры
        if isGameActive {
            timeLabel.text = "Time left: \(Int(gameTimeLeft)) sec"
            actionButton.setTitle("Stop", for: .normal)
        } else {
            timeLabel.text = "Time: \(Int(stepper.value)) sec"
            actionButton.setTitle("Start", for: .normal)
        }
    }
    
    @objc private func gameTimerTick() { // таймер игры
        gameTimeLeft -= 1
        if gameTimeLeft <= 0 {
            stopGame()
        } else {
            updateUI()
        }
    }
    
    @objc private func moveImage() { // перемещение фигуры по полю
        let maxX = gameFieldView.bounds.maxX - gameObject.frame.width // ограничиваем макс значения констрейнтов фигуры размерами поля (минус размеры фигуры, чтобы она не вылезала за экран)
        let maxY = gameFieldView.bounds.maxY - gameObject.frame.height
        shapeX.constant = CGFloat(arc4random_uniform(UInt32(maxX))) // генерирует случайные числа
        shapeY.constant = CGFloat(arc4random_uniform(UInt32(maxY)))
    }
    
    override func viewDidLoad() { // метод вызывается после закрузки всех вьюшек
        super.viewDidLoad()
        
        gameFieldView.layer.borderWidth = 1
        gameFieldView.layer.borderColor = UIColor.gray.cgColor
        gameFieldView.layer.cornerRadius = 5
        updateUI()
    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
}

