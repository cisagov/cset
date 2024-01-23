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
import { Component, OnInit } from '@angular/core';
import { SetBuilderService } from '../../services/set-builder.service';
import { FileUploadClientService } from '../../services/file-client.service';
import { ActivatedRoute } from '@angular/router';
import { ReferenceDoc } from '../../models/set-builder.model';

@Component({
  selector: 'app-standard-documents',
  templateUrl: './standard-documents.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class StandardDocumentsComponent implements OnInit {

  setName: string;
  standardTitle: string;
  filter: string = '';
  filteredDocuments: ReferenceDoc[] = [];

  /**
   * Indicates whether to show just the checked documents or all
   */
  showChecked = false;


  constructor(
    private setBuilderSvc: SetBuilderService,
    private route: ActivatedRoute,
    public fileSvc: FileUploadClientService
  ) { }

  /**
   *
   */
  ngOnInit() {
    this.setName = this.route.snapshot.params['id'];
    this.setBuilderSvc.getSetDetail(this.setName).subscribe((result: any) => {
      this.standardTitle = result.fullName;
      this.applyFilter();
    });
  }

  toggleShowChecked() {
    this.showChecked = !this.showChecked;
    this.applyFilter();
  }

  /**
   * Gets a filtered list of documents for display from the API.
   */
  applyFilter() {
    this.setBuilderSvc.getReferenceDocuments(this.filter).subscribe((result: ReferenceDoc[]) => {
      this.filteredDocuments = [];
      result.forEach(element => {
        if (this.showChecked) {
          if (element.selected) {
            this.filteredDocuments.push(element);
          }
        } else {
          this.filteredDocuments.push(element);
        }
      });
    });
  }

  /**
   * Event handler triggered when user selects or deselects a document.
   */
  selectDoc(doc: ReferenceDoc) {
    this.setBuilderSvc.selectDocumentForSet(this.setName, doc).subscribe();
  }

  /**
   * Programatically clicks the corresponding file upload element.
   * @param event
   */
  openFileBrowser(event: any) {
    event.preventDefault();
    const element: HTMLElement = document.getElementById('docUpload') as HTMLElement;
    element.click();
  }

  /**
   * Uploads the selected file to the API.
   * @param e The 'file' event
   */
  fileSelect(e) {
    const options = {};
    this.fileSvc.uploadReferenceDoc(e.target.files[0], options)
      .subscribe(resp => {
        if (!!resp.body) {
          const newFileID: number = parseInt(resp.body, 10);

          // Now that the file is saved, navigate to its detail page
          this.setBuilderSvc.navRefDocDetail(newFileID);
        }
      });
  }

  /**
   * This page might have been reached from a couple of locations.
   * Determine where we came from and go back there.
   * 'ref-document' or 'set-detail'
   */
  navBack() {
    const origin = this.setBuilderSvc.standardDocumentsNavOrigin;
    if (origin === 'set-detail') {
      this.setBuilderSvc.navSetDetail();
    }
    if (origin === 'ref-document') {
      const id = this.setBuilderSvc.standardDocumentsNavOriginID;
      this.setBuilderSvc.navRefDocDetail(+id);
    }
    if (origin === 'requirement-detail') {
      const id = this.setBuilderSvc.standardDocumentsNavOriginID;
      this.setBuilderSvc.navRequirementDetail(+id);
    }
  }
}
