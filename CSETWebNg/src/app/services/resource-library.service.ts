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
import { CustomDocument } from '../models/question-extras.model';

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

  showResourceLibrary() {
    return this.http.get(this.apiUrl + 'ShowResourceLibrary');
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
   * Formats a URL of a provided document.  Handles uploaded documents via the
   * 'ReferenceDocument' endpoint as well as direct PDFs stored on the
   * file system in the API.
   * Bookmarks to an actual section_Ref are appended to the URL.
   */
  documentUrl(doc: CustomDocument, bookmark?: string): string {

    if (typeof bookmark === 'undefined') {
      bookmark = '';
    }

    if (doc.is_Uploaded) {
      return this.configSvc.apiUrl + 'ReferenceDocument/' + doc.file_Id + '#' + bookmark;
    }

    if (this.configSvc.isDocUrl) {
      return this.configSvc.docUrl + doc.file_Name + '#' + bookmark;
    }

    if (this.configSvc.isOnlineUrlLive) {
      return this.configSvc.onlineUrl + "/" + this.configSvc.config.api.documentsIdentifier + "/" + doc.file_Name + '#' + bookmark;
    }

    return '';
  }
}
