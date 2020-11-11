////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
import { Component, OnInit, AfterViewInit, ChangeDetectorRef } from '@angular/core';
import { ActivatedRoute, Router } from '../../../../../node_modules/@angular/router';
import { AssessmentService } from '../../../services/assessment.service';
import { AuthenticationService } from '../../../services/authentication.service';
import { ConfigService } from '../../../services/config.service';
import { NavigationService } from '../../../services/navigation.service';

@Component({
    selector: 'app-reports',
    templateUrl: './reports.component.html',
    // tslint:disable-next-line:use-host-property-decorator
    host: {class: 'd-flex flex-column flex-11a'}
})
export class ReportsComponent implements OnInit, AfterViewInit {

    constructor(
        public assessSvc: AssessmentService,
        public navSvc: NavigationService,
        private router: Router,
        private route: ActivatedRoute,
        private authSvc: AuthenticationService,
        public configSvc: ConfigService,
        private cdr: ChangeDetectorRef
    ) { 
        if(this.assessSvc.assessment == null)
        {
        this.assessSvc.getAssessmentDetail().subscribe(
            (data: any) => {
            this.assessSvc.assessment = data;
            });
        }
    }

    ngOnInit() {
        this.assessSvc.currentTab = 'results';
        this.navSvc.navItemSelected.asObservable().subscribe((value: string) => {
            this.router.navigate([value], { relativeTo: this.route.parent });
        });
    }

    ngAfterViewInit() {
        this.cdr.detectChanges();
    }

    clickReportLink(reportType: string) {
        console.log('/index.html?returnPath=report/'+reportType)
        const url = '/index.html?returnPath=report/'+reportType;
        window.open(url, "_blank");
    }
}
