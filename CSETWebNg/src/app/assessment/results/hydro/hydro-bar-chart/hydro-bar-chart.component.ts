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
  @Input() colorScheme: any;
  @Input() view: any;

  data: any[] = [];
  dataList: any[];

  xAxis: boolean = false;
  dataLabel: boolean = false;

  ngOnInit() {
    for (let i = 0; i < this.barData.length; i++) {
      let currSubCatWeightArray = this.barData[i];

      if (currSubCatWeightArray.length > 3) {
        this.dataLabel = true;
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

      else {
        this.xAxis = true;
        let currSubCatDataList = {
          "name": this.subCatNames[i],
          "series": [
            {
              "name": "Easy",
              "value": currSubCatWeightArray[0]
            },
            {
              "name": "Medium",
              "value": currSubCatWeightArray[1]
            },
            {
              "name": "Hard",
              "value": currSubCatWeightArray[2]
            }
          ]
        };
        this.data.push(currSubCatDataList);
      }
    }
  }
}
