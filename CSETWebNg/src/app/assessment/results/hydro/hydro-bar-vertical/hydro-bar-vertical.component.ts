import { Component, Input, OnInit, ViewChild } from '@angular/core';

@Component({
  selector: 'app-hydro-bar-vertical',
  templateUrl: './hydro-bar-vertical.component.html',
  styleUrls: ['./hydro-bar-vertical.component.scss']
})
export class HydroBarVerticalComponent implements OnInit {
  @ViewChild('barChart') barChart;
  @Input() barData: any;
  @Input() subCatNames: any;
  @Input() colorScheme: any;
  @Input() view: any;

  data: any[] = [];
  dataList: any[];

  // colorScheme = {
  //   domain: ['#426A5A', '#7FB685', '#B4EDD2', '#D95D1E']
  // };

  ngOnInit() {
    for (let i = 0; i < this.barData.length; i++) {
      let domainImpacts = this.barData[i];

      let currSubCatImpactList = {
        "name": this.subCatNames[i],
        "series": [
          {
            "name": "Economic",
            "value": domainImpacts[0]
          },
          {
            "name": "Environmental",
            "value": domainImpacts[1]
          },
          {
            "name": "Operational",
            "value": domainImpacts[2]
          },
          {
            "name": "Safety",
            "value": domainImpacts[3]
          }
        ]
      };
      this.data.push(currSubCatImpactList);
    }
  }
}
