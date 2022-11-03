import { Component, OnInit } from '@angular/core';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-mvra-summary',
  templateUrl: './mvra-summary.component.html',
  styleUrls: ['./mvra-summary.component.scss']
})
export class MvraSummaryComponent implements OnInit {

  model:any = [];
  flattenedModel:any = [];
  initialized:boolean = false;
  errors: boolean = false;

  constructor(public maturitySvc: MaturityService) { }

  ngOnInit(): void {
    this.maturitySvc.getMvraScoring().subscribe(
      (r: any) => {
        console.log(r)
        this.model = r;
        this.flattenData();
        this.initialized = true;
      },
      error => {
        this.errors = true;
        console.log('Mvra Gaps load Error: ' + (<Error>error).message);
      }
      ), 
      (finish) => {
    };
  }

  flattenData(){
    let m = [];
    this.model.forEach(element => {
      var goal = { title: element.title, credit:'', totalPassed:'', totalTiers:'', function: true };
      this.flattenedModel.push(goal);
      m.push(goal);
      element.levelScores.forEach(level=>{
        let credit = level.totalTiers > 0 ? level.credit + '%' : 'N/A';
        var dGoal = {title: level.level, credit: credit, totalPassed: level.totalPassed, totalTiers: level.totalTiers, function: false }
        m.push(dGoal)
      })
    });
    this.flattenedModel = Object.assign([], m)
  }
}
