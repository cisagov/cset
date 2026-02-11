////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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
import { TranslocoService } from '@jsverse/transloco';
import { ResourceLibraryService } from '../../../services/resource-library.service';

@Component({
    selector: 'app-references-section',
    templateUrl: './references-section.component.html',
    standalone: false
})
export class ReferencesSectionComponent {

  @Input() documents: any[];

  @Input('q')
  question: any;


    /**
   *
   */
    constructor(
      public configSvc: ConfigService,
      public tSvc: TranslocoService,
      private resourceLibSvc: ResourceLibraryService
    ) {
    }

  /**
   * Formats a URL to the document.  Handles uploaded documents via the
   * 'library' endpoint as well as direct PDFs stored on the
   * file system in the API.
   * Bookmarks to an actual sectionRef are appended to the URL.
   */
  formatDocumentUrl(doc: ReferenceDocLink, bookmark: any) {
    return this.resourceLibSvc.formatDocumentUrl(doc, bookmark);


  }

  /**
   * Returns the display text of the bookmark link.
   */
  formatBookmarkDisplay(doc: ReferenceDocLink, bookmark: any) {
    if (!bookmark || bookmark.sectionRef == '') {
      if (doc.url) {
        // "link"
        return this.tSvc.translate('extras.link');
      }

      // "document"
      return this.tSvc.translate('extras.document');

    } else {
      if (!!bookmark.destinationString && bookmark.destinationString.trim().length > 0) {
        // display the destinationstring
        return bookmark.destinationString;
      }

      // display the sectionRef value
      return bookmark.sectionRef;
    }
  }
}
