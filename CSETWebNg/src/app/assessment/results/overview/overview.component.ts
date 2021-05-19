////////////////////////////////
//
//   Copyright 2021 Battelle Energy Alliance, LLC
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
import { Component, OnInit} from '@angular/core';
import { ActivatedRoute, Router } from '../../../../../node_modules/@angular/router';
import { AssessmentService } from '../../../services/assessment.service';
import { AssessmentDetail } from '../../../models/assessment-info.model';
import { NavigationService } from '../../../services/navigation.service';

@Component({
  selector: 'app-overview',
  templateUrl: './overview.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: {class: 'd-flex flex-column flex-11a'}
})
export class OverviewComponent implements OnInit {

  o: AssessmentDetail = {};
  // tslint:disable-next-line:max-line-length
  defaultExecSumm: string = "Cyber terrorism is a real and growing threat. Standards and guides have been developed, vetted, and widely accepted to assist with protection from cyber attacks. The Cyber Security Evaluation Tool (CSET) includes a selectable array of these standards for a tailored assessment of cyber vulnerabilities. Once the standards were selected and the resulting question sets answered, the CSET created a compliance summary, compiled variance statistics, ranked top areas of concern, and generated security recommendations.";

  constructor(
    private assessSvc: AssessmentService,
    public navSvc: NavigationService,
    private router: Router,
    private route: ActivatedRoute
  ) { }

  ngOnInit() {
    this.assessSvc.currentTab = 'results';
    this.assessSvc.getAssessmentDetail().subscribe((detail: any) => {
      this.o = detail;
      if (this.o.executiveSummary === null) {
        // this.myExecSumm = this.defaultExecSumm;
        this.o.executiveSummary = this.defaultExecSumm;
      }

      this.updateAssessmentDetails();
    });

    this.navSvc.navItemSelected.asObservable().subscribe((value: string) => {
      this.router.navigate([value], { relativeTo: this.route.parent });
    });
  }

  update(e) {
    this.updateAssessmentDetails();
  }

  updateAssessmentDetails() {
    this.assessSvc.updateAssessmentDetails(this.o);
  }
}
