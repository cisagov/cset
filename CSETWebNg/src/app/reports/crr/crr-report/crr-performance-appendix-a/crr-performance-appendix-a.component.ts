import { Component, Input, OnInit } from '@angular/core';
import { CrrPerformanceAppendixA } from '../../../../models/crrperformanceappendixa.model';
import { CrrReportModel } from '../../../../models/reports.model';
import { CrrService } from '../../../../services/crr.service';
import { Observable } from 'rxjs/Observable';


@Component({
  selector: 'app-crr-performance-appendix-a',
  templateUrl: './crr-performance-appendix-a.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrPerformanceAppendixAComponent implements OnInit {

  @Input() model: CrrReportModel;

  modelData : CrrPerformanceAppendixA;

  constructor(private crrSvc: CrrService) { }

  ngOnInit(): void {
    this.crrSvc.getCrrPerformanceAppendixA().subscribe((resp: CrrPerformanceAppendixA) =>{
      console.log("resp.CrrPerformanceLegend:  "+resp.crrPerformanceLegend);
      this.modelData = resp;
      console.log("this.modelData.CrrPerformanceLegend:  "+this.modelData.crrPerformanceLegend);
    });

    }


  }


