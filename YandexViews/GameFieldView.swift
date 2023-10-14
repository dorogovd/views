//
//  GameFieldView.swift
//  YandexViews
//
//  Created by Dmitrii Dorogov on 21.09.2023.
//

import UIKit

@IBDesignable // аннотация для того чтобы в сторибордах работал код кастомных представлений (чзхуйня)
class GameFieldView: UIView { // Отрисовка фигуры внутри поля вручную
    @IBInspectable var shapeColor: UIColor = .red { // цвет фигуры - значение по умолчанию
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shapePosition: CGPoint = .zero { // координата верхнего левого угла прямоугольника для размещения фигуры
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shapeSize: CGSize = CGSize(width: 40, height: 40) { // размер этого прямоугольника
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var isShapeHidden: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    var shapeHitHandler: (() -> Void)?
    
    override func draw(_ rect: CGRect) { // переопределяем метод дроу рект для ручной отрисовки внутри представления (view)
        super.draw(rect) // вызов реализации медода из класса родителя
        guard !isShapeHidden else {
            curPath = nil
            return
        }
        shapeColor.setFill() // устанавливаем свой цвет
        let path = getTrianglePath(in: CGRect(origin: shapePosition, size: shapeSize))
        path.fill()
        curPath = path
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let curPath = curPath else { return }
        let hit = touches.contains(where: { touch -> Bool in
            let touchPoint = touch.location(in: self)
            return curPath.contains(touchPoint)
        })
        if hit {
            shapeHitHandler?()
        }
    }
    
    func randomizeShapes() {
        let maxX = bounds.maxX - shapeSize.width // ограничиваем макс значения констрейнтов фигуры размерами поля (минус размеры фигуры, чтобы она не вылезала за экран)
        let maxY = bounds.maxY - shapeSize.height
        let x = CGFloat(arc4random_uniform(UInt32(maxX))) // генерирует случайные числа
        let y = CGFloat(arc4random_uniform(UInt32(maxY)))
        shapePosition = CGPoint(x: x, y: y)
    }
    
    private var curPath: UIBezierPath?
    
    private func getTrianglePath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 0
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.close()
        path.stroke()
        path.fill()
        return path
    }
}
