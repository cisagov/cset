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
import { Component, Input, OnInit, Output, EventEmitter } from '@angular/core';
import { AssessmentService } from '../../../../../services/assessment.service';
import { ConfigService } from '../../../../../services/config.service';
import { MaturityService } from '../../../../../services/maturity.service';
import { NavigationService } from '../../../../../services/navigation/navigation.service';
import { NCUAService } from '../../../../../services/ncua.service';

@Component({
  selector: 'app-feature-option-ncua',
  templateUrl: './feature-option-ncua.component.html'
})
export class FeatureOptionNcuaComponent implements OnInit {

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

  isDisabled: boolean;

  @Output() x = new EventEmitter();

  constructor(
    public assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public configSvc: ConfigService,
    public maturitySvc: MaturityService,
    public ncuaSvc: NCUAService
  ) { }

  ngOnInit(): void {
    // special code -- unselect 'maturity' if ACET or ISE are selected
    if (this.feature.code === 'maturity' &&
      (this.assessSvc.usesMaturityModel('ACET') ||
        this.assessSvc.usesMaturityModel('ISE')
      )) {
      this.feature.selected = false;
    }
  }

  /**
  * Sets the selection of a feature and posts the assesment detail to the server.
  */
  submit(feature, event: any) {
    const optionChecked = event.target.checked;
    switch (feature.code) {
      case 'maturity':
      case 'acet':
      case 'ise':
        this.assessSvc.assessment.useMaturity = optionChecked;
        break;
      case 'standard':
        this.assessSvc.assessment.useStandard = optionChecked;
        break;
      case 'diagram':
        this.assessSvc.assessment.useDiagram = optionChecked;
        break;
    }

    // special case for acet-only
    if (feature == 'acet-only') {
      this.assessSvc.assessment.isAcetOnly = optionChecked;

      if (optionChecked) {
        this.assessSvc.setAcetDefaults();
      }
    }

    if (this.assessSvc.assessment.useMaturity) {

      // set a default maturity model
      if (!this.assessSvc.assessment.maturityModel) {
        switch (this.configSvc.installationMode || '') {
          case "ACET":
            //this.assessSvc.assessment.maturityModel = this.maturitySvc.getModel("ACET");
            break;
          default:
            this.assessSvc.assessment.maturityModel = this.maturitySvc.getModel("CRR");
        }
      }


      // ACET and ISE features should set the maturity model here and now, rather than on the model-select screen
      if (feature.code == 'acet' || feature.code == 'ise') {
        this.assessSvc.setModel(optionChecked ? feature.code : null);
      }


      if (this.assessSvc.assessment.maturityModel?.maturityTargetLevel
        || this.assessSvc.assessment.maturityModel?.maturityTargetLevel == 0) {
        this.assessSvc.assessment.maturityModel.maturityTargetLevel = 1;
      }
    }
    else {
      this.assessSvc.assessment.maturityModel = null;
      this.assessSvc.assessment.isAcetOnly = false;
    }

    this.x.emit('feature-changed');

    this.assessSvc.updateAssessmentDetails(this.assessSvc.assessment);

    // tell the nav service to refresh the nav tree
    this.navSvc.buildTree();
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
