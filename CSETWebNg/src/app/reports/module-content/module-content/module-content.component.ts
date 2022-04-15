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
      });

    this.reportSvc.getModuleContent(this.setName).subscribe(rpt => {
      this.set = rpt;
    });
  }
}
