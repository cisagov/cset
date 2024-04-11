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
import { Router } from '@angular/router';
import { AssessmentService } from '../../../services/assessment.service';
import { RequiredDocumentService } from '../../../services/required-document.service';
import { RequiredDocumentsResponse, RequiredDocument } from '../../../models/required-document.model';
import { StandardService } from '../../../services/standard.service';
import { NavigationService } from '../../../services/navigation/navigation.service';

@Component({
    selector: 'app-required',
    templateUrl: './required.component.html',
    // eslint-disable-next-line
    // host: { class: 'd-flex flex-column flex-11a' }
    styleUrls: ['./required.component.scss'],
})
export class RequiredDocsComponent implements OnInit {
    documents: RequiredDocumentsResponse;
    selectedAnswer: RequiredDocument;
    commentShow: { [id: number]: boolean };

    constructor(private router: Router,
        private assessSvc: AssessmentService,
        private requiredSvc: RequiredDocumentService,
        public navSvc: NavigationService,
        private standardSvc: StandardService
    ) { }

    ngOnInit() {
        this.loadFrameworks();
    }

    loadFrameworks() {
        this.requiredSvc.getRequiredDocumentsList().subscribe(
            (data: RequiredDocumentsResponse) => {
                this.commentShow = {};
                for (let i = 0; i < data.headerList.length; i++) {
                    for (let j = 0; j < data.headerList[i].documents.length; j++) {
                        this.commentShow[data.headerList[i].documents[j].docId] = false;
                    }
                }

                this.documents = data;
            },
            error => {
                console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error getting all documents: ' + (<Error>error).stack);
            });
    }

    commentToggle(id: number) {
        this.commentShow[id] = !this.commentShow[id];
    }
    has(doc: RequiredDocument) {
        return (doc.comment && doc.comment.length > 0) ? 'inline' : 'none';
    }

    submit(doc: RequiredDocument, answer: string = null) {
        if (answer != null) {
            doc.answer = answer;
        }
        this.selectedAnswer = new RequiredDocument(doc.docId, doc.answer, doc.comment);

        this.requiredSvc.postSelections(this.selectedAnswer).subscribe();
    }
}
