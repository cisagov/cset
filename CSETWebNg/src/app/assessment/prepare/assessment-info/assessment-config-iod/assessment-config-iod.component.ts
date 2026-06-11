////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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
import { AssessmentDetail } from '../../../../models/assessment-info.model';
import { DemographicsIod } from '../../../../models/demographics-iod.model';
import { User } from '../../../../models/user.model';
import { AssessmentService } from '../../../../services/assessment.service';
import { ConfigService } from '../../../../services/config.service';
import { DemographicIodService } from '../../../../services/demographic-iod.service';
import { DemographicService } from '../../../../services/demographic.service';
import { Upgrades } from '../../../../models/assessment-info.model';
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { ContactsService } from '../../../../services/contacts.service';

@Component({
  selector: 'app-assessment-config-iod',
  templateUrl: './assessment-config-iod.component.html',
  styleUrls: ['./assessment-config-iod.component.scss'],
  standalone: false
})
export class AssessmentConfigIodComponent implements OnInit {
  iodDemographics: DemographicsIod = {};
  demographics: any = {};
  contacts: User[] = [];
  assessment: AssessmentDetail = {};
  IsPCII: boolean = false;
  showUpgrade: boolean = false;
  targetModel: string = '';


  constructor(
    private readonly assessSvc: AssessmentService,
    private readonly demoSvc: DemographicService,
    private readonly iodDemoSvc: DemographicIodService,
    private readonly contactsSvc: ContactsService,
    private readonly configSvc: ConfigService,
    private readonly navSvc: NavigationService
  ) { }

  ngOnInit() {
    this.demoSvc.getDemographic().subscribe((data: any) => {
      this.demographics = data;
      this.assessSvc.assessment.ssgModelIds = data.ssgModelIds;

      // default technology domain to IT
      this.demographics.techDomain ??= 'IT';
    });

    this.iodDemoSvc.getDemographics().subscribe((data: any) => {
      this.iodDemographics = data;
    });

    this.getAssessmentDetail();

    if (this.configSvc.showAssessmentUpgrade()) {
      this.assessSvc.checkUpgrades().subscribe((data: Upgrades) => {
        if (data) {
          this.showUpgrade = (data != null);
          this.assessSvc.galleryItemGuid = data.target;
          this.assessSvc.convertToModel = data.name;
        }
      })
    }

    // when the contacts list changes, update the local list
    this.contactsSvc.contactsUpdated$.subscribe((contacts: User[]) => {
      this.contacts = structuredClone(contacts);
    });
  }

  /**
   * Called every time this page is loaded.
   */
  getAssessmentDetail() {
    this.assessment = this.assessSvc.assessment;
    this.IsPCII = this.assessment.is_PCII ?? false;

    this.assessSvc.isBrandNew = false;

    // Null out a 'low date' so that we display a blank
    const assessDate: Date = new Date(this.assessment.assessmentDate ?? '0001-01-01');
    if (assessDate.getFullYear() <= 1900) {
      this.assessment.assessmentDate = null;
    }
  }

  /**
   *
   */
  update(e) {
    // default Assessment Name if it is left empty
    if (this.assessment) {
      if (this.assessment.assessmentName?.trim().length === 0) {
        this.assessment.assessmentName = '(Untitled Assessment)';
      }
    }
    this.assessSvc.updateAssessmentDetails(this.assessment);
  }

  /**
   * 
   */
  changeIsPCII(val: boolean) {
    if (this.assessment) {
      this.IsPCII = val;
      this.assessment.is_PCII = val;

      if (!this.assessment.is_PCII) {
        this.assessment.pciiNumber = undefined;
      }

      this.configSvc.userIsCisaAssessor = true;
      this.assessSvc.updateAssessmentDetails(this.assessment);
    }
  }

  isCisaAssessorMode() {
    // IOD means your in CISA Asssessor mode
    return this.configSvc.installationMode == "IOD";
  }

  updateDemographics() {
    this.demoSvc.updateDemographic(this.demographics);
  }

  updateDemographicsIod() {
    this.iodDemoSvc.updateDemographic(this.iodDemographics);
  }

  showCityName() {
    return this.configSvc.behaviors.showCityName;
  }

  showStateName() {
    return this.configSvc.behaviors.showStateName;
  }

  showFacilitator() {
    return this.configSvc.behaviors.showFacilitatorDropDown;
  }

  updateAssessorMode() {
    this.assessment.assessorMode = !this.assessment.assessorMode;
    // Sets assessment level assessor mode and navigates to configuration page in non-assessor mode
    this.assessSvc.setAssessorSetting(this.assessment.assessorMode).subscribe(() => {
      this.navSvc.navBack('info2');
    });


  }
  setAssessmentDone() {
    this.assessment.done = !this.assessment.done;
    this.assessSvc.setAssesmentDone(this.assessment.done).subscribe();
  }
}
