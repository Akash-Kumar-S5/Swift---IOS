import AVFoundation
import SwiftUI

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let container = UIView(frame: .zero)
        let previewView = UIView()
        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewView.layer.borderColor = UIColor.white.cgColor
        previewView.layer.borderWidth = 2
        container.addSubview(previewView)

        NSLayoutConstraint.activate([
            previewView.centerXAnchor.constraint(
                equalTo: container.centerXAnchor
            ),
            previewView.centerYAnchor.constraint(
                equalTo: container.centerYAnchor
            ),
            previewView.widthAnchor.constraint(
                equalTo: container.widthAnchor
            ),
            previewView.heightAnchor.constraint(
                equalTo: previewView.widthAnchor,
                multiplier: 4 / 3
            ),
        ])

        #if targetEnvironment(simulator)
            previewView.backgroundColor = .black
            let label = UILabel()
            label.text = "📷 Simulator"
            label.textColor = .white
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 24)
            label.translatesAutoresizingMaskIntoConstraints = false
            previewView.addSubview(label)
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(
                    equalTo: previewView.centerXAnchor
                ),
                label.centerYAnchor.constraint(
                    equalTo: previewView.centerYAnchor
                ),
            ])
        #else
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = previewView.bounds
            previewView.layer.insertSublayer(previewLayer, at: 0)
            context.coordinator.previewLayer = previewLayer
        #endif

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        #if !targetEnvironment(simulator)
            if let previewLayer = context.coordinator.previewLayer,
                let previewView = uiView.subviews.first
            {
                previewLayer.frame = previewView.bounds
            }
        #endif
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    class Coordinator {
        var previewLayer: AVCaptureVideoPreviewLayer?
    }
}
