//
//  Canvas.swift
//  PicturesArt
//
//  Created by Sevak Tadevosyan on 16.07.22.
//

import UIKit

extension EditViewController {
    
    func draw() {
        let size = canvasImageView.bounds.size
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        img.draw(in: canvasImageView.bounds)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        lines.forEach { line in
            context.setAlpha(line.opacity)
            context.setStrokeColor(line.color)
            context.setLineWidth(line.width)
            if line.type == .pen {
                for (i, p) in line.points.enumerated() {
                    if i == 0 {
                        context.move(to: p)
                    } else {
                        context.addLine(to: p)
                    }
                }
                context.strokePath()
            } else if line.type == .line {
                guard let first = line.points.first, let last = line.points.last else { return }
                context.strokeLineSegments(between: [first, last])
            }
        }
        canvasImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func undo() {
        guard let undoLine = lines.popLast() else { return }
        redoLines.append(undoLine)
        draw()
        canvasImageView.setNeedsDisplay()
    }
    
    func redo() {
        guard let last = redoLines.popLast() else { return }
        lines.append(last)
        draw()
        canvasImageView.setNeedsDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchsLocation = touches.first?.location(in: self.canvasImageView).y else { return }
        if touchsLocation >= canvasImageView.bounds.origin.y {
            if canvasImageView.image != nil && lines.count == 0 {
                img = canvasImageView.image!
            }
            var line = Line()
            if !eraserToolButton.isSelected {
                line.color = PenConfiguration.shared.penColor
            }
            lines.append(line)
            configureUndoRedoButtonStates()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self.canvasImageView) else { return }
        guard var lastLine = lines.popLast() else { return }
        lastLine.points.append(point)
        lines.append(lastLine)
        redoLines.removeAll()
        draw()
        canvasImageView.setNeedsDisplay()
    }
}
