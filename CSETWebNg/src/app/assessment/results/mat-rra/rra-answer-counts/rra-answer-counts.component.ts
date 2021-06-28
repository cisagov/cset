import { Component, OnInit } from '@angular/core';
import { connectableObservableDescriptor } from 'rxjs/internal/observable/ConnectableObservable';
import { RraDataService } from '../../../../services/rra-data.service';
@Component({
  selector: 'app-rra-answer-counts',
  templateUrl: './rra-answer-counts.component.html',
  styleUrls: ['./rra-answer-counts.component.scss']
})
export class RraAnswerCountsComponent implements OnInit {
  
  sAxisTicks = [0, 5, 10, 15, 18];
  maxLevel = 0;
  answerCountsByLevel = [];
  answerDistribColorScheme = { domain: ['#006100', '#9c0006', '#888888'] };

  constructor(public rraDataSvc: RraDataService) { }

  ngOnInit(): void {
    this.rraDataSvc.getRRADetail().subscribe((r: any) => {
      this.createAnswerCountsByLevel(r);
    });
  }

  createAnswerCountsByLevel(r: any) {
    let levelList = [];

    r.RRASummary.forEach(element => {
      let level = levelList.find(x => x.name == element.Level_Name);
      if (!level) {
        level = {
          name: element.Level_Name, series: [
            { name: 'Yes', value: 0 },
            { name: 'No', value: 0 },
            { name: 'Unanswered', value: 0 },
          ]
        };
        levelList.push(level);
      }

      var p = level.series.find(x => x.name == element.Answer_Full_Name);
      p.value = element.qc;
    });
    this.answerCountsByLevel = levelList;
    this.findMaxLength();
  }

  findMaxLength(){
    let mLength = 0;
    this.answerCountsByLevel.forEach(x =>{
      let length = 0;
      x.series.forEach(y => {
        length += y.value;
      });
      if(mLength < length){
        mLength = length;
      }
    })
    this.maxLevel = mLength;
  }

}
