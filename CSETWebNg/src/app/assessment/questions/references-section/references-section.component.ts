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

      listDoc.bookmarks.push(ref.sectionRef.trim());
    });

    return list;
  }

  /**
   * Formats a URL to the document.  Handles uploaded documents via the
   * 'ReferenceDocument' endpoint as well as direct PDFs stored on the
   * file system in the API.
   * Bookmarks to an actual sectionRef are appended to the URL.
   */
  documentUrl(doc: ReferenceDocLink, bookmark: string) {
    return this.resourceLibSvc.documentUrl(doc, bookmark);
  }

  /**
   * Formats the text of the bookmark link.
   */
  bookmarkDisplay(doc: ReferenceDocLink, bookmark: string) {
    if (bookmark == '') {
      if (doc.url) {
        return this.tSvc.translate('extras.link');
      }
      return this.tSvc.translate('extras.document');
    } else {
      return bookmark;
    }
  }
}
