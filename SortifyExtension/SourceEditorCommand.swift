//
//  SourceEditorCommand.swift
//  SortifyExtension
//
//  Created by Francisco Amado on 24/09/2018.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {

        let selections = invocation.buffer.selections
        let lines = invocation.buffer.lines

        let selection = selections.compactMap { $0 as? XCSourceTextRange }.first

        if let startingLine = selection?.start.line, let endingLine = selection?.end.line {

            let linesRange = NSRange(location: startingLine, length: endingLine + 1 - startingLine)

            let sortedLines = lines
                .subarray(with: linesRange)
                .compactMap { $0 as? String }
                .sorted { $0.trimmed.caseInsensitiveCompare($1.trimmed) == .orderedAscending }

            invocation.buffer.lines.replaceObjects(in: linesRange, withObjectsFrom: sortedLines)
        }

        // Invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        completionHandler(nil)
    }
}

private extension String {

    var trimmed: String {

        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
