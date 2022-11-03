import { Component, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core';

@Component({
  selector: 'app-mvra-answer-domains',
  templateUrl: './mvra-answer-domains.component.html',
  styleUrls: ['./mvra-answer-domains.component.scss']
})
export class MvraAnswerDomainsComponent implements OnInit, OnChanges {

  @Input() model: any[];
  flattenedModel:any = [];

  constructor() { }

  ngOnInit(): void {
  }

  ngOnChanges(changes: SimpleChanges): void {
    this.model = changes.model.currentValue;   
    this.flattenData();
  }

  flattenData(){
    let m = [];
    this.model.forEach(element => {
      var goal = { title: element.title, credit: element.credit+'%', rating:'', function: true };
      this.flattenedModel.push(goal);
      m.push(goal);
      element.domainScores.forEach(domain=>{
        var dGoal = {title: domain.title, credit: domain.credit, rating: domain.rating, function: false }
        m.push(dGoal)
      })
    });
    this.flattenedModel = Object.assign([], m)
  }

}
