import { Component, Input, OnInit, ViewChild} from '@angular/core';

@Component({
  selector: 'app-hydro-bar-chart',
  templateUrl: './hydro-bar-chart.component.html',
  styleUrls: ['./hydro-bar-chart.component.scss']
})
export class HydroBarChartComponent implements OnInit {

  @ViewChild('barChart') barChart;
  @Input() barData: any;
  @Input() subCatNames: any;

  data: any[] = [];
  view: any[] = [600, 150];
  dataList: any[];

  colorScheme = {
    domain: ['#426A5A', '#7FB685', '#B4EDD2', '#D95D1E']
  };

  ngOnInit() {
    console.log(this.barData)

    for (let i = 0; i < this.barData.length; i++) {
      let currSubCatWeightArray = this.barData[i];

      let currSubCatDataList = {
        "name": this.subCatNames[i],
        "series": [
          {
            "name": "High Impact",
            "value": currSubCatWeightArray[0]
          },
          {
            "name": "Medium Impact",
            "value": currSubCatWeightArray[1]
          },
          {
            "name": "Low Impact",
            "value": currSubCatWeightArray[2]
          },
          {
            "name": "UnImplemented",
            "value": currSubCatWeightArray[3]
          }
        ]
      };
      this.data.push(currSubCatDataList);
    }
    console.log(this.data)
  }
}
