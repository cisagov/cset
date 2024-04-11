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
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { ConfigService } from '../../../../services/config.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { MaturityService } from '../../../../services/maturity.service';
import { MaturityModel } from '../../../../models/assessment-info.model';

@Component({
  selector: 'app-model-select',
  templateUrl: './model-select.component.html',
  styleUrls: ['./model-select.component.scss']
})
export class ModelSelectComponent implements OnInit {

  docUrl: string;
  cmmcURL: string;
  modelChoice: string;
  isTSA: boolean = false;
  // this should be stored in a service
  selectedModels = [];

  constructor(
    public configSvc: ConfigService,
    public assessSvc: AssessmentService,
    public maturitySvc: MaturityService,
    public navSvc: NavigationService
  ) { }

  /**
   *
   */
  ngOnInit() {
    this.docUrl = this.configSvc.docUrl;
    this.cmmcURL = this.docUrl + 'CMMC_ModelMain 1.02.pdf';
    if (this.configSvc.installationMode == "TSA") {
      this.isTSA = true;
    }
  }

  /**
   * Models are single-select within an assessment.
   */
  changeSelection(event: any, model: string) {

    this.modelChoice = model;

    if (!!event && !!this.assessSvc.assessment) {

      this.assessSvc.setModel(model);

      // tell the API which model was selected
      this.maturitySvc.postSelection(model).subscribe((response: MaturityModel) => {
        this.assessSvc.assessment.maturityModel = response;

        // refresh Prepare section of the sidenav
        this.navSvc.buildTree();
      });
    }
  }

  /**
   * Accesses the assessment service to highlight the selected model
   */
  getSelection(model: string) {
    return this.assessSvc.usesMaturityModel(model);
  }

  /**
   * Returns the URL of the model spec document
   */
  url(model: string) {
    switch (model) {
      case 'CMMC':
        return this.configSvc.docUrl + "CMMC_ModelMain 1.02.pdf";
    }

    return '';
  }

  /**
   * Returns the model title that is stored in the database for the given model
   */
  getModelTitle(model: string) {
    return AssessmentService.allMaturityModels.find(x => x.modelName === model)?.modelTitle;
  }

  /**
   * Return the model description that is stored in the database for the given model
   */
  getModelDescription(model: string) {
    return AssessmentService.allMaturityModels.find(x => x.modelName === model)?.modelDescription;
  }
}
