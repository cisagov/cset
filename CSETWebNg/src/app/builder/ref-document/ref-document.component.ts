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
import { ReferenceDoc } from '../../models/set-builder.model';
import { SetBuilderService } from '../../services/set-builder.service';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-ref-document',
  templateUrl: './ref-document.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class RefDocumentComponent implements OnInit {

  docID: number;
  doc: ReferenceDoc = { id: 0 };

  constructor(
    private setBuilderSvc: SetBuilderService,
    private route: ActivatedRoute
  ) { }

  /**
   *
   */
  ngOnInit() {
    this.docID = this.route.snapshot.params['id'];
    if (isNaN(this.docID)) {
      return;
    }

    this.setBuilderSvc.getDocumentDetail(this.docID).subscribe((result: ReferenceDoc) => {
      this.doc = result;
    });
  }

  /**
   *
   */
  update(e: Event) {
    this.setBuilderSvc.updateDocumentDetail(this.doc).subscribe(() => {
    });
  }

  /**
   *
   */
  navStandardDocuments() {
    this.setBuilderSvc.navStandardDocuments('', this.docID);
  }
}
