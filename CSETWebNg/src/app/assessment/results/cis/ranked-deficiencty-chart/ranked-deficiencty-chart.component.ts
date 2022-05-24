import { Component, OnInit } from '@angular/core';
import { ChartService } from '../../../../services/chart.service';
import  Chart  from 'chart.js/auto';
import { CisRankedDeficiencyComponent } from '../../../../reports/cis/cis-ranked-deficiency/cis-ranked-deficiency.component';
import { CisService } from '../../../../services/cis.service';

@Component({
  selector: 'app-ranked-deficiencty-chart',
  templateUrl: './ranked-deficiencty-chart.component.html',
  styleUrls: ['./ranked-deficiencty-chart.component.scss', '../../../../reports/reports.scss']
})

export class RankedDeficienctyChartComponent implements OnInit {

  rankedChart: Chart;
  loading = true;

  constructor(public chartSvc: ChartService, public cisSvc: CisService) { }

  ngOnInit(): void {
    this.setUpChart();
  }

  setUpChart(){
   
    this.cisSvc.getDeficiencyData().subscribe((data:any)=>{
      data.option = {options: false};
      this.rankedChart = this.chartSvc.buildHorizBarChart('ranked-deficiency',data, false,false);
      this.loading = false;
    });
  }

}
