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
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { ConfigService } from './config.service';
import { ReferenceDocLink } from '../models/question-extras.model';

const headers = {
  headers: new HttpHeaders().set('Content-Type', 'application/json'),
  params: new HttpParams()
};

/**
 * A service that provides everything needed for getting documents.
 */
@Injectable()
export class ResourceLibraryService {
  apiUrl: string;
  constructor(private http: HttpClient, private configSvc: ConfigService) {
    if (this.configSvc.apiUrl) {
      this.apiUrl = this.configSvc.apiUrl;
    } else {
      this.apiUrl = 'http://localhost:46000/api/';
    }
  }

  /**
   * Gets the Url of the document based on the given name.
   * @param documentName
   * @returns Url of the document as a string
   */
  documentUrlByName(documentName: string) {
    if (this.configSvc.isDocUrl) {
      return this.configSvc.docUrl + documentName;
    }

    if (this.configSvc.isOnlineUrlLive) {
      return this.configSvc.onlineUrl + "/" + this.configSvc.config.api.documentsIdentifier + "/" + documentName
    }

    return '';
  }

  /**
   * Formats a URL of a provided document.  Sends the document ID to the
   * 'library' endpoint.  
   * 
   * Bookmarks to an actual sectionRef are appended to the URL.
   * 
   * The "isOnlineUrlLive" code will pull documents from the cloud-based
   * Resource Library when it is available at a future date.
   */
  formatDocumentUrl(docLink: ReferenceDocLink, bookmark?: any): string {
    if (typeof bookmark === 'undefined') {
      bookmark = '';
    }

    // First look to see if this is a URL
    if (docLink.url) {
      if (bookmark) {
        return docLink.url + "#" + bookmark.sectionRef;
      }

      return docLink.url;
    }

    // April 2024 - moving to this method of querying documents; by ID rather than filename
    if (docLink.fileId) {
      return this.configSvc.refDocUrl + docLink.fileId + '#' + bookmark.sectionRef;
    }

    // April 2024 - phasing out this older way of querying documents by filename
    // if (this.configSvc.isDocUrl) {
    //   return this.configSvc.docUrl + doc.fileName + '#' + bookmark;
    // }

    if (this.configSvc.isOnlineUrlLive) {
      return this.configSvc.onlineUrl + "/" + this.configSvc.config.api.documentsIdentifier + "/" + docLink.fileName + '#' + bookmark.sectionRef;
    }

    return '';
  }
}
