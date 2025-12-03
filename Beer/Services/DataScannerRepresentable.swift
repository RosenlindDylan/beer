import SwiftUI
import VisionKit

struct DataScannerRepresentable: UIViewControllerRepresentable {
    @Binding var shouldStartScanning: Bool
    @Binding var scannedText: String
    var dataToScanFor: Set<DataScannerViewController.RecognizedDataType>
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
       var parent: DataScannerRepresentable
       
       init(_ parent: DataScannerRepresentable) {
           self.parent = parent
       }
               
        // Called when user taps a recognized item
        func dataScanner(_ dataScanner: DataScannerViewController,
                         didTapOn item: RecognizedItem) {
            handle(item: item)
        }

        // Called automatically when new items appear in the camera feed
        func dataScanner(_ dataScanner: DataScannerViewController,
                         didAdd addedItems: [RecognizedItem],
                         allItems: [RecognizedItem]) {
            // e.g. just take the first one
            if let first = addedItems.first {
                handle(item: first)
            }
        }

        private func handle(item: RecognizedItem) {
            switch item {
            case .barcode(let barcode):
                parent.scannedText = barcode.payloadStringValue ?? "No payload"
            case .text(let text):
                parent.scannedText = text.transcript
            default:
                break
            }
        }
    }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let dataScannerVC = DataScannerViewController(
            recognizedDataTypes: dataToScanFor,
            qualityLevel: .accurate,
            recognizesMultipleItems: true,
            isHighFrameRateTrackingEnabled: true,
            isPinchToZoomEnabled: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        
        dataScannerVC.delegate = context.coordinator
       
       return dataScannerVC
    }

    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
       if shouldStartScanning {
           try? uiViewController.startScanning()
       } else {
           uiViewController.stopScanning()
       }
    }

    func makeCoordinator() -> Coordinator {
       Coordinator(self)
    }
}
