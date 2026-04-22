//import UIKit
//import PDFKit
//
//struct ReportGenerator {
//    
//    static func createPDF(patient: Patient, timeline: [Timeline]) -> URL? {
//        
//        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
//        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
//        
//        let fileName = "CaseHistory_\(patient.name.replacingOccurrences(of: " ", with: "_")).pdf"
//        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
//        
//        do {
//            try renderer.writePDF(to: tempURL) { context in
//                
//                var yOffset: CGFloat = 50
//                
//                let titleFont = UIFont.boldSystemFont(ofSize: 20)
//                let headerFont = UIFont.boldSystemFont(ofSize: 16)
//                let bodyFont = UIFont.systemFont(ofSize: 12)
//                
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateStyle = .medium
//                
//                func newPageIfNeeded(height: CGFloat) {
//                    if yOffset + height > pageRect.height - 50 {
//                        context.beginPage()
//                        yOffset = 50
//                    }
//                }
//                
//                context.beginPage()
//                
//                // MARK: Title
//                "Clinical Case History".draw(
//                    at: CGPoint(x: 50, y: yOffset),
//                    withAttributes: [.font: titleFont]
//                )
//                yOffset += 40
//                
//                // MARK: Patient Info
//                "Patient: \(patient.name)".draw(
//                    at: CGPoint(x: 50, y: yOffset),
//                    withAttributes: [.font: bodyFont]
//                )
//                yOffset += 20
//                
//                let conditionText = patient.condition ?? "N/A"
//                "Condition: \(conditionText)".draw(
//                    at: CGPoint(x: 50, y: yOffset),
//                    withAttributes: [.font: bodyFont]
//                )
//                yOffset += 30
//                
//                // MARK: Timeline Header
//                "Treatment Timeline".draw(
//                    at: CGPoint(x: 50, y: yOffset),
//                    withAttributes: [.font: headerFont]
//                )
//                yOffset += 25
//                
//                // MARK: Timeline Content
//                for item in timeline {
//                    
//                    newPageIfNeeded(height: 80)
//                    
//                    let dateStr = "\(dateFormatter.string(from: item.date)) \n \(item.title)"
//                    
//                    dateStr.draw(
//                        at: CGPoint(x: 50, y: yOffset),
//                        withAttributes: [.font: bodyFont]
//                    )
//                    
//                    yOffset += 18
//                    
//                    let descRect = CGRect(x: 60, y: yOffset, width: 480, height: 100)
//                    
//                    let descHeight = item.description.boundingRect(
//                        with: CGSize(width: 480, height: CGFloat.greatestFiniteMagnitude),
//                        options: .usesLineFragmentOrigin,
//                        attributes: [.font: bodyFont],
//                        context: nil
//                    ).height
//                    
//                    item.description.draw(
//                        with: descRect,
//                        options: .usesLineFragmentOrigin,
//                        attributes: [.font: bodyFont],
//                        context: nil
//                    )
//                    
//                    yOffset += descHeight + 15
//                }
//            }
//            
//            return tempURL
//            
//        } catch {
//            print("could not create PDF: \(error)")
//            return nil
//        }
//    }
//}



import UIKit
import PDFKit

struct ReportGenerator {
    
    static func createPDF(patient: Patient, timeline: [Timeline]) -> URL? {
        
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        
        let fileName = "CaseHistory_\(patient.name.replacingOccurrences(of: " ", with: "_")).pdf"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try renderer.writePDF(to: tempURL) { context in
                
                var yOffset: CGFloat = 50
                
                let titleFont = UIFont.boldSystemFont(ofSize: 20)
                let headerFont = UIFont.boldSystemFont(ofSize: 16)
                let bodyFont = UIFont.systemFont(ofSize: 12)
                let boldFont = UIFont.boldSystemFont(ofSize: 13)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                
                func newPageIfNeeded(height: CGFloat) {
                    if yOffset + height > pageRect.height - 50 {
                        context.beginPage()
                        yOffset = 50
                    }
                }
                
                context.beginPage()
                
                // MARK: Title
                "Clinical Case History".draw(
                    at: CGPoint(x: 50, y: yOffset),
                    withAttributes: [.font: titleFont]
                )
                yOffset += 40
                
                // MARK: Patient Info
                "Patient: \(patient.name)".draw(
                    at: CGPoint(x: 50, y: yOffset),
                    withAttributes: [.font: bodyFont]
                )
                yOffset += 20
                
                let conditionText = patient.condition ?? "N/A"
                "Condition: \(conditionText)".draw(
                    at: CGPoint(x: 50, y: yOffset),
                    withAttributes: [.font: bodyFont]
                )
                yOffset += 30
                
                // MARK: Header
                "Treatment Timeline".draw(
                    at: CGPoint(x: 50, y: yOffset),
                    withAttributes: [.font: headerFont]
                )
                yOffset += 25
                
                // MARK: Timeline
                for item in timeline {
                    
                    let dateText = dateFormatter.string(from: item.date)
                    
                    // Calculate heights first
                    let dateHeight = dateText.height(with: bodyFont, width: 500)
                    let titleHeight = item.title.height(with: boldFont, width: 500)
                    let descHeight = item.description.height(with: bodyFont, width: 480)
                    
                    let totalHeight = dateHeight + titleHeight + descHeight + 30
                    newPageIfNeeded(height: totalHeight)
                    
                    // DATE
                    dateText.draw(
                        in: CGRect(x: 50, y: yOffset, width: 500, height: dateHeight),
                        withAttributes: [.font: bodyFont]
                    )
                    yOffset += dateHeight + 4
                    
                    // TITLE
                    item.title.draw(
                        in: CGRect(x: 50, y: yOffset, width: 500, height: titleHeight),
                        withAttributes: [.font: boldFont]
                    )
                    yOffset += titleHeight + 6
                    
                    // DESCRIPTION
                    item.description.draw(
                        in: CGRect(x: 60, y: yOffset, width: 480, height: descHeight),
                        withAttributes: [.font: bodyFont]
                    )
                    yOffset += descHeight + 15
                }
            }
            
            return tempURL
            
        } catch {
            print("could not create PDF: \(error)")
            return nil
        }
    }
}

extension String {
    func height(with font: UIFont, width: CGFloat) -> CGFloat {
        return self.boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        ).height
    }
}
