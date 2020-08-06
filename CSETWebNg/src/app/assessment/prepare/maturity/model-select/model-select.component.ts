import { Component, OnInit } from '@angular/core';
import { Navigation2Service } from '../../../../services/navigation2.service';
import { AssessmentService } from '../../../../services/assessment.service';

@Component({
  selector: 'app-model-select',
  templateUrl: './model-select.component.html'
})
export class ModelSelectComponent implements OnInit {

  // this should be stored in a service
  selectedModels = [];

  constructor(
    private assessSvc: AssessmentService,
    public navSvc2: Navigation2Service
  ) { }

  /**
   * 
   */
  ngOnInit() {
  }

  /**
   * 
   */
  selectModel(model: string) {
    // record it in the API - where?
    if (this.selectedModels.indexOf(model) < 0) {
      this.selectedModels.push(model);
    } else {
      this.selectedModels.splice(this.selectedModels.indexOf(model), 1);
    }


    // add the selected model to the navigation workflow

    
  }
}
