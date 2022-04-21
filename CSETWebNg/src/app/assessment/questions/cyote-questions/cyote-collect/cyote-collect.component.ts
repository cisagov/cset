////////////////////////////////
//
//   Copyright 2022 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute, ParamMap } from '@angular/router';
import { AssessmentService } from '../../../../services/assessment.service';
import { CdkDragDrop, moveItemInArray } from '@angular/cdk/drag-drop';
import { CyoteService } from '../../../../services/cyote.service';
import { CyoteObservable } from '../../../../models/cyote.model';


@Component({
  selector: 'app-cyote-collect',
  templateUrl: './cyote-collect.component.html',
  styleUrls: ['../cyote-questions.component.scss']
})
export class CyoteCollectComponent implements OnInit {

  loading = false;

  step = -1;

  constructor(
    private route: ActivatedRoute,
    public assessSvc: AssessmentService,
    public cyoteSvc: CyoteService,
  ) { }

  ngOnInit(): void {
    if (this.cyoteSvc.anomalies == null) {
      this.cyoteSvc.anomalies = [];
    }
  }

  changeObservation(o) {
    this.cyoteSvc.saveObservable(o).subscribe();
  }

  drop(event: CdkDragDrop<any[]>) {
    let curStep = this.step > -1 && this.step < this.cyoteSvc.anomalies.length ? this.cyoteSvc.anomalies[this.step] : null;
    moveItemInArray(this.cyoteSvc.anomalies, event.previousIndex, event.currentIndex);
    this.step = curStep == null ? -1 : this.cyoteSvc.anomalies.indexOf(curStep);

     // save new sequence
     for (let i = 0; i < this.cyoteSvc.anomalies.length; i++) {
      this.cyoteSvc.anomalies[i].sequence = i + 1;
    };
    this.cyoteSvc.saveObservableSequence(this.cyoteSvc.anomalies).subscribe();
  }

  
  setStep(index: number) {
    this.step = index;
  }

  nextStep() {
    this.step++;
  }

  prevStep() {
    this.step--;
  }

  trackByItems(index: number, item: any): number { return item.id; }

  onAddAnomaly() {
    console.log('onAddAnomaly');

    let newO: CyoteObservable = {
      assessmentId: this.assessSvc.assessment.id,
      sequence: this.cyoteSvc.anomalies.length + 1,
      observableId: 0,
      deepDiveQuestions: this.cyoteSvc.defaultQuestions
    };

    this.cyoteSvc.anomalies.push(newO);

    this.cyoteSvc.saveObservable(newO).subscribe(resp => {
      console.log(resp);
      newO.observableId = +resp;
      this.step = this.cyoteSvc.anomalies.length - 1;
    });
  }

  onRemoveAnomaly(index: number): void {
    const copy = [...this.cyoteSvc.anomalies];
    copy.splice(index, 1);
    this.cyoteSvc.anomalies = copy;
    if (this.step == index)
      this.step = -1;
  }

  DeleteObservation(anomaly:any, index: number){
    for(var i=0; i<this.cyoteSvc.anomalies.length; i++) {    
      if(this.cyoteSvc.anomalies[i].observableId == anomaly.observableId){
        this.onRemoveAnomaly(i);
        console.log("index="+i);
      }
    }
    console.log(anomaly);
    this.cyoteSvc.deleteObservable(anomaly);

  }
}
