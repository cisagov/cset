////////////////////////////////
//
//   Copyright 2023 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { Component, Input, OnInit } from '@angular/core';
import { ConfigService } from '../../../services/config.service';
import { CustomDocument } from '../../../models/question-extras.model';
import { ResourceLibraryService } from '../../../services/resource-library.service';

/**
 * Displays references for a question in a more concise way than
 * the old table.
 */
@Component({
  selector: 'app-references-display',
  templateUrl: './references-display.component.html'
})
export class ReferencesDisplayComponent implements OnInit {

  @Input()
  tab: any;

  @Input('q')
  question: any;

  sourceDocuments: CustomDocument[] = [];

  additionalDocuments: CustomDocument[] = [];

  /**
   *
   */
  constructor(
    public configSvc: ConfigService,
    private resourceLibSvc: ResourceLibraryService
  ) { }

  /**
   *
   */
  ngOnInit(): void {
    // group section_Refs (bookmarks) with their documents
    this.sourceDocuments = this.groupDocumentBookmarks(this.tab.sourceDocumentsList);
    this.additionalDocuments = this.groupDocumentBookmarks(this.tab.additionalDocumentsList);
  }

  /**
   * Creates a list with one instance of each document.  The document instance
   * has a collection of all of its bookmarks.
   */
  groupDocumentBookmarks(docList): CustomDocument[] {
    const list: CustomDocument[] = [];

    docList?.forEach(ref => {
      let listDoc: CustomDocument = list.find(d => d.file_Name == ref.file_Name && d.title == ref.title);
      if (!listDoc) {
        listDoc = {
          file_Id: ref.file_Id,
          file_Name: ref.file_Name?.trim(),
          title: ref.title.trim(),
          is_Uploaded: ref.is_Uploaded,
          bookmarks: []
        };
        list.push(listDoc);
      }

      listDoc.bookmarks.push(ref.section_Ref.trim());
    });

    return list;
  }

  /**
    * Replaces all occurrences of the token {{ cset_document_url }}
    * with the application's document URL.
    */
  replaceDocUrl(s: string) {
    return s.replaceAll("{{ cset_document_url }}", this.configSvc.docUrl);
  }

  /**
   * Formats a URL to the document.  Handles uploaded documents via the
   * 'ReferenceDocument' endpoint as well as direct PDFs stored on the
   * file system in the API.
   * Bookmarks to an actual section_Ref are appended to the URL.
   */
  documentUrl(doc: CustomDocument, bookmark: string) {
    this.resourceLibSvc.documentUrl(doc, bookmark);
  }

  /**
   * Formats the text of the bookmark link.
   */
  bookmarkDisplay(bookmark: string) {
    if (bookmark == '') {
      return 'document';
    } else {
      return bookmark;
    }
  }

  /**
   *
   */
  areNoReferenceDocumentsAvailable() {
    return (!this.tab?.referenceTextList || this.tab.referenceTextList.length === 0)
      && (!this.tab?.sourceDocumentsList || this.tab.sourceDocumentsList.length === 0)
      && (!this.tab?.additionalDocumentsList || this.tab.additionalDocumentsList.length === 0)
      && (!this.question?.csfMappings || this.question.csfMappings.length == 0)
      && (!this.question?.ttp || this.question.ttp.length == 0)
      && (!this.question?.riskAddressed)
  }
}
