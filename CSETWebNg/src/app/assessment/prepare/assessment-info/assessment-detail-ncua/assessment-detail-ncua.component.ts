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
import { DateTime } from 'luxon';


@Component({
  selector: 'app-assessment-detail-ncua',
  templateUrl: './assessment-detail-ncua.component.html',
  styleUrls: ['./assessment-detail-ncua.component.scss'],
  host: { class: 'd-flex flex-column flex-11a' }
})

/**
 * 
 * TODO:
 * Refactor this page to better fit the current NCUA requirements (comment for Brett)
 * 
 */

export class AssessmentDetailNcuaComponent implements OnInit {

  assessment: AssessmentDetail = {};

  // Adding a date property here to avoid breaking any other assessments. Will probably update later.
  assessmentEffectiveDate: Date = new Date();

  contactInitials: string = "";
  lastModifiedTimestamp: string = Date.now().toString();

  assessmentControl = new UntypedFormControl('');
  assessmentCharterControl = new UntypedFormControl('');
  creditUnionOptions: CreditUnionDetails[] = [];
  filteredOptions: Observable<CreditUnionDetails[]>;

  acetDashboard: AcetDashboard;
  examOverride: string = "";

  loading: boolean;

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
    this.loading = true;

    // Load dashboard to keep track of irp overriding
    this.acetSvc.getAcetDashboard().subscribe(
      (data: AcetDashboard) => {
        this.acetDashboard = data;
        this.ncuaSvc.updateExamLevelOverride(this.acetDashboard.override);
        this.examOverride = this.ncuaSvc.chosenOverrideLevel;
        if (this.examOverride !== "" || !this.assessSvc.isISE()) {
          this.loading = false;
        }
      });

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
            if (this.creditUnionOptions[i].charter == this.assessment.charter) {
              this.assessment.charterType = this.creditUnionOptions[i].charterType;
            }
          }
        }
      );

      this.filteredOptions = this.assessmentControl.valueChanges.pipe(
        startWith(''), map(value => {
          let tval = "";
          if (typeof value === 'string') {
            tval = value;
          }
          else {
            //tval= value.name;
          }
          const name = tval;
          return name ? this.filter(name as string) : this.creditUnionOptions.slice();
        }),
      );
    }

    this.assessSvc.getLastModified().subscribe((data: any) => {
      this.lastModifiedTimestamp = DateTime.fromISO(data.lastModifiedDate).toLocaleString(DateTime.TIME_24_WITH_SECONDS)
      // NCUA specifically asked for the ISE assessment name to update to the 'ISE format' as soon as the page loads.
      // The time stamp (above) is the final piece of that format that is necessary, so we update the assess name here.
      this.createAssessmentName();
    });

    this.ncuaSvc.getSubmissionStatus().subscribe((result: any) => {
      this.ncuaSvc.iseHasBeenSubmitted = result;
    });
  }

  /**
   * Called every time this page is loaded.  
   */
  getAssessmentDetail() {
    this.assessment = this.assessSvc.assessment;

    // a few things for a brand new assessment
    if (this.assessSvc.isBrandNew) {
      //this.assessSvc.setNcuaDefaults(); <-- legacy from check boxes. Breaks gallery cards.

      this.assessSvc.getAssessmentContacts().then((response: any) => {
        this.contactInitials = "_" + response.contactList[0].firstName;
        this.createAssessmentName();
      });

      this.assessSvc.updateAssessmentDetails(this.assessment);
    } else {
      // This will keep the contact initials the same, even when importing an assessment changes the assessment owner
      if (this.assessment.assessmentName !== "New Assessment" && !(this.assessment.assessmentName.includes("merged"))) {
        let splitNameArray = this.assessment.assessmentName.split("_");
        if (splitNameArray[1] !== "undefined" && splitNameArray[1] !== undefined) {
          this.contactInitials = "_" + splitNameArray[1];
        } else {
          this.contactInitials = "";
        }
      }
    }

    this.assessSvc.isBrandNew = false;

    this.setCharterPad();
    this.ncuaSvc.ISE_StateLed = this.assessment.isE_StateLed;

    this.ncuaSvc.updateAssetSize(this.assessment.assets);


    // Null out a 'low date' so that we display a blank
    const assessDate: Date = new Date(this.assessment.assessmentDate);
    this.assessmentEffectiveDate = assessDate;

    if (assessDate.getFullYear() <= 1900) {
      this.assessment.assessmentDate = null;
      this.assessmentEffectiveDate = null;
    }

  }

  /**
   * 
   */
  displayOptions(creditUnion: CreditUnionDetails): string {
    return creditUnion.name && creditUnion.name ? creditUnion.name : '';
  }

  /**
   * 
   */
  filter(name: string): CreditUnionDetails[] {
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

    let i = 0;
    while (i < this.creditUnionOptions.length) {
      if (e.target.value == this.creditUnionOptions[i].name) {
        this.populateAssessmentFields(i);
        break;
      }

      if ((e.target.value.padStart(5, '0')) === (this.creditUnionOptions[i].charter.toString())) {
        this.populateAssessmentFields(i);
        break;
      }

      i++;
    }

    if (e.target.value.padStart(5, '0') === '00000') {
      this.clearAssessmentFields();
    }

    this.createAssessmentName();
    this.setCharterPad();

    // Set the name & charter in NCUA service to enable the MERIT submit button on the reports page
    this.ncuaSvc.creditUnionName = this.assessment.creditUnion;
    this.ncuaSvc.creditUnionCharterNumber = this.assessment.charter;

    if (+this.assessment.charter < 60000) {
      this.ncuaSvc.ISE_StateLed = false;
    }
    this.assessSvc.updateAssessmentDetails(this.assessment);
  }

  /**
  * 
  */
  populateAssessmentFields(i: number) {
    this.assessment.creditUnion = this.creditUnionOptions[i].name;
    this.assessment.cityOrSiteName = this.creditUnionOptions[i].cityOrSite;
    this.assessment.stateProvRegion = this.creditUnionOptions[i].state;
    this.assessment.charter = this.creditUnionOptions[i].charter;
    this.assessment.charterType = this.creditUnionOptions[i].charterType;
    this.assessment.regionCode = this.creditUnionOptions[i].regionCode;

    if (this.creditUnionOptions[i].charterType == 1 || +this.assessment.charter >= 60000) {
      this.assessment.isE_StateLed = false;
    }

    this.acetDashboard.creditUnionName = this.creditUnionOptions[i].name;
    this.acetDashboard.charter = this.creditUnionOptions[i].charter;
  }

  /**
  * 
  */
  clearAssessmentFields() {
    this.assessment.creditUnion = "";
    this.assessment.cityOrSiteName = "";
    this.assessment.stateProvRegion = "";
    this.assessment.charter = '00000';
    this.assessment.charterType = 0;
    this.assessment.regionCode = 0;
    this.assessment.assets = '0';
    this.assessment.isE_StateLed = false;
    this.updateAssets();

  }

  /**
  * 
  */
  updateAssets() {
    if (this.assessment.assets == null) {
      this.assessment.assets = "0";
    }
      
    this.ncuaSvc.updateAssetSize(this.assessment.assets);
    this.acetDashboard.assets = this.assessment.assets;

    if (this.ncuaSvc.assetsAsNumber > 50000000) {
      this.updateOverride("No Override");
    }

    this.assessSvc.updateAssessmentDetails(this.assessment);
  }

  /**
  * 
  */
  updateOverride(e: any) {
    this.examOverride = e;
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

  /**
  * 
  */
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
    
    // Specific ISE assessment names that we don't want bleeding over to ACET.
    if (this.isAnExamination()) {
      this.assessment.assessmentName = this.assessment.assessmentName + ", " + this.lastModifiedTimestamp;
      this.assessment.assessmentName = this.assessment.assessmentName + this.contactInitials;
    }
  }

  /**
  * 
  */
  toggleJoint() {
    this.ncuaSvc.ISE_StateLed = !this.ncuaSvc.ISE_StateLed;

    this.assessment.isE_StateLed = !this.assessment.isE_StateLed;

    this.assessSvc.updateAssessmentDetails(this.assessment);
  }

  /**
  * 
  */
  regionTranslator(regionCode: number) {
    switch (regionCode) {
      case 1:
        return 'Eastern';
      case 2:
        return 'Southern';
      case 3:
        return 'Western';
      case 8:
        return 'ONES';
      default:
        return '';
    }
  }

}
