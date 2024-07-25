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
import { Component, OnInit, Pipe } from '@angular/core';
import { MatDialogRef } from '@angular/material/dialog';
import { ConfigService } from '../../services/config.service';
import { AssessmentService } from '../../services/assessment.service';
import { FileUploadClientService } from '../../services/file-client.service';
import { AuthenticationService } from '../../services/authentication.service';
import { CieService } from '../../services/cie.service';

@Component({
  selector: 'app-cie-documents',
  templateUrl: './cie-documents.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class CieDocumentsComponent implements OnInit {

  documents: any[] = null;

  constructor(private dialog: MatDialogRef<CieDocumentsComponent>,
    public configSvc: ConfigService,
    public authSvc: AuthenticationService,
    public assessSvc: AssessmentService,
    public fileSvc: FileUploadClientService,
    private cieSvc: CieService) { }

  ngOnInit() {
    this.cieSvc.getCieAssessmentDocuments().subscribe((response: any[]) => {
      this.documents = response;
    });
  }

  download(doc: any) {
    // get short-term JWT from API
    this.authSvc.getShortLivedToken().subscribe((response: any) => {
      const url = this.fileSvc.downloadUrl + doc.document_Id + "?token=" + response.token;
      window.location.href = url;
    });
  }

  close() {
    return this.dialog.close();
  }
}
