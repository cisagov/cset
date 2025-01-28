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
import { MatDialogRef } from '@angular/material/dialog';
import { AssessmentService } from '../../services/assessment.service';
import { NavigationService } from '../../services/navigation/navigation.service';
import { AuthenticationService } from '../../services/authentication.service';
import { DemographicService } from '../../services/demographic.service';
import { DemographicIodService } from '../../services/demographic-iod.service';
import { DemographicsIod } from '../../models/demographics-iod.model';
import { AssessmentContactsResponse, AssessmentDetail, Demographic } from '../../models/assessment-info.model';
import { User } from '../../models/user.model';


@Component({
  selector: 'app-version-upgrade',
  templateUrl: './version-upgrade.component.html',
  host: { class: 'd-flex flex-column flex-11a w-100 h-100' }
})
export class VersionUpgradeComponent implements OnInit {

  galleryItem = {
    "gallery_Item_Guid": "c1a1a2f2-4e5d-4c9b-8d9f-1a2b3c4d5e6f",
    "icon_File_Name_Small": null,
    "icon_File_Name_Large": null,
    "configuration_Setup": "{\"Model\":{\"ModelName\":\"CMMC2F\", \"Level\": 1}}",
    "configuration_Setup_Client": null,
    "description": "<p>CMMC 2.0 is a streamlined cybersecurity framework by the U.S. Department of Defense (DoD). It measures the\r\n          implementation of cybersecurity requirements at three maturity levels:</p>\r\n     <ul>\r\n          <li>Level 1 (Foundational): Basic safeguarding requirements for FCI specified in FAR Clause 52.204-21,\r\n               self-assessed.</li>\r\n          <li>Level 2 (Advanced): Aligns with NIST SP 800-171, third-party assessed.</li>\r\n          <li>Level 3 (Expert): Targets advanced threats, aligns with NIST SP 800-172, government-assessed.</li>\r\n     </ul>\r\n     <p>Its goal is to provide increased assurance to the DoD that defense contractors and subcontractors are compliant\r\n          with information protection requirements for FCI and CUI.</p>",
    "title": "Cybersecurity Maturity Model Certification (CMMC) 2.0",
    "parent_Id": 4,
    "is_Visible": true,
    "custom_Set_Name": null,
    "plainText": "CMMC 2.0 is a streamlined cybersecurity framework by the U.S. Department of Defense (DoD). It measures the\n          implementation of cybersecurity requirements at three maturity levels:\n     \n          Level 1 (Foundational): Basic safeguarding requirements for FCI specified in FAR Clause 52.204-21,\n               self-assessed.\n          Level 2 (Advanced): Aligns with NIST SP 800-171, third-party assessed.\n          Level 3 (Expert): Targets advanced threats, aligns with NIST SP 800-172, government-assessed.\n     \n     Its goal is to provide increased assurance to the DoD that defense contractors and subcontractors are compliant\n          with information protection requirements for FCI and CUI."
  }

  contacts: User[];

  demographicData: Demographic = {};
  demoExtData: DemographicsIod = {};
  assessment: AssessmentDetail = {
    assessmentName: ''
  };

  constructor(
    private dialog: MatDialogRef<VersionUpgradeComponent>,
    public assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public authSvc: AuthenticationService,
    public demoSvc: DemographicService,
    public demoExtSvc: DemographicIodService
  ) { }

  close() {
    return this.dialog.close("Upgrade complete");
  }

  async upgrade() {
    let first = this.assessSvc.assessment
    this.demoSvc.getDemographic().subscribe((data: any) => {
      this.demographicData = data;
    })
    this.demoExtSvc.getDemographics().subscribe((data: any) => {
      this.demoExtData = data;
    })
    this.assessment = first;

    try {
      // localStorage.removeItem('assessmentId');
      const assessmentId = await this.assessSvc.newAssessmentGallery(this.galleryItem);
      this.navSvc.beginAssessment(assessmentId)
      this.assessment.id = assessmentId
      this.assessSvc.assessment = this.assessment
    } catch (error) {
      console.error("Error converting assessment:", error);
    }
    this.demoSvc.updateDemographic(this.demographicData);
    this.assessSvc.updateAssessmentDetails(this.assessment);
    this.assessSvc.refreshAssessment();
    this.refreshContacts()
    return this.close();
  }

  ngOnInit() {

  }


  refreshContacts() {
    if (this.assessSvc.id()) {
      this.assessSvc
        .getAssessmentContacts()
        .then((data: AssessmentContactsResponse) => {
          console.log(data)
          this.contacts = data.contactList;
        });
    }
  }


}
