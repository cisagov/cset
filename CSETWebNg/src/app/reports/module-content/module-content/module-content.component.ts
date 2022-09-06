import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { ReportService } from '../../../services/report.service';


@Component({
  selector: 'app-module-content',
  templateUrl: './module-content.component.html',
  styleUrls: ['./module-content.component.scss', '../../../reports/reports.scss']
})
export class ModuleContentComponent implements OnInit {

  setName: string;
  set: any;

  modelId: string;
  model: any;

  loading = true;

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
    this.set = null;
    this.model = null;

    this.route.queryParams
      .subscribe(params => {
        this.setName = params.m;
        this.modelId = params.mm;

        if (!!this.setName) {
          this.reportSvc.getModuleContent(this.setName).subscribe(rpt => {
            this.loading = false;
            this.set = rpt;
          });
        }

        if (!!this.modelId) {
          this.reportSvc.getModelContent(this.modelId).subscribe(rpt => {
            this.loading = false;
            this.model = rpt;
          });
        }
      });
  }

  toggleShowGuidance(evt: any) {
    this.reportSvc.showGuidance = evt.target.checked;
  }

  toggleShowReferences(evt: any) {
    this.reportSvc.showReferences = evt.target.checked;
  }
}
