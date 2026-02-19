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
import { NavigationService } from '../../../services/navigation/navigation.service';
import { DemographicService } from '../../../services/demographic.service';
import { DemographicIodService } from '../../../services/demographic-iod.service';
import { CsiServiceDemographic } from '../../../models/csi.model';
import { CsiService } from '../../../services/cis-csi.service';
import { ConfigService } from '../../../services/config.service';
import { AssessmentContactsResponse } from '../../../models/assessment-info.model';
import { AssessmentService } from '../../../services/assessment.service';
import { User } from '../../../models/user.model';

@Component({
  selector: 'app-csi',
  templateUrl: './critical-service.component.html',
  standalone: false
})
export class CriticalServiceComponent implements OnInit {

  /**
   * The 'id' that this page is using to distinguish
   * itself from other instances in the workflow.
   */
  aliasId: string;

  demographics: any = {};
  iodDemographics: any = {};

  csiServiceDemographic: CsiServiceDemographic = {};
  serviceComposition: any = {};
  contacts: User[];


  constructor(
    public assessSvc: AssessmentService,
    public configSvc: ConfigService,
    public navSvc: NavigationService,
    public demoSvc: DemographicService,
    public iodDemoSvc: DemographicIodService,
    public csiSvc: CsiService
  ) { }

  ngOnInit(): void {
    this.aliasId = this.navSvc.destinationId;

    this.demoSvc.getDemographic().subscribe((data: any) => {
      this.demographics = data;
    });

    this.iodDemoSvc.getDemographics().subscribe((data: any) => {
      this.iodDemographics = data;
    });

    this.csiSvc.getCsiServiceDemographic().subscribe((result: CsiServiceDemographic) => {
      this.csiServiceDemographic = result;
    });

    this.refreshContacts();
  }

  updateServiceComp(): void {
    this.csiSvc.updateCsiServiceComposition(this.serviceComposition);
  }

  updateDemographics() {
    this.demoSvc.updateDemographic(this.demographics);
  }

  updateDemographicsIod() {
    this.iodDemoSvc.updateDemographic(this.iodDemographics);
  }

  refreshContacts() {
    if (this.assessSvc.id()) {
      this.assessSvc.getAssessmentContacts().then((data: AssessmentContactsResponse) => {
        this.contacts = data.contactList;
      });
    }
  }



  showErrors() {
    return this.configSvc.installationMode === 'IOD';
  }
}
