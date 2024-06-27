//
//  MakemandleBrot.swift
//  SaifZoomy
//
//  Created by Saifur Rahman on 27/06/24.
//

import Foundation
import UIKit

class MakeMandlebrot {
    private let maxIterations = 1000
    private let escapeRadius = 2.0

    private var width: Int
    private var height: Int
    private var zoom: Double
    private var offsetX: Double
    private var offsetY: Double
    // MARK: Initialize brot
    init(width: Int, height: Int, zoom: Double, offsetX: Double, offsetY: Double) {
        self.width = width
        self.height = height
        self.zoom = zoom
        self.offsetX = offsetX
        self.offsetY = offsetY
    }
    // MARK: make Brot and return image
    func makeMandelbrot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.setFillColor(UIColor.black.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))

        let pixelBuffer = context.data!.assumingMemoryBound(to: UInt32.self)

        for y in 0..<height {
            for x in 0..<width {
                let cx = Double(x) / Double(width) * 3.5 / zoom - 2.5 + offsetX
                let cy = Double(y) / Double(height) * 2.0 / zoom - 1.0 + offsetY

                var zx = 0.0
                var zy = 0.0
                var i = 0

                while (zx * zx + zy * zy < escapeRadius * escapeRadius) && (i < maxIterations) {
                    let zxNew = zx * zx - zy * zy + cx
                    let zyNew = 2.0 * zx * zy + cy
                    zx = zxNew
                    zy = zyNew
                    i += 1
                }

                let color: UInt32
                if i == maxIterations {
                    color = 0x00000000
                } else {
                    let c = 1.0 - Double(i) / Double(maxIterations)
                    let r = Int(255 * c)
                    let g = Int(255 * c)
                    let b = Int(255 * c)
                    color = UInt32((255 << 24) | (r << 16) | (g << 8) | b)
                }

                pixelBuffer[y * width + x] = color
            }
        }

        guard let cgImage = context.makeImage() else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
