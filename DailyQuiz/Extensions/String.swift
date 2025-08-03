//
//  String.swift
//  DailyQuiz
//
//  Created by Denis Shabanov on 03.08.2025.
//

import Foundation

extension String {
    
    var removingHTMLTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
    
    var decodingHTMLEntities: String {
        let attributedString = try? NSAttributedString(
            data: Data(self.utf8),
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        )
        return attributedString?.string ?? self
    }
    
    
    var cleanedHTMLString: String {
        return self.removingHTMLTags.decodingHTMLEntities
    }
    
}
