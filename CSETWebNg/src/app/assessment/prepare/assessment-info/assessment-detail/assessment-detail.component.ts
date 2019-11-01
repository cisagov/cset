////////////////////////////////
//
//   Copyright 2019 Battelle Energy Alliance, LLC
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
import { ActivatedRoute } from '@angular/router';
import { AssessmentService } from '../../../../services/assessment.service';
import { AssessmentDetail } from '../../../../models/assessment-info.model';
import { StandardService } from '../../../../services/standard.service';



@Component({
  selector: 'app-assessment-detail',
  templateUrl: './assessment-detail.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class AssessmentDetailComponent implements OnInit {
  assessment: AssessmentDetail = {};
  hasACET: boolean = true;

  constructor(private route: ActivatedRoute,
    private assessSvc: AssessmentService,
    private standardSvc: StandardService
  ) {
    this.standardSvc.getACET().subscribe((x: boolean) => {
      this.hasACET = x;
      sessionStorage.setItem('ACET', x.toString());
    });
  }

  ngOnInit() {
    if (this.assessSvc.id()) {
      this.getAssessmentDetail();
    }
  }

  setCharterPad() {
    this.assessment.Charter = this.padLeft(this.assessment.Charter, '0', 5);
  }

  padLeft(text: string, padChar: string, size: number): string {
    return (String(padChar).repeat(size) + text).substr((size * -1), size);
  }

  getAssessmentDetail() {
    this.assessSvc.getAssessmentDetail().subscribe(
      (data: AssessmentDetail) => {
        this.assessment = data;
        this.setCharterPad();

        // Null out a 'low date' so that we display a blank
        const assessDate: Date = new Date(this.assessment.AssessmentDate);
        if (assessDate.getFullYear() <= 1900) {
          this.assessment.AssessmentDate = null;
        }
      },
      error => console.log('Assessment Detail load Error: ' + (<Error>error).message)
    );
    // this.hasACET = this.standardSvc.acetSelected;
  }



  update(e) {
    // default Assessment Name if it is left empty
    if (this.assessment.AssessmentName.trim().length === 0) {
      this.assessment.AssessmentName = "(Untitled Assessment)";
    }
    this.setCharterPad();
    this.assessSvc.updateAssessmentDetails(this.assessment);
    this.standardSvc.makeNavTree();
  }
}
