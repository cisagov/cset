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
import { ActivatedRoute, Router } from '../../../../../node_modules/@angular/router';
import { AssessmentService } from '../../../services/assessment.service';
import { AssessmentDetail } from '../../../models/assessment-info.model';
import { NavigationService } from '../../../services/navigation/navigation.service';

@Component({
  selector: 'app-overview',
  templateUrl: './overview.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class OverviewComponent implements OnInit {

  o: AssessmentDetail = {};

  constructor(
    private assessSvc: AssessmentService,
    public navSvc: NavigationService,
    private router: Router,
    private route: ActivatedRoute
  ) { this.assessSvc.currentTab = 'results'; }

  ngOnInit() {
    this.assessSvc.getAssessmentDetail().subscribe((detail: any) => {
      this.o = detail;
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
