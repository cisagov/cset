export var multi = [  
  {
    "name": "Your Organization",
    "series": [
      {
        "name": "MIL-0",
        "value": 700
      },
      {
        "name": "0.25",
        "value": 600
      },
      {
        "name": "0.5",
        "value": 600
      },
      {
        "name": "0.75",
        "value": 600
      },
      {
        "name": "MIL-2",
        "value": 600
      }]
    },
    {
      "name": "Their Organization",
    "series": [
      {
        "name": "MIL-0",
        "value": 600
      },
      {
        "name": "0.25",
        "value": 600
      },
      {
        "name": "0.5",
        "value": 600
      },
      {
        "name": "0.75",
        "value": 500
      },
      {
        "name": "MIL-2",
        "value": 500
      }]  
    }
];
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-edm-bluebar-chart',
  templateUrl: './edm-bluebar-chart.component.html',
  styleUrls: ['./edm-bluebar-chart.component.scss']
})
export class EdmBluebarChartComponent implements OnInit {

  multi: any[];
  view: any[] = [1000, 200];
  percentage = 0;
  // options
  showXAxis: boolean = true;
  showYAxis: boolean = true;
  gradient: boolean = true;
  showLegend: boolean = false;
  showXAxisLabel: boolean = true;
  yAxisLabel: string = 'Your Organization';
  showYAxisLabel: boolean = false;
  xAxisLabel: string = "";
  colorScheme = {
    domain: ['#4B67B0','#4B67B0','#4B67B0','#4B67B0','#4B67B0','#4B67B0','#4B67B0']
  };

  constructor() {
    Object.assign(this, { multi });
  }

  onSelect(data): void {
    console.log('Item clicked', JSON.parse(JSON.stringify(data)));
  }

  onActivate(data): void {
    console.log('Activate', JSON.parse(JSON.stringify(data)));
  }

  onDeactivate(data): void {
    console.log('Deactivate', JSON.parse(JSON.stringify(data)));
  }
  ngOnInit(): void {
  }

}
