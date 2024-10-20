//
//  MockData.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/26/23.
//

import Foundation
import SwiftData
import SwiftSoup

@MainActor
class MockData {
    
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Book.self, configurations: config)
            
            for book in MockData.books {
                container.mainContext.insert(book)
            }
            
            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
    
    static let books: [Book] = {
        [
            Book(id: "1", title: "All Tomorrow's Parties", author: "William Gibson", modifiedAt: Date(), coverImageURL: URL(string: "https://m.media-amazon.com/images/I/81Dd92++GgS._SY160.jpg")),
            Book(id: "2", title: "Idoru", author: "William Gibson", modifiedAt: Date.distantPast, coverImageURL: URL(string: "https://m.media-amazon.com/images/I/81Dd92++GgS._SY160.jpg")),
            Book(id: "3", title: "Virtual Light", author: "William Gibson", modifiedAt: Date.distantPast, coverImageURL: URL(string: "https://m.media-amazon.com/images/I/81Dd92++GgS._SY160.jpg")),
        ]
    }()
    
    static let bookWithHighlights: Book = {
        let book = MockData.books.first!
        book.highlights = [MockData.highlight]
        return book
    }()
    
    static let highlight: Highlight = {
        let document = try! SwiftSoup.parse(MockData.mockHighlightHTML)
        let element = try! document.select("#QTIzRkhUSFVLRTgwRFc6QjA4RE1XUFNNNToxMjE5MjpISUdITElHSFQ6YWEzN2QwODFiLTI0YjQtNGEyNS1hY2VmLWE1NjNjYzRhMGY5ZQ").first()!

        return try! Highlight(for: MockData.books.first!, from: element)
    }()
    
    static let mockHighlightHTML: String = """
        <div id="QTIzRkhUSFVLRTgwRFc6QjA4RE1XUFNNNToxMjE5MjpISUdITElHSFQ6YWEzN2QwODFiLTI0YjQtNGEyNS1hY2VmLWE1NjNjYzRhMGY5ZQ" class="a-row a-spacing-base">
         <div class="a-column a-span10 kp-notebook-row-separator">
          <!-- Header row containing: optionally a star, note/highlight label, page/location information, and an
                    options dropdown -->
          <div class="a-row">
           <input type="hidden" name="" value="82" id="kp-annotation-location" />
           <!-- optional star, note/highlight label, page/location -->
           <div class="a-column a-span8">
            <!-- Star, if necessary -->
            <!-- Highlight -->
            <!-- Highlight header -->
            <span id="annotationHighlightHeader" class="a-size-small a-color-secondary kp-notebook-selectable kp-notebook-metadata">Yellow highlight | Location:&nbsp;82</span>
            <!-- Note header in case highlight is deleted, and we need to have the note header -->
            <span id="annotationNoteHeader" class="a-size-small a-color-secondary aok-hidden kp-notebook-selectable kp-notebook-metadata">Note | Location:&nbsp;82</span>
            <!-- Freestanding note header -->
           </div>
           <!-- the Options menu -->
           <div class="a-column a-span4 a-text-right a-span-last">
            <span class="a-declarative" data-action="a-popover" data-csa-c-type="widget" data-csa-c-func-deps="aui-da-a-popover" data-a-popover="{&quot;closeButton&quot;:&quot;false&quot;,&quot;closeButtonLabel&quot;:&quot;Close&quot;,&quot;activate&quot;:&quot;onclick&quot;,&quot;width&quot;:&quot;200&quot;,&quot;name&quot;:&quot;optionsPopover&quot;,&quot;position&quot;:&quot;triggerVerticalAlignLeft&quot;,&quot;popoverLabel&quot;:&quot;Options for annotations at Location 82&quot;}" id="popover-QTIzRkhUSFVLRTgwRFc6QjA4RE1XUFNNNToxMjE5MjpISUdITElHSFQ6YWEzN2QwODFiLTI0YjQtNGEyNS1hY2VmLWE1NjNjYzRhMGY5ZQ-action"><a id="popover-QTIzRkhUSFVLRTgwRFc6QjA4RE1XUFNNNToxMjE5MjpISUdITElHSFQ6YWEzN2QwODFiLTI0YjQtNGEyNS1hY2VmLWE1NjNjYzRhMGY5ZQ" href="javascript:void(0)" role="button" class="a-popover-trigger a-declarative">Options<i class="a-icon a-icon-popover"></i></a></span>
           </div>
          </div>
          <!-- Container for text content of the note / highlight -->
          <div class="a-row a-spacing-top-medium">
           <div class="a-column a-span10 a-spacing-small kp-notebook-print-override">
            <!-- Highlight with a child note -->
            <!-- Highlight without a child note -->
            <!-- Highlight text -->
            <div id="highlight-QTIzRkhUSFVLRTgwRFc6QjA4RE1XUFNNNToxMjE5MjpISUdITElHSFQ6YWEzN2QwODFiLTI0YjQtNGEyNS1hY2VmLWE1NjNjYzRhMGY5ZQ" class="a-row kp-notebook-highlight kp-notebook-selectable kp-notebook-highlight-yellow">
             <span id="highlight" class="a-size-base-plus a-color-base">The same grave epiphany was dragged around everywhere: we were transitioning from an only retrospectively easy past to an inarguably more difficult future; we were, it could no longer be denied, unstoppably bad.</span>
             <div></div>
            </div>
            <!-- Placeholder for if a child note is added by the customer -->
            <div id="note-" class="a-row a-spacing-top-base kp-notebook-note aok-hidden kp-notebook-selectable">
             <span id="note-label" class="a-size-small a-color-secondary">Note:<span class="a-letter-space"></span></span>
             <span id="note" class="a-size-base-plus a-color-base"></span>
            </div>
            <!-- Orphaned note without associated highlight -->
           </div>
          </div>
         </div>
        </div>
        """
}
