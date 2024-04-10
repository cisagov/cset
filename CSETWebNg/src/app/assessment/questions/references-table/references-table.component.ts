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
import { Component, Input } from '@angular/core';
import { ReferenceDocLink } from '../../../models/question-extras.model';
import { ConfigService } from '../../../services/config.service';
import { ResourceLibraryService } from '../../../services/resource-library.service';

/**
 * This is the original references display where each
 * bookmark is rendered as a full row with the entire document
 * name as a hyperlink in one column and the bookmark
 * (if there is one) in another column.
 * This is being deprecated because it is really cumbersome
 * to read when there are a lot of references, like
 * in 800-53.
 */
@Component({
  selector: 'app-references-table',
  templateUrl: './references-table.component.html',
  styleUrls: ['./references-table.component.scss']
})
export class ReferencesTableComponent {

  @Input()
  tab: any;

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
  areNoReferenceDocumentsAvailable() {
    return (!this.tab?.referenceTextList || this.tab.referenceTextList.length === 0)
      && (!this.tab?.sourceDocumentsList || this.tab.sourceDocumentsList.length === 0)
      && (!this.tab?.additionalDocumentsList || this.tab.additionalDocumentsList.length === 0)
  }

  /**
   *
   */
  formatDocumentUrl(document: ReferenceDocLink, bookmark: any) {
    return this.resourceLibSvc.formatDocumentUrl(document, bookmark);
  }
}
