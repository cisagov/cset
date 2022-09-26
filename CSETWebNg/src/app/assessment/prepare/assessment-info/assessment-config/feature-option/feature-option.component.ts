/////////////////////////////
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
import { Component, Input, OnInit } from '@angular/core';
import { Console } from 'console';
import { AssessmentService } from '../../../../../services/assessment.service';
import { ConfigService } from '../../../../../services/config.service';
import { MaturityService } from '../../../../../services/maturity.service';
import { NavigationService } from '../../../../../services/navigation.service';

@Component({
  selector: 'app-feature-option',
  templateUrl: './feature-option.component.html',
  styleUrls: ['./feature-option.component.scss']
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

  /**
   * Indicates weather or not the record is a new one as going forward
   * we will only allow for a single assessment feature to be selected
   * within new assessments
   */
  isNotLegacy: boolean;
  constructor(
    public assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public configSvc: ConfigService,
    public maturitySvc: MaturityService
  ) { }

  ngOnInit(): void { 
    this.isNotLegacy = !this.checkIfLegacy();
  } 

  /**
  * LEGACY SUBMIT:  Sets the selection of a feature and posts the assesment detail to the server.
  */
  submitlegacy(feature, event: any) {

    const value = event.srcElement.checked;

    if(!this.isNotLegacy){
      this.selectFeature(feature, value);
    }

    if(this.isNotLegacy){
      this.setFeatureDefault();
      this.selectFeature(feature, value);
    } else {
      this.isNotLegacy = !this.checkIfLegacy();
    }

    // special case for acet-only
    if (feature == 'acet-only') {
      this.assessSvc.assessment.isAcetOnly = value;

      if (value) {
        this.assessSvc.setAcetDefaults();
      } 
    }

    if (this.assessSvc.assessment.useMaturity) {
      if (this.assessSvc.assessment.maturityModel == undefined) {
        switch (this.configSvc.installationMode || '') {
          case "ACET":
            this.assessSvc.assessment.maturityModel = this.maturitySvc.getModel("ACET");
            break;
          default:
            this.assessSvc.assessment.maturityModel = this.maturitySvc.getModel("CRR");
        }
      }
      if (this.assessSvc.assessment.maturityModel?.maturityTargetLevel
        || this.assessSvc.assessment.maturityModel?.maturityTargetLevel == 0) {
        this.assessSvc.assessment.maturityModel.maturityTargetLevel = 1;
      }
    } else {
      this.assessSvc.assessment.isAcetOnly = false;
    }

    this.assessSvc.updateAssessmentDetails(this.assessSvc.assessment);

    // tell the nav service to refresh the nav tree
    localStorage.removeItem('tree');
    this.navSvc.buildTree(this.navSvc.getMagic());
  }

  acetOnlyOption(feature: any, event: any) {
    if (event.srcElement.checked) {
      this.assessSvc.setAcetDefaults();
      this.onChange(feature, event);
    } else {
      this.assessSvc.assessment.isAcetOnly = false;
      this.assessSvc.assessment.maturityModel = undefined;
      this.onChange(feature, event);
    }
  }

  onChange(feature: any, event: any){

    var checkboxes = (<HTMLInputElement[]><any>document.getElementsByClassName("checkbox-custom"));
   
    if(!this.isNotLegacy){
      this.submitlegacy(feature, event);
      return
    }

    for(let i = 0; i < checkboxes.length; i++)
    {
      if(checkboxes[i].type == "checkbox")
      {
        if(checkboxes[i].name === feature.code)
        {
          checkboxes[i].checked = true;
          this.submitlegacy(feature, event);
        }
        else
        {
          checkboxes[i].checked = false;
        }
      }
    }
  }

  setFeatureDefault(){
    this.assessSvc.assessment.useMaturity = false;
    this.assessSvc.assessment.useStandard = false;
    this.assessSvc.assessment.useDiagram = false;
  }

  checkIfLegacy(){
    let count = 0;
    count += this.assessSvc.assessment.useMaturity ? 1 : 0;
    count += this.assessSvc.assessment.useStandard ? 1 : 0;
    count += this.assessSvc.assessment.useDiagram ? 1 : 0;
 
    return count > 1;
  }

  /**
   * Toggles the open/closed style of the description div.
   */
  toggleExpansion() {
    this.expandedDesc = !this.expandedDesc;
  }

  selectFeature(feature:any, value: boolean){
    if (feature.code === 'maturity' && this.assessSvc.assessment.isAcetOnly === false) {
      value = true;
    }
    switch (feature.code) {
      case 'maturity':
        this.assessSvc.assessment.useMaturity = value;
        break;
      case 'standard':
        this.assessSvc.assessment.useStandard = value;
        break;
      case 'diagram':
        this.assessSvc.assessment.useDiagram = value;
        break;
    }
  }

  /**
   *
   */
  toggleExpansionAcet() {
    this.expandedAcet = !this.expandedAcet;
  }
}
