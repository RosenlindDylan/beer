import SwiftUI
import VisionKit
internal import Vision

struct BarcodeScannerView: View {
    @State var isShowingScanner = true
    @State private var scannedText = ""
    
    var body: some View {
        if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
            ZStack(alignment: .bottom) {
                DataScannerRepresentable(
                    shouldStartScanning: $isShowingScanner,
                    scannedText: $scannedText,
                    dataToScanFor: [.barcode(symbologies: [.qr])]
                )
                
                Text(scannedText)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
            }
        } else if !DataScannerViewController.isSupported {
            Text("It looks like this device doesn't support the DataScannerViewController")
        } else {
            Text("It appears your camera may not be available")
        }
    }
}
