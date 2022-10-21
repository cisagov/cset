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
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { ConfigService } from '../../../../services/config.service';
import { NCUAService } from '../../../../services/ncua.service';
import { UntypedFormControl } from '@angular/forms';
import { Observable } from 'rxjs';
import { map, startWith } from 'rxjs/operators';
import { CreditUnionDetails } from '../../../../models/credit-union-details.model';
import { ACETService } from '../../../../services/acet.service';
import { AcetDashboard } from '../../../../models/acet-dashboard.model';


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

  assessmentControl = new UntypedFormControl('');
  assessmentCharterControl = new UntypedFormControl('');
  creditUnionOptions: CreditUnionDetails[] = [];
  filteredOptions: Observable<CreditUnionDetails[]>;
  
  acetDashboard: AcetDashboard;
  examOverride: string = "";

  /**
   * 
   */
  constructor(
    private assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public configSvc: ConfigService,
    public ncuaSvc: NCUAService,
    public acetSvc: ACETService,
    public datePipe: DatePipe
  ) { }

  ngOnInit() {
    this.navSvc.setCurrentPage('info1');
    
    if (this.assessSvc.id()) {
      this.getAssessmentDetail();
    }

    if (this.configSvc.installationMode === 'ACET') {
      this.ncuaSvc.getCreditUnionData().subscribe(
        (response: any) => {
          this.creditUnionOptions = response;
          for (let i = 0; i < this.creditUnionOptions.length; i++) {
            this.creditUnionOptions[i].charter = this.padLeft(this.creditUnionOptions[i].charter, '0', 5);
          }
        }
      );

      this.filteredOptions = this.assessmentControl.valueChanges.pipe(
        startWith(''), map(value => {
          const name = typeof value === 'string' ? value : value?.name;
          return name ? this.filter(name as string) : this.creditUnionOptions.slice();
        }),
      );
    }

  }

  /**
   * Called every time this page is loaded.  
   */
  getAssessmentDetail() {
    this.assessment = this.assessSvc.assessment;

    // Load dashboard to keep track of irp overriding
    this.acetSvc.getAcetDashboard().subscribe(
      (data: AcetDashboard) => {
        this.acetDashboard = data;
        this.ncuaSvc.updateExamLevelOverride(this.acetDashboard.override);
        this.examOverride = this.ncuaSvc.chosenOverrideLevel;
    });
    
    // a few things for a brand new assessment
    if (this.assessSvc.isBrandNew) {
      this.assessSvc.setNcuaDefaults();

      this.assessSvc.getAssessmentContacts().then((response: any) => {
        let firstInitial = response.contactList[0].firstName[0] !== undefined ? response.contactList[0].firstName[0] : "";
        let lastInitial = response.contactList[0].lastName[0] !== undefined ? response.contactList[0].lastName[0] : "";
        this.contactInitials = firstInitial + lastInitial;
      });

      this.assessSvc.updateAssessmentDetails(this.assessment);
    } else {
      // This will keep the contact initials the same, even when importing an assessment changes the assessment owner
      if (this.assessment.assessmentName !== "New Assessment" && !(this.assessment.assessmentName.includes("merged"))) {
        let splitNameArray = this.assessment.assessmentName.split("_");
        this.contactInitials = splitNameArray[1];
      }
    }
    
    this.assessSvc.isBrandNew = false;

    this.setCharterPad();
    this.ncuaSvc.updateAssetSize(this.assessment.assets);

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


  displayOptions (creditUnion: CreditUnionDetails): string {
    return creditUnion.name && creditUnion.name ? creditUnion.name : '';
  }

  filter (name: string): CreditUnionDetails[] {
    const filterValue = name.toLowerCase();
    return this.creditUnionOptions.filter(option => option.name.toLowerCase().includes(filterValue));
  }

  /**
   * 
   */
  update(e: any) {
    // default Assessment Name if it is left empty
    if (!!this.assessment) {
      if (this.assessment.assessmentName.trim().length === 0) {
        this.assessment.assessmentName = "(Untitled Assessment)";
      }
    }

    this.createAssessmentName();

    for (let i = 0; i < this.creditUnionOptions.length; i++) {
      if (e.target !== undefined) {
        if (e.target.value === this.creditUnionOptions[i].name) {
          this.assessment.cityOrSiteName = this.creditUnionOptions[i].cityOrSite;
          this.assessment.stateProvRegion = this.creditUnionOptions[i].state;
          this.assessment.charter = this.creditUnionOptions[i].charter;
        } else if (e.target.value === (this.creditUnionOptions[i].charter.toString())) {
          this.assessment.creditUnion = this.creditUnionOptions[i].name;
          this.assessment.cityOrSiteName = this.creditUnionOptions[i].cityOrSite;
          this.assessment.stateProvRegion = this.creditUnionOptions[i].state;
        }
      }
    }

    this.setCharterPad();

    
    this.ncuaSvc.updateAssetSize(this.assessment.assets);
    this.assessSvc.updateAssessmentDetails(this.assessment);
  }

  updateOverride(e: any) {
    if (e === "No Override") {
      this.acetDashboard.override = 0;
    } else if (e === 'SCUEP') {
      this.acetDashboard.override = 1;
    } else if (e === 'CORE') {
      this.acetDashboard.override = 2;
    }

    this.acetSvc.postSelection(this.acetDashboard).subscribe((data: any) => {
      this.ncuaSvc.updateExamLevelOverride(this.acetDashboard.override);
    });

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

  isAnExamination() {
    if (this.assessment.maturityModel?.modelName === 'ISE') {
      return true;
    }
  }

  /**
   * 
   */
  createAssessmentName() {
    if (this.isAnExamination()) {
      // Checks if this is a merged exam, and wont auto update the name. Not a great check - will fix later.
      if (this.assessment.assessmentName.includes("merged") || this.assessment.assessmentName.includes("Merged")) {
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
