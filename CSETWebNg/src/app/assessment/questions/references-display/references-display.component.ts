////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
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
import { ReferenceDocLink } from '../../../models/question-extras.model';
import { ResourceLibraryService } from '../../../services/resource-library.service';
import { TranslocoService } from '@ngneat/transloco';

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

  sourceDocuments: ReferenceDocLink[] = [];

  additionalDocuments: ReferenceDocLink[] = [];

  /**
   *
   */
  constructor(
    public configSvc: ConfigService,
    public tSvc: TranslocoService,
    private resourceLibSvc: ResourceLibraryService
  ) { }

  /**
   *
   */
  ngOnInit(): void {
    // group sectionRefs (bookmarks) with their documents
    this.sourceDocuments = this.groupDocumentBookmarks(this.tab.sourceDocumentsList);
    this.additionalDocuments = this.groupDocumentBookmarks(this.tab.additionalDocumentsList);
  }

  /**
   * Creates a list with one instance of each document.  The document instance
   * has a collection of all of its bookmarks.
   */
  groupDocumentBookmarks(docList): ReferenceDocLink[] {
    const list: ReferenceDocLink[] = [];

    docList?.forEach(ref => {
      let listDoc: ReferenceDocLink = list.find(d => d.fileName == ref.fileName && d.title == ref.title);
      if (!listDoc) {
        listDoc = {
          fileId: ref.fileId,
          fileName: ref.fileName?.trim(),
          title: ref.title.trim(),
          url: ref.url?.trim(),
          isUploaded: ref.isUploaded,
          bookmarks: []
        };
        list.push(listDoc);
      }

      listDoc.bookmarks.push(ref);
    });

    return list;
  }

  /**
    * Replaces all occurrences of the token {{ cset_refdoc_url }}
    * with the library URL for the installation.
    */
  replaceRefDocUrl(s: string) {
    return s.replaceAll("{{ cset_refdoc_url }}", this.configSvc.refDocUrl);
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
