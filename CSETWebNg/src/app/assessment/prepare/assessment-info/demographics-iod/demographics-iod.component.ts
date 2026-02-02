////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
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
import { Component, Input, OnInit } from '@angular/core';
import { DemographicIodService } from '../../../../services/demographic-iod.service';
import { DemographicsIod } from '../../../../models/demographics-iod.model';
import { Observable } from 'rxjs';
import { MatDialog } from '@angular/material/dialog';
import { AssessmentService } from '../../../../services/assessment.service';
import { ConfigService } from '../../../../services/config.service';
import { ServiceDemographic, AssessmentConfig, ServiceComposition, CriticalServiceInfo } from '../../../../models/assessment-info.model';
import { ConstantsService } from '../../../../services/constants.service';
import { OkayComponent } from '../../../../dialogs/okay/okay.component';
import { TranslocoService } from '@jsverse/transloco';


@Component({
  selector: 'app-demographics-iod',
  templateUrl: './demographics-iod.component.html',
  styleUrls: ['./demographics-iod.component.scss'],
  standalone: false
})
export class DemographicsIodComponent implements OnInit {

  @Input() events: Observable<void>;

  /**
   * The principal model for this page
   */
  @Input() demographicData: DemographicsIod = {};
  assessmentConfig: AssessmentConfig;
  serviceDemographics: ServiceDemographic;
  serviceComposition: ServiceComposition;


  /**
   * 
   */
  constructor(public demoSvc: DemographicIodService,
    private assessSvc: AssessmentService,
    public dialog: MatDialog,
    private configSvc: ConfigService,
    private c: ConstantsService,
    private tSvc: TranslocoService
  ) { }

  /**
   *
   */
  ngOnInit() {
    this.populateDemographicsModel();
  }

  /**
   * 
   */
  populateDemographicsModel() {
    this.demoSvc.getDemographics().subscribe((data: DemographicsIod) => {
      this.demographicData = data;

      if (this.demographicData.acknowledgement == true) {
        const dlgOkay = this.dialog.open(OkayComponent, {
          data: {
            title: this.tSvc.translate('sector changes'),
            messageText: this.tSvc.translate('sector acknowledgement')
          }
        }).afterClosed().subscribe(result => {
          this.assessSvc.saveAcknowledgement().subscribe();
        });
      }
    })
  }

  /**
   * 
   */
  changeRegType1(o: any, evt: any) {
    this.demographicData.regulationType1 = o.optionValue;
    this.updateDemographics();
  }

  /**
   * 
   */
  changeRegType2(o: any, evt: any) {
    this.demographicData.regulationType2 = o.optionValue;
    this.updateDemographics();
  }

  /**
   * 
   */
  changeShareOrg(org: any, evt: any) {
    org.selected = evt.target.checked;
    if (org.selected) {
      this.demographicData.shareOrgs.push(org.optionValue);
    } else {
      this.demographicData.shareOrgs.splice(this.demographicData.shareOrgs.indexOf(org.optionValue, 0), 1);
    }
    this.updateDemographics();
  }

  /**
   * 
   */
  isSharedOrgChecked(org): boolean {
    return this.demographicData.shareOrgs.includes(org.optionValue);
  }

  /**
   * Set a boolean property on a model.  
   */
  setBool(model: any, prop: string, state: boolean) {
    model[prop] = state;

    if (prop == 'usesStandard' && !state) {
      model['standard1'] = null;
      model['standard2'] = null;
    }

    if (prop == 'requiredToComply' && !state) {
      model['regulationType1'] = null;
      model['reg1Other'] = null;
      model['regulationType2'] = null;
      model['reg2Other'] = null;
    }
    this.updateDemographics();
  }

  /**
   * 
   */
  update(event: any) {
    this.updateDemographics();
  }

  /**
   * 
   */
  updateDemographics() {
    this.configSvc.userIsCisaAssessor = true;
    this.demographicData.sectorDirective = 'NIPP';

    // keep a few things in sync
    this.assessSvc.assessment.facilityName = this.demographicData.organizationName;

    this.demoSvc.updateDemographic(this.demographicData);
  }
} 
