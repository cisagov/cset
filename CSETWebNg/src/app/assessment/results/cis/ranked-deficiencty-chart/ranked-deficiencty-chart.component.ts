import { Component, OnInit, AfterViewInit  } from '@angular/core';
import { ChartService } from '../../../../services/chart.service';
import  Chart  from 'chart.js/auto';
import { CisRankedDeficiencyComponent } from '../../../../reports/cis/cis-ranked-deficiency/cis-ranked-deficiency.component';
import { CisService } from '../../../../services/cis.service';

@Component({
  selector: 'app-ranked-deficiencty-chart',
  templateUrl: './ranked-deficiencty-chart.component.html',
  styleUrls: ['./ranked-deficiencty-chart.component.scss', '../../../../reports/reports.scss']
})

export class RankedDeficienctyChartComponent implements AfterViewInit {

  rankedChart: Chart;
  loading = true;
  hasBaseline:boolean = false;

  constructor(public chartSvc: ChartService, public cisSvc: CisService) { }

 ngAfterViewInit(): void {
   this.setUpChart();
 }

  setUpChart(){
    if (this.cisSvc.hasBaseline()){
      this.hasBaseline = true;
      this.cisSvc.getDeficiencyData().subscribe((data:any)=>{

        data.option = {options: false};
        var opts = {scales:{x:{position:'top', min:-100, max:100}, x1:{position:'bottom',min:-100, max:100}}};
        this.rankedChart = this.chartSvc.buildHorizBarChart('ranked-deficiency',data, false,false, opts, false);
        
        this.loading = false;
      });
    } else {
      this.hasBaseline = false;
      this.loading = false;
    }
  }

}
