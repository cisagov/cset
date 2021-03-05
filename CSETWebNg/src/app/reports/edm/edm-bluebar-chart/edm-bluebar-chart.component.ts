import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-edm-bluebar-chart',
  templateUrl: './edm-bluebar-chart.component.html',
  styleUrls: ['./edm-bluebar-chart.component.scss']
})
export class EdmBluebarChartComponent implements OnInit {

  barValue = 0.8;

  constructor() {
  }

  ngOnInit(): void {
  }

  getBlueBarWidth(input){

    let width = 0;
    if(input < 0 || input > 5){
      console.log("BLUE BAR WIDTH VALUE OUTSIDE OF 0-5 RANGE")
    }
    else if(input < 1){
      width = (input * .5) * 100;
    } else {
      width = 50 + (input - 1) * 12.5
    }
    let retVal = {
      'width':`${width}%`
    }
    return retVal
  }

}
