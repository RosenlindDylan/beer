import SwiftUI
import VisionKit
import Vision

struct BarcodeScannerView: View {
    @Binding var isShowingScanner: Bool
    @Binding var scannedText: String
    
    var body: some View {
        // Main Scanner Content
        Group {
            if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                ZStack(alignment: .bottom) {
                    DataScannerRepresentable(
                        shouldStartScanning: $isShowingScanner,
                        scannedText: $scannedText,
                        dataToScanFor: [.barcode()]
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        // Close (“X”) button
        Button(action: {
            isShowingScanner = false
        }) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 32))
                .foregroundColor(.white)
                .shadow(radius: 4)
        }
        .padding(.top, 16)
        .padding(.leading, 16)
    }
}
