////////////////////////////////
//
//   Copyright 2018 Battelle Energy Alliance, LLC
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
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { ConfigService } from '../services/config.service';
import { NavigationService, NavTree } from '../services/navigation.service';
import { OkayComponent } from '../dialogs/okay/okay.component';
import { MatDialog, MatDialogRef } from "@angular/material";
import { SafePipe } from '../helpers/safe.pipe';

const headers = {
  headers: new HttpHeaders().set('Content-Type', 'application/json'),
  params: new HttpParams()
};

interface LibrarySearchResponse {
  Nodes: LibrarySearchResponse[];
  ID: number;
  ParentID: number;
  TreeTextNode: string;
  HeadingTitle: string;
  HeadingTitle2: string;
  DatePublished?: any;
  HeadingText: string;
  Type: number;
  PathDoc: string;
  FileName: string;
  IsSelected: boolean;
  IsExpanded: boolean;
}

@Component({
  selector: 'app-resource-library',
  templateUrl: './resource-library.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class ResourceLibraryComponent implements OnInit {
  results: LibrarySearchResponse[];
  searchTerm: string;
  apiUrl: string;
  docUrl: string;
  selectedPane = 'search';
  dialogRef: MatDialogRef<OkayComponent>;

  constructor(private configSvc: ConfigService,
    private http: HttpClient,
    public navSvc: NavigationService,
    public dialog: MatDialog) { }

  ngOnInit() {
    this.apiUrl = this.configSvc.apiUrl;
    this.docUrl = this.configSvc.docUrl;
    const magic = this.navSvc.getMagic();
    this.http.get(this.apiUrl + 'ResourceLibrary/tree').subscribe(
      (response: NavTree[]) => {
        this.navSvc.setTree(response, magic, true);
      }
    );
  }

  search(term: string) {
    this.http.post(
      this.apiUrl + 'ResourceLibrary',
      {
        term: term,
        isProcurement: true,
        isCatalog: true,
        isResourceDocs: true
      },
      headers)
      .subscribe(
        (response: LibrarySearchResponse[]) => {
          this.results = response;
          // this.navSvc.setTree([]);

          // Cull out any entries whose HeadingTitle is null
          while (this.results.findIndex(r => r.HeadingText === null) >= 0) {
            this.results.splice(this.results.findIndex(r => r.HeadingText === null), 1);
          }
        });
  }

  isProcurementOrCatalog(path: string) {
    if (path.indexOf('procurement:') === 0
      || path.indexOf('catalog:') === 0) {
      return true;
    }
    return false;
  }

  /**
   * Displays the HTML content of the document.  This method displays
   * the content in a modal dialog.  This could be refactored to
   * display the content in a component that we route to.
   * @param parms
   */
  displayDocumentContent(parms: string) {
    let docType: string;
    let id: string;

    if (parms.indexOf('procurement:') === 0) {
      docType = 'proc';
      id = parms.substr(parms.indexOf(":") + 1);
    }

    if (parms.indexOf('catalog:') === 0) {
      docType = 'cat';
      id = parms.substr(parms.indexOf(":") + 1);
    }

    this.http.get(
      this.apiUrl + 'ResourceLibrary/doc?type=' + docType + '&id=' + id,
      headers)
      .subscribe(
        (docHtml: string) => {
          this.dialog.open(OkayComponent, { data: { messageText: docHtml } });
          this.dialogRef.componentInstance.hasHeader = false;
        });
  }
}
