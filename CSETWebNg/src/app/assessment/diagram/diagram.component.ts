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
import { AssessmentDetail } from '../../models/assessment-info.model';
import { AssessmentService } from '../../services/assessment.service';
import { AuthenticationService } from '../../services/authentication.service';
import { ConfigService } from '../../services/config.service';
import { NavigationService } from '../../services/navigation/navigation.service';

@Component({
    selector: 'app-diagram',
    templateUrl: './diagram.component.html'
})
export class DiagramComponent implements OnInit {

    msgDiagramExists = 'Edit the Network Diagram';
    msgNoDiagramExists = 'Create a Network Diagram';
    buttonText: string = this.msgNoDiagramExists;

    /**
     * Constructor.
     */
    constructor(private router: Router,
        public assessSvc: AssessmentService,
        public navSvc: NavigationService,
        public configSvc: ConfigService,
        public authSvc: AuthenticationService
    ) { this.assessSvc.currentTab = 'prepare'; }

    /**
     *
     */
    ngOnInit() {
        // if we are hitting this page without knowing anything
        // about the assessment, we probably just got back from
        // the diagram app.
        if (!this.assessSvc.assessment) {
            this.assessSvc.getAssessmentDetail().subscribe(
                (data: AssessmentDetail) => {
                    this.assessSvc.assessment = data;
                    this.assessSvc.currentTab = 'prepare';
                    this.navSvc.setCurrentPage('diagram');
                    this.navSvc.buildTree();
                });
        }
    }
}
