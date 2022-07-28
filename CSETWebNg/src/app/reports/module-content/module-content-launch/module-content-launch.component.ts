import { Component, OnInit, ViewChild } from '@angular/core';
import { SetBuilderService } from '../../../services/set-builder.service';
import { AssessmentService } from '../../../services/assessment.service';

@Component({
  selector: 'app-module-content-launch',
  templateUrl: './module-content-launch.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class ModuleContentLaunchComponent implements OnInit {

  whichType = '';

  standards: any[];
  selectedStandard;

  models: any[];
  selectedModel;

  /**
   * 
   */
  constructor(
    private setBuilderSvc: SetBuilderService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.setBuilderSvc.getAllSetList().subscribe((x: any[]) => {
      this.standards = x.filter(s => s.isDisplayed);
    });

    this.models = AssessmentService.allMaturityModels;
  }

  /**
   * 
   */
  selectType(event: any) {
    this.whichType = event.srcElement.id;
  }

  /**
   * 
   */
  launchModelReport() {
    const url = '/index.html?returnPath=report/module-content?mm=' + this.selectedModel;
    window.open(url, '_blank');
  }

  /**
   * 
   */
  launchStandardReport() {
    const url = '/index.html?returnPath=report/module-content?m=' + this.selectedStandard;
    window.open(url, '_blank');
  }

}
