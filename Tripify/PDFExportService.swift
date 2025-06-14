//
//  PDFExportService.swift
//  Tripify
//
//  Created by Krishay Gahlaut on 14/06/25.
//

import UIKit
import PDFKit

struct PDFExportService {
    static func generatePDF(for trip: Trip, itinerary: [ItineraryItem]) -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Tripify",
            kCGPDFContextAuthor: "Krishay Gahlaut"
        ]

        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 612.0
        let pageHeight = 792.0
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)

        let data = renderer.pdfData { context in
            context.beginPage()
            var y = 20.0

            func drawText(_ text: String, bold: Bool = false, size: CGFloat = 16) {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineBreakMode = .byWordWrapping

                let attrs: [NSAttributedString.Key: Any] = [
                    .font: bold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size),
                    .paragraphStyle: paragraphStyle
                ]

                let attributed = NSAttributedString(string: text, attributes: attrs)
                attributed.draw(in: CGRect(x: 20, y: y, width: pageWidth - 40, height: 100))
                y += 24
            }

            drawText("🛫 Trip Plan: \(trip.name)", bold: true, size: 20)
            drawText("Destination: \(trip.destination)")
            drawText("Dates: \(trip.startDate.formatted()) → \(trip.endDate.formatted())")
            drawText("Notes: \(trip.notes)")

            y += 16
            drawText("🗓️ Itinerary:", bold: true, size: 18)

            for item in itinerary {
                drawText("• \(item.title) at \(item.time.formatted(date: .omitted, time: .shortened))")
                if !item.notes.isEmpty {
                    drawText("   ⤷ \(item.notes)", size: 14)
                }
            }
        }

        return data
    }
}
