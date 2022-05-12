import { Component, OnInit, ViewChild } from '@angular/core';
import { StandardsBlock } from '../../../models/standards.model';
import { StandardService } from '../../../services/standard.service';
import { SetBuilderService } from '../../../services/set-builder.service';

@Component({
  selector: 'app-module-content-launch',
  templateUrl: './module-content-launch.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class ModuleContentLaunchComponent implements OnInit {

  standards: any[];

  selectedStandard;

  /**
   * 
   */
  constructor(
    private standardSvc: StandardService,
    private setBuilderSvc: SetBuilderService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.setBuilderSvc.getAllSetList().subscribe((x: any[]) => {
      this.standards = x;
    });
  }

  /**
   * 
   */
  launchReport() {
    const url = '/report/module-content?m=' + this.selectedStandard;
    window.open(url);
  }

}
