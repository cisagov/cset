import { Component, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core';

@Component({
  selector: 'app-mvra-answer-functions',
  templateUrl: './mvra-answer-functions.component.html',
  styleUrls: ['./mvra-answer-functions.component.scss']
})
export class MvraAnswerFunctionsComponent implements OnInit, OnChanges {

  @Input() model: any; 

  colorScheme1 = { domain: ['#007BFF'] };
  xAxisTicks = [0, 25, 50, 75, 100];
  graphModel:any = [];

  constructor() { }

  ngOnInit(): void {
    //this.createGraphByFunction();
  }

  ngOnChanges(changes: SimpleChanges): void {
    this.model = changes.model.currentValue;
    console.log(changes);
    this.createGraphByFunction();
  }

  createGraphByFunction(){
    let m = [];
    if(this.model){
      console.log(this.model)
      this.model.forEach(element => {
        console.log(element);
        var goal = { name: element.title, value: element.credit };
        m.push(goal);
      });
    }
    this.graphModel = Object.assign([], m)
  }


  formatPercent(x: any) {
    return x + '%';
  }
}
