//
//  ViewController.swift
//  SaifZoomy
//
//  Created by Saifur Rahman on 27/06/24.
//

import UIKit
import UIKit

class ViewController: UIViewController {
    // MARK: Variables
    private var imageView: UIImageView!

    private var zoom: Double = 1.0
    private var offsetX: Double = 0.0
    private var offsetY: Double = 0.0

    private let mandelbrot = MakeMandlebrot(width: 800, height: 600, zoom: 1.0, offsetX: 0.0, offsetY: 0.0)

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        imageView.addGestureRecognizer(panRecognizer)

        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        imageView.addGestureRecognizer(pinchRecognizer)
        imageView.image = #imageLiteral(resourceName: "BOY")
        updateMandelbrot()
    }
    // MARK: Pan gesture
    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: imageView)
        offsetX -= Double(translation.x) / zoom
        offsetY += Double(translation.y) / zoom
        recognizer.setTranslation(.zero, in: imageView)
        updateMandelbrot()
    }
    // MARK: Zoom Gesture
    @objc private func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .changed {
            zoom *= Double(recognizer.scale)
            recognizer.scale = 1.0
            updateMandelbrot()
        }
    }

    // MARK: Update Brot
    private func updateMandelbrot() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let mandelbrotImage = self.mandelbrot.makeMandelbrot()
            DispatchQueue.main.async {
                self.imageView.image = mandelbrotImage
            }
        }
    }
}
