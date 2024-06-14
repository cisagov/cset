import { Component, Input } from '@angular/core';
import { ReferenceDocLink } from '../../../models/question-extras.model';
import { ConfigService } from '../../../services/config.service';
import { TranslocoService } from '@ngneat/transloco';
import { ResourceLibraryService } from '../../../services/resource-library.service';

@Component({
  selector: 'app-references-section',
  templateUrl: './references-section.component.html'
})
export class ReferencesSectionComponent {

  @Input() documents;

  @Input('q')
  question: any;


    /**
   *
   */
    constructor(
      public configSvc: ConfigService,
      public tSvc: TranslocoService,
      private resourceLibSvc: ResourceLibraryService
    ) { }

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
