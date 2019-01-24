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
import { Component, OnInit } from '@angular/core';
import { SetBuilderService } from '../../services/set-builder.service';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-standard-documents',
  templateUrl: './standard-documents.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class StandardDocumentsComponent implements OnInit {

  setName: string;
  standardTitle: string;
  filter: string = '';
  filteredDocuments: RefDoc[] = [];

  constructor(
    private setBuilderSvc: SetBuilderService,
    private route: ActivatedRoute
  ) { }

  ngOnInit() {
    this.setName = this.route.snapshot.params['id'];
    this.setBuilderSvc.getSetDetail(this.setName).subscribe((result: any) => {
      this.standardTitle = result.FullName;
    });

    this.applyFilter();
  }

  applyFilter() {
    this.setBuilderSvc.getReferenceDocuments(this.filter).subscribe((result: RefDoc[]) => {
      this.filteredDocuments = [];
      result.forEach(element => {
        this.filteredDocuments.push(element);
      });
    });
  }

  /**
   *
   */
  selectDoc(doc: RefDoc, e) {
    if (e.target.checked) {
      // call the API to create a bridge
      console.log('check on');
    } else {
      // call the API to delete the bridge
      console.log('check off');
    }


    this.setBuilderSvc.selectDocumentForSet(this.setName, doc.ID, e.target.checked).subscribe();


  }
}

export interface RefDoc {
  ID: number;
  Title: string;
  FileName: string;
  Selected: boolean;
}
