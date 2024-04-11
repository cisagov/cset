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
import { Component, Input, OnInit } from '@angular/core';
import { QuestionRequirementCounts, StandardsBlock } from "../../../../../models/standards.model";
import { AssessmentService } from '../../../../../services/assessment.service';
import { ConfigService } from '../../../../../services/config.service';
import { MaturityService } from '../../../../../services/maturity.service';
import { NavigationService } from '../../../../../services/navigation/navigation.service';
import { StandardService } from '../../../../../services/standard.service';
import { TsaService } from '../../../../../services/tsa.service';
@Component({
  selector: 'app-feature-option-tsa',
  templateUrl: './feature-option-tsa.component.html',
  styleUrls: ['./feature-option-tsa.component.scss']
})
export class FeatureOptionTsaComponent implements OnInit {
  modelSelected: string;
  @Input()
  feature: any;
  // code
  // label
  // description
  // expanded
  @Input()
  features: any;
  standards: StandardsBlock;
  /**
   * Indicates if the description is expanded
   */
  expandedDesc: boolean;
  counts: QuestionRequirementCounts = Object.create(null);

  /**
   * Indicates the expanded state of the ACET Only description
   */
  expandedAcet: boolean;

  constructor(
    public assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public configSvc: ConfigService,
    public maturitySvc: MaturityService,
    public tsaSvc: TsaService,
    private standardSvc: StandardService,
  ) {

  }

  ngOnInit(): void {
    if (this.assessSvc.assessment.standards?.find(x => x === 'TSA2018')) {
      this.features.find(x => x.name === 'TSA2018').selected = true;
    }
    if (this.assessSvc.assessment.standards?.find(x => x === 'CSC_V8')) {
      this.features.find(x => x.name === 'CSC_V8').selected = true;
    }
    if (this.assessSvc.assessment.standards?.find(x => x === 'APTA_Rail_V1')) {
      this.features.find(x => x.name === 'APTA_Rail_V1').selected = true;
    }
    if (this.assessSvc.assessment.maturityModel?.modelName == "CRR") {
      this.features.find(x => x.name === 'CRR').selected = true;
      this.features.find(x => x.name === 'RRA').selected = false;
      this.features.find(x => x.name === 'VADR').selected = false;
    }
    else if (this.assessSvc.assessment.maturityModel?.modelName == "RRA") {
      this.features.find(x => x.name === 'RRA').selected = true;
      this.features.find(x => x.name === 'CRR').selected = false;
      this.features.find(x => x.name === 'VADR').selected = false;
    }
    else if (this.assessSvc.assessment.maturityModel?.modelName == "VADR") {
      this.features.find(x => x.name === 'VADR').selected = true;
      this.features.find(x => x.name === 'RRA').selected = false;
      this.features.find(x => x.name === 'CRR').selected = false;
    }
    else {
      this.features.find(x => x.name === 'CRR').selected = false;
      this.features.find(x => x.name === 'RRA').selected = false;
      this.features.find(x => x.name === 'VADR').selected = false;
    }



    this.loadStandards();
  }

  /**
  * Sets the selection of a feature and posts the assesment detail to the server.
  */
  submittsa(feature, event: any) {
    const value = event.target.checked;

    const model = this.assessSvc.assessment;

    const selectedStandards: string[] = [];

    this.features.forEach(x => {
      if (x.name == 'TSA2018' && x.selected) {

        selectedStandards.push(x.name);
      } else if (x.name == 'CSC_V8' && x.selected) {
        selectedStandards.push(x.name);
      } else if (x.name == 'APTA_Rail_V1' && x.selected) {
        selectedStandards.push(x.name);
      }
    })
    this.assessSvc.assessment.standards = selectedStandards;
    feature.selected = value;
    switch (feature.name) {
      case 'CRR': {
        if (value) {
          this.features.find(x => x.name === 'RRA').selected = false;
          this.features.find(x => x.name === 'VADR').selected = false;
        }

        this.assessSvc.assessment.useMaturity = value;
        this.tsaSvc.TSAtogglecrr(model).subscribe(response => {
          this.assessSvc.assessment.maturityModel = response;
          // tell the nav service to refresh the nav tree
          this.navSvc.buildTree();
        });

        break;
      }

      case 'RRA': {
        if (value) {
          this.features.find(x => x.name === 'CRR').selected = false;
          this.features.find(x => x.name === 'VADR').selected = false;
        }
        this.assessSvc.assessment.useMaturity = value;
        this.tsaSvc.TSAtogglerra(model).subscribe((response) => {
          this.assessSvc.assessment.maturityModel = response;
          // tell the nav service to refresh the nav tree
          this.navSvc.buildTree();
        })
        break;
      }
      case 'VADR': {
        if (value) {
          this.features.find(x => x.name === 'CRR').selected = false;
          this.features.find(x => x.name === 'RRA').selected = false;
        }
        this.assessSvc.assessment.useMaturity = value;
        this.tsaSvc.TSAtogglevadr(model).subscribe((response) => {
          this.assessSvc.assessment.maturityModel = response;
          // tell the nav service to refresh the nav tree
          this.navSvc.buildTree();
        })
        break;
      }

      case 'TSA2018': {
        this.assessSvc.assessment.useStandard = selectedStandards.length > 0;
        this.tsaSvc.postSelections(selectedStandards)
          .subscribe((counts: QuestionRequirementCounts) => {
            this.standards.questionCount = counts.questionCount;
            this.standards.requirementCount = counts.requirementCount;
          });

        this.navSvc.setQuestionsTree();
        if (selectedStandards.length > 0) {
          // tell the nav service to refresh the nav tree
          this.navSvc.buildTree();
        }

        break;
      }
      case 'CSC_V8': {
        this.assessSvc.assessment.useStandard = selectedStandards.length > 0;
        this.tsaSvc.postSelections(selectedStandards)
          .subscribe((counts: QuestionRequirementCounts) => {
            this.standards.questionCount = counts.questionCount;
            this.standards.requirementCount = counts.requirementCount;
          });

        this.navSvc.setQuestionsTree();
        if (selectedStandards.length > 0) {
          // tell the nav service to refresh the nav tree
          this.navSvc.buildTree();
        }
        break;
      }
      case 'APTA_Rail_V1': {
        this.assessSvc.assessment.useStandard = selectedStandards.length > 0;
        this.tsaSvc.postSelections(selectedStandards)
          .subscribe((counts: QuestionRequirementCounts) => {
            this.standards.questionCount = counts.questionCount;
            this.standards.requirementCount = counts.requirementCount;
          });

        this.navSvc.setQuestionsTree();
        if (selectedStandards.length > 0) {
          // tell the nav service to refresh the nav tree
          this.navSvc.buildTree();
        }
        break;
      }
    }

    // tell the nav service to refresh the nav tree
    this.navSvc.buildTree();
  }
  loadStandards() {
    this.standardSvc.getStandardsList().subscribe(
      (data: StandardsBlock) => {
        this.standards = data;
      })
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
