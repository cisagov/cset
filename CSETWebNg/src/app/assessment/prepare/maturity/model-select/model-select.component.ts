import { Component, OnInit } from '@angular/core';
import { NavigationService } from '../../../../services/navigation.service';
import { ConfigService } from '../../../../services/config.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-model-select',
  templateUrl: './model-select.component.html'
})
export class ModelSelectComponent implements OnInit {
  
  docUrl: string;
  cmmcURL: string;

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
    this.cmmcURL = this.docUrl + 'CMMC_ModelMain 1.02.pdf'
    console.log(this.cmmcURL)
  }

  /**
   * 
   */
  changeSelection(event: any, model: string) {
    // the models are currently single-select, so whichever
    // radio button was clicked, that's the only model we will use
    if (!!this.assessSvc.assessment) {
      this.assessSvc.assessment.MaturityModelName = model;
    }

    // refresh Prepare section of the sidenav
    this.navSvc.buildTree(this.navSvc.getMagic());


    this.maturitySvc.postSelection(model).subscribe();
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

  openCMMCDoc(){

  }
}
