////////////////////////////////
//
//   Copyright 2021 Battelle Energy Alliance, LLC
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
import { AssessmentService } from '../../../../../services/assessment.service';
import { ConfigService } from '../../../../../services/config.service';
import { MaturityService } from '../../../../../services/maturity.service';
import { NavigationService } from '../../../../../services/navigation.service';

@Component({
  selector: 'app-feature-option',
  templateUrl: './feature-option.component.html'
})
export class FeatureOptionComponent implements OnInit {

  @Input()
  feature: any;
  // code
  // label
  // description
  // expanded

  /**
   * Indicates if the description is expanded
   */
  expandedDesc: boolean;

  /**
   * Indicates the expanded state of the ACET Only description
   */
  expandedAcet: boolean;

  constructor(
    public assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public configSvc: ConfigService,
    public maturitySvc: MaturityService
  ) { }

  ngOnInit(): void {
  }

  /**
  * Sets the selection of a feature and posts the assesment detail to the server.
  */
  submit(feature, event: any) {
    const value = event.srcElement.checked;

    switch (feature.code) {
      case 'maturity':
        this.assessSvc.assessment.UseMaturity = value;
        break;
      case 'standard':
        this.assessSvc.assessment.UseStandard = value;
        break;
      case 'diagram':
        this.assessSvc.assessment.UseDiagram = value;
        break;
    }

    // special case for acet-only
    if (feature == 'acet-only') {
        this.assessSvc.acetOnly = value;
        this.assessSvc.assessment.IsAcet = value;
        this.assessSvc.assessment.IsAcetOnly = value;

        if (value) {
          this.assessSvc.setAcetDefaults();
        }
    }


    if (this.assessSvc.assessment.UseMaturity) {
      if (this.assessSvc.assessment.MaturityModel == undefined) {
        if (this.configSvc.acetInstallation) {
          this.assessSvc.assessment.MaturityModel = this.maturitySvc.getModel("ACET");
        }
        else {
          this.assessSvc.assessment.MaturityModel = this.maturitySvc.getModel("EDM");
        }
      }
      if (this.assessSvc.assessment.MaturityModel?.MaturityTargetLevel
        || this.assessSvc.assessment.MaturityModel?.MaturityTargetLevel == 0) {
        this.assessSvc.assessment.MaturityModel.MaturityTargetLevel = 1;
      }
    }
    this.assessSvc.updateAssessmentDetails(this.assessSvc.assessment);

    // tell the nav service to refresh the nav tree
    sessionStorage.removeItem('tree');
    this.navSvc.buildTree(this.navSvc.getMagic());
  }


  /**
   * Toggles the open/closed style of the description div.
   */
  toggleExpansion() {
    this.expandedDesc = !this.expandedDesc;
  }

  /**
   * 
   */
  toggleExpansionAcet() {
    this.expandedAcet = !this.expandedAcet;
  }
}
