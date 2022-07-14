import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { ReportService } from '../../../services/report.service';


@Component({
  selector: 'app-module-content',
  templateUrl: './module-content.component.html',
  styleUrls: ['./module-content.component.scss']
})
export class ModuleContentComponent implements OnInit {

  setName: string;
  set: any;

  modelId: string;
  model: any;

  /**
   * 
   */
  constructor(
    public reportSvc: ReportService,
    public route: ActivatedRoute
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.route.queryParams
      .subscribe(params => {
        this.setName = params.m;
        this.modelId = params.mm;
      });

    if (!!this.setName) {
      this.reportSvc.getModuleContent(this.setName).subscribe(rpt => {
        this.set = rpt;
      });
    }

    if (!!this.modelId) {
      this.reportSvc.getModelContent(this.modelId).subscribe(rpt => {
        console.log(rpt);
        this.model = rpt;
      });
    }

  }
}
