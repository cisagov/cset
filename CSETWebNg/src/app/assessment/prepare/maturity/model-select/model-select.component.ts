import { Component, OnInit } from '@angular/core';
import { NavigationService } from '../../../../services/navigation.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { MaturityService } from '../../../../services/maturity.service';
import { ConfigService } from '../../../../services/config.service';

@Component({
  selector: 'app-model-select',
  templateUrl: './model-select.component.html'
})
export class ModelSelectComponent implements OnInit {

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
  }

  /**
   * 
   */
  changeSelection(event: any, model: string) {
    // the models are currently single-select, so whichever
    // radio button was clicked, that's the only model we will use
    if (!!this.assessSvc.assessment) {
      this.assessSvc.assessment.MaturityModel = model;
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
}
