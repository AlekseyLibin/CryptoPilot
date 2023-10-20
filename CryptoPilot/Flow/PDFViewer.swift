//
//  PDFViewer.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 18.10.2023.
//

import SwiftUI
import PDFKit

struct PDFViewer: View {
  @Binding var screenIsActive: Bool
  var pdfURL: URL
  
  var body: some View {
    NavigationView {
      PDFKitView(url: pdfURL)
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button("Done") {
              screenIsActive = false
            }
          }
        }
    }
  }
  
  struct PDFKitView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> PDFView {
      let pdfView = PDFView()
      pdfView.autoScales = true
      pdfView.document = PDFDocument(url: url)
      return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
      // Update the view
    }
  }
}
