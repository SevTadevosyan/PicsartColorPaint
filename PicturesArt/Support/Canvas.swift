//
//  Canvas.swift
//  PicturesArt
//
//  Created by Sevak Tadevosyan on 16.07.22.
//

import UIKit

protocol CanvasDelegate: AnyObject {
    func didTapped()
}

class Canvas: UIView {
    
    
    var lines = [Line]()
    var redoLines = [Line]()
    var delegate: CanvasDelegate?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        switch PenConfiguration.shared.type {
        case .pen:
            context.setLineCap(.round)
            context.setLineJoin(.round)
            lines.forEach { line in
                for (i, p) in line.points.enumerated() {
                    if i == 0 {
                        context.move(to: p)
                    } else {
                        context.addLine(to: p)
                    }
                }
                context.setAlpha(line.opacity)
                context.setStrokeColor(line.color)
                context.setLineWidth(line.width)
                context.strokePath()
            }
        case .line:
            guard let line = lines.last else { return }
            context.strokeLineSegments(between: [line.points.first!, line.points.last!])
        }
    }
    
    func undo() {
        guard let undoLine = lines.popLast() else { return }
        redoLines.append(undoLine)
        setNeedsDisplay()
    }
    
    func redo() {
        guard let last = redoLines.popLast() else { return }
        lines.append(last)
        setNeedsDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTapped()
        let line = Line()
        lines.append(line)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        guard var lastLine = lines.popLast() else { return }
        lastLine.points.append(point)
        lines.append(lastLine)
        redoLines.removeAll()
        setNeedsDisplay()
    }
}
