import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AssessmentService } from '../../../services/assessment.service';
import { RequiredDocumentService } from '../../../services/required-document.service';
import { RequiredDocumentsResponse, RequiredDocument } from '../../../models/required-document.model';
import { StandardService } from '../../../services/standard.service';
import { Navigation2Service } from '../../../services/navigation2.service';

@Component({
    selector: 'app-required',
    templateUrl: './required.component.html',
    // tslint:disable-next-line:use-host-property-decorator
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
        public navSvc2: Navigation2Service,
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
                        this.commentShow[data.headerList[i].documents[j].DocId] = false;
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
        return (doc.Comment && doc.Comment.length > 0) ? 'inline' : 'none';            
    }

    submit(doc: RequiredDocument, answer: string = null) {
        if (answer != null) {
            doc.Answer = answer;
        }
        this.selectedAnswer = new RequiredDocument(doc.DocId, doc.Answer, doc.Comment);

        this.requiredSvc.postSelections(this.selectedAnswer).subscribe();
    }
}
