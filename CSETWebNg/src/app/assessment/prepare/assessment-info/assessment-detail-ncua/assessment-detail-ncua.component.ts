////////////////////////////////
//
//   Copyright 2022 Battelle Energy Alliance, LLC
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
import { Component, Input, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { DatePipe } from '@angular/common';
import { AssessmentService } from '../../../../services/assessment.service';
import { AssessmentDetail } from '../../../../models/assessment-info.model';
import { NavigationService } from '../../../../services/navigation.service';
import { ConfigService } from '../../../../services/config.service';
import { NCUAService } from '../../../../services/ncua.service';


@Component({
  selector: 'app-assessment-detail-ncua',
  templateUrl: './assessment-detail-ncua.component.html',
  host: { class: 'd-flex flex-column flex-11a' }
})
export class AssessmentDetailNcuaComponent implements OnInit {

  assessment: AssessmentDetail = {};
  
  // Adding a date property here to avoid breaking any other assessments. Will probably update later.
  assessmentEffectiveDate: Date = new Date();

  contactInitials: string = "";

  /**
   * 
   */
  constructor(
    private assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public configSvc: ConfigService,
    public ncuaSvc: NCUAService,
    public datePipe: DatePipe
  ) { }

  ngOnInit() {
    if (this.assessSvc.id()) {
      this.getAssessmentDetail();
    }
  }

  isAnExamination() {
    if (this.assessment.maturityModel?.modelName === 'ISE') {
      return true;
    }
  }

  /**
   * Called every time this page is loaded.  
   */
  getAssessmentDetail() {
    this.assessment = this.assessSvc.assessment;
    
    // a few things for a brand new assessment
    if (this.assessSvc.isBrandNew) {
      this.assessSvc.setNcuaDefaults();

      this.assessSvc.getAssessmentContacts().then((response: any) => {
        let firstInitial = response.contactList[0].firstName[0] !== undefined ? response.contactList[0].firstName[0] : "";
        let lastInitial = response.contactList[0].lastName[0] !== undefined ? response.contactList[0].lastName[0] : "";
        this.contactInitials = firstInitial + lastInitial;
      });

      this.assessSvc.updateAssessmentDetails(this.assessment);
    }
    
    this.assessSvc.isBrandNew = false;

    // This will keep the contact initials the same, even when importing an assessment changes the assessment owner
    if (this.assessment.assessmentName !== "New Assessment" && !(this.assessment.assessmentName.includes("merged"))) {
      let splitNameArray = this.assessment.assessmentName.split("_");
      
      this.contactInitials = splitNameArray[1];
    }

    this.setCharterPad();
    

    // Null out a 'low date' so that we display a blank
    const assessDate: Date = new Date(this.assessment.assessmentDate);
    this.assessmentEffectiveDate = assessDate;

    if (assessDate.getFullYear() <= 1900) {
      this.assessment.assessmentDate = null;
      this.assessmentEffectiveDate = null;
    }
    
    if (this.assessment.assessmentName === "New Assessment")
      this.createAssessmentName();
  }


  /**
   * 
   */
  update(e) {
    // default Assessment Name if it is left empty
    if (!!this.assessment) {
      if (this.assessment.assessmentName.trim().length === 0) {
        this.assessment.assessmentName = "(Untitled Assessment)";
      }
    }

    this.createAssessmentName();

    this.setCharterPad();
    this.assessSvc.updateAssessmentDetails(this.assessment);
  }

  /**
   * 
   */
  setCharterPad() {
    if (!!this.assessment) {
      this.assessment.charter = this.padLeft(this.assessment.charter, '0', 5);
    }
  }

  /**
   * 
   * @param text 
   * @param padChar 
   * @param size 
   */
  padLeft(text: string, padChar: string, size: number): string {
    return (String(padChar).repeat(size) + text).substr((size * -1), size);
  }

  /**
   * 
   */
  createAssessmentName() {
    if (this.isAnExamination()) {
      if (this.assessment.assessmentName.includes("merged")) {
        return;
      }
      
      this.assessment.assessmentName = "ISE";
    } else {
      this.assessment.assessmentName = "ACET";
    }

    // ISE's require a charter number to verify valid merge.
    if (this.assessment.charter) {
      this.assessment.assessmentName = this.assessment.assessmentName + " " + this.assessment.charter;
    }
    
    if (this.assessment.creditUnion) {
      this.assessment.assessmentName = this.assessment.assessmentName + " " + this.assessment.creditUnion;
    }
    
    if (this.assessment.assessmentDate) {
      let date = new Date(Date.parse(this.assessment.assessmentDate));
      this.assessment.assessmentName = this.assessment.assessmentName + " " + this.datePipe.transform(date, 'MMddyy');
    }

    if (this.isAnExamination()) {
      this.assessment.assessmentName = this.assessment.assessmentName + "_" + this.contactInitials;
    }
  }

}
