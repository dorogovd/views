//
//  GameFieldView.swift
//  YandexViews
//
//  Created by Dmitrii Dorogov on 21.09.2023.
//

import UIKit

class gameFieldView: UIView { // Отрисовка фигуры внутри поля вручную
    var shapeColor: UIColor = .red // цвет фигуры - значение по умолчанию
    var shapePosition: CGPoint = .zero // координата верхнего левого угла прямоугольника для размещения фигуры
    var shapeSize: CGSize = CGSize(width: 40, height: 40) // размер этого прямоугольника
    override func draw(_ rect: CGRect) { // переопределяем метод дроу рект для ручной отрисовки внутри представления (view)
        super.draw(rect) // вызов реализации медода из класса родителя
        shapeColor.setFill() // устанавливаем свой цвет
        let path = getTrianglePath(in: CGRect(origin: shapePosition, size: shapeSize))
        path.fill()
    }
    
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
