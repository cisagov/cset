import { Component, Input, ViewChild } from '@angular/core';

@Component({
  selector: 'app-hydro-donut',
  templateUrl: './hydro-donut.component.html',
  styleUrls: ['./hydro-donut.component.scss']
})
export class HydroDonutComponent {
  @ViewChild('pieChart') pieChart;
  @Input() weightData: any;
  @Input() subCatData: any;
  @Input() totalData: any;

  data: any[];
  view: any[] = [150, 150];

  colorScheme = {
    domain: ['#426A5A', '#7FB685', '#B4EDD2', '#D95D1E']
  };

  totalQuestions: number = 0;

  constructor() {

  }

  ngOnInit(): void {
    for (let i = 0; i < this.totalData.length; i++) {
      this.totalQuestions += this.totalData[i];
    }
    
    this.data = [
      {
        name: "High Impact",
        value: this.roundDecimal(this.weightData[0])
      },
      {
        name: "Medium Impact",
        value: this.roundDecimal(this.weightData[1])
      },
      {
        name: "Low Impact",
        value: this.roundDecimal(this.weightData[2])
      },
      {
        name: "UnImplemented",
        value: this.roundDecimal(this.weightData[3])
      },
    ]
  }

  roundWhole(num: number) {
    return Math.round(num);
  }

  roundDecimal(num: number) {
    return Number(num.toFixed(2));
  }
}
