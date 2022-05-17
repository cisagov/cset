import { Component, OnInit } from '@angular/core';
import { connectableObservableDescriptor } from 'rxjs/internal/observable/ConnectableObservable';
import { VadrDataService } from '../../../../services/vadr-data.service';

@Component({
  selector: 'app-vadr-answer-counts',
  templateUrl: './vadr-answer-counts.component.html',
  styleUrls: ['./vadr-answer-counts.component.scss']
})
export class VadrAnswerCountsComponent implements OnInit {

  sAxisTicks = [0, 5, 10, 15, 18];
  maxLevel = 0;
  answerCountsByLevel = [];
  answerDistribColorScheme = { domain: ['#28A745', '#DC3545', '#c3c3c3'] };

  constructor(public vadrDataSvc: VadrDataService) { }

  ngOnInit(): void {
    this.vadrDataSvc.getVADRDetail().subscribe((r: any) => {
      this.createAnswerCountsByLevel(r);
    });
  }

  createAnswerCountsByLevel(r: any) {
    let levelList = [];

    r.vadrSummary.forEach(element => {
      let level = levelList.find(x => x.name == element.level_Name);
      if (!level) {
        level = {
          name: element.level_Name, series: [
            { name: 'Yes', value: 0 },
            { name: 'No', value: 0 },
            { name: 'Unanswered', value: 0 },
          ]
        };
        levelList.push(level);
      }

      var p = level.series.find(x => x.name == element.answer_Full_Name);
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
