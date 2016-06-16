//
//  AIWaterView.swift
//  AIVeris
//
// Copyright (c) 2016 ___ASIAINFO___
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import Spring

class AIWaterView: DesignableView {
    
    
    override func drawRect(rect: CGRect) {
        // 半径
        let rabius: CGFloat = 30
        // 开始角
        let startAngle: CGFloat = 0
        // 中心点
        let point: CGPoint = CGPointMake(40, 40)
        // 中心店我手动写的,你看看怎么弄合适 自己在搞一下
        // 结束角
        let endAngle: CGFloat = CGFloat(2*M_PI)
        let path: UIBezierPath = UIBezierPath(arcCenter: point, radius: rabius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let layer: CAShapeLayer = CAShapeLayer()
        layer.path = path.CGPath
        // 添加路径 下面三个同理
        layer.strokeColor = UIColor(hex: "2e2e6a").CGColor
        layer.fillColor = UIColor(hexString: "2e2e6a",alpha: 0.6).CGColor
        self.layer.addSublayer(layer)
    }
    
}