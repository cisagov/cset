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
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { AfterViewInit, Component, ElementRef, OnInit, ViewChild, isDevMode } from '@angular/core';
import { Subject } from 'rxjs';
import { Title } from "@angular/platform-browser";
import { debounceTime, distinctUntilChanged } from 'rxjs/operators';
import { ConfigService } from '../services/config.service';
import { NavTreeNode } from '../services/navigation/navigation.service';
import { OkayComponent } from '../dialogs/okay/okay.component';
import { MatDialog, MatDialogRef } from "@angular/material/dialog";
import { NavigationService } from '../services/navigation/navigation.service';
import { NavTreeService } from '../services/navigation/nav-tree.service';
import { AuthenticationService } from '../services/authentication.service';
const headers = {
  headers: new HttpHeaders().set('Content-Type', 'application/json'),
  params: new HttpParams()
};

interface LibrarySearchResponse {
  nodes: LibrarySearchResponse[];
  id: number;
  parentID: number;
  treeTextNode: string;
  headingTitle: string;
  headingTitle2: string;
  datePublished?: any;
  headingText: string;
  type: number;
  pathDoc: string;
  fileName: string;
  isSelected: boolean;
  isExpanded: boolean;
  children?: LibrarySearchResponse[];
}

@Component({
  selector: 'app-resource-library',
  templateUrl: './resource-library.component.html',
  styleUrls: ['./resource-library.component.scss'],
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class ResourceLibraryComponent implements OnInit, AfterViewInit {
  results: LibrarySearchResponse[];
  searchTerm: string;
  searchString: string;
  apiUrl: string;
  docUrl: string;
  libraryUrl: string;
  refDocUrl: string;
  selectedPane = 'search';
  dialogRef: MatDialogRef<OkayComponent>;
  isLoading: boolean;
  isexpanded: boolean;
  selected: boolean;
  children?: LibrarySearchResponse[];
  filter: string = '';
  setFilterDebounced = new Subject<string>();
  @ViewChild('tabs') tabsElementRef: ElementRef;
  devMode: boolean = isDevMode();

  constructor(private configSvc: ConfigService,
    private http: HttpClient,
    public navSvc: NavigationService,
    public navTreeSvc: NavTreeService,
    public dialog: MatDialog,
    private authSvc: AuthenticationService,
    public titleSvc: Title) {
  }

  ngOnInit() {
    this.isexpanded = true;
    this.apiUrl = this.configSvc.apiUrl;
    this.libraryUrl = this.configSvc.libraryUrl;
    this.refDocUrl = this.configSvc.refDocUrl;
    this.docUrl = this.configSvc.refDocUrl;

    this.titleSvc.setTitle(this.configSvc.behaviors.defaultTitle);

    // Debounce filter changes so the first few letters typed
    // don't have a long noticeable delay as each letter refilters the
    // tree.
    this.setFilterDebounced.pipe(
      debounceTime(400),
      distinctUntilChanged())
      .subscribe(value => {
        this.setFilter(value);
      });

    this.http.get(this.libraryUrl + 'tree').subscribe(
      (response: NavTreeNode[]) => {
        this.navTreeSvc.setTree(response, this.navSvc.getMagic(), true);
        this.isLoading = false;
      }
    );
  }

  ngAfterViewInit(): void {
    if (!!this.tabsElementRef) {
      const tabsEl = this.tabsElementRef.nativeElement;
      tabsEl.classList.add('sticky-tabs');
      if (this.authSvc.isLocal && this.devMode) {
        tabsEl.style.top = '81px';
      } else {
        tabsEl.style.top = '62px';
      }
    }
  }

  setFilter(filter: string) {
    this.filter = filter ?? '';
    let nodes = this.navTreeSvc?.dataSource.data;
    // Convert to lowercase & trim the filter string
    // and pass the value to sub-functions instead of
    // doing the same conversion again in-place many more
    // times in the recursive function.
    let filterLowerCaseTrimmed = this.filter.toLowerCase().trim();
    // Set ok on each node
    nodes.forEach(node => {
      this.filterDepthMatch(node, filterLowerCaseTrimmed);
    });

    this.navTreeSvc.dataChange$.next(nodes);
  }

  filterDepthMatch(node: any, filterLowerCaseTrimmed: string) {
    // Is this a leaf?  Check its label and heading
    if (
      (node.children ?? []).length === 0
    ) {
      node.visible =
        // No filter text?  Make everything visible by default
        (this.filter.toString().trim() == '')
        ||
        // Check the label
        ((node.label ?? '').toString().toLowerCase().indexOf(filterLowerCaseTrimmed) >= 0)
        ||
        // Check the heading for a match
        ((node.headingText ?? '').toString().toLowerCase().indexOf(filterLowerCaseTrimmed) >= 0);
    } else {
      // Default to hidden (unless filter string is empty)
      node.visible = (filterLowerCaseTrimmed == '');
      node.children.forEach(child => {
        if (this.filterDepthMatch(child, filterLowerCaseTrimmed)) {
          // Make this parent visible since a child is visibile
          node.visible = true;
          // we do not want to return immediately, because
          // we want to make sure we process all the children with matches
          // instead of stopping after the first match is found
        };
      })
    }
    // This will return false if no descendents matched
    // If this node is activated, the recursive loop caller
    // will mark itself visible too, so all ancestors will be visible.
    return node.visible;
  }

  search(term: string) {
    this.http.post(
      this.libraryUrl + 'search',
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

          // Cull out any entries whose HeadingTitle is null

          while (this.results.findIndex(r => r.headingText === null) >= 0) {
            this.results.splice(this.results.findIndex(r => r.headingText === null), 1);
          }
        });
  }

  /**
   * A couple of different objects can call this to see if
   * the object represents procurement language or a catalog
   * of recommendations entry.  This function is flexible
   * in considering the 'pathDoc' or 'docId' property.
   */
  isProcurementOrCatalog(result: any) {
    let path = result.pathDoc || result.docId;

    if (!path) {
      return false;
    }

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
      id = parms.substring(parms.indexOf(":") + 1);
    }

    if (parms.indexOf('catalog:') === 0) {
      docType = 'cat';
      id = parms.substring(parms.indexOf(":") + 1);
    }

    this.http.get(
      this.libraryUrl + 'flowdoc?type=' + docType + '&id=' + id, { responseType: 'text' })
      .subscribe(
        (docHtml: string) => {
          this.dialog.open(OkayComponent, { data: { messageText: docHtml } });
          this.dialogRef.componentInstance.hasHeader = false;
        });
  }
}
