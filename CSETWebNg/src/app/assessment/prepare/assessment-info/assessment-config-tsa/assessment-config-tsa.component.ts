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
import { MatDialog } from '@angular/material/dialog';
import { AssessmentService } from '../../../../services/assessment.service';
import { ConfigService } from '../../../../services/config.service';
import { MaturityService } from '../../../../services/maturity.service';
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { TsaService } from '../../../../services/tsa.service';


@Component({
  selector: 'app-assessment-config-tsa',
  templateUrl: './assessment-config-tsa.component.html',
  styleUrls: ['./assessment-config-tsa.component.scss']
})
export class AssessmentConfigTsaComponent implements OnInit {


  expandedDesc: boolean[] = [];

  // the list of features that can be selected
  features: any = [];


  /**
   * Constructor.
   */
  constructor(
    private assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public configSvc: ConfigService,
    public dialog: MatDialog,
    public maturitySvc: MaturityService,
    public tsaSvc: TsaService
  ) {

  }

  /**
   *
   */
  ngOnInit() {
    this.navSvc.setCurrentPage('info-tsa');
    this.tsaSvc.TSAGetModelsName().subscribe((data) => {
      this.features = data;
      this.features.forEach(element => {
        if (element.set_Name && !element.model_Name) {
          this.assessSvc.assessment.useStandard;
        } else if (!element.set_Name && element.model_Name) {
          this.assessSvc.assessment.useMaturity;
        }
      });
      //  this.features.find(x => x.name === 'RRA').selected = this.assessSvc.assessment.useMaturity;
      //  this.features.find(x => x.name === 'CRR').selected = this.assessSvc.assessment.useMaturity;
      //  this.features.find(x => x.name === 'VADR').selected = this.assessSvc.assessment.useMaturity;
      //  this.features.find(x => x.name === 'TSA2018').selected = this.assessSvc.assessment.useStandard;
      //  this.features.find(x => x.name === 'CSC_V8').selected = this.assessSvc.assessment.useStandard;
      //  this.features.find(x => x.name === 'APTA_Rail_V1').selected = this.assessSvc.assessment.useStandard;
    })

  }



  /**
   * Returns the URL of the page in the user guide.
   */
  helpDocUrl() {
    switch (this.configSvc.installationMode || '') {
      case "ACET":
        return this.configSvc.docUrl + 'htmlhelp_acet/assessment_configuration.htm';
        break;
      default:
        return this.configSvc.docUrl + 'htmlhelp/prepare_assessment_info.htm';
    }
  }

}
