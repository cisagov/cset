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
import { AssessmentService } from '../../../services/assessment.service';

import {CdkDragDrop, moveItemInArray} from '@angular/cdk/drag-drop';
import { CyoteService } from '../../../services/cyote.service';

@Component({
  selector: 'app-cyote-questions',
  templateUrl: './cyote-questions.component.html',
  styleUrls: ['./cyote-questions.component.scss']
})
export class CyoteQuestionsComponent implements OnInit {

  loading = true;
  questions = [];
  page = '';

  // categories = [{
  //   code: 'ics',
  //   label: 'ICS (Physical Equipment)',
  //   icon: 'whatshot'
  // },
  // {
  //   code: 'digital',
  //   label: 'Digital (ICS Process)',
  //   icon: 'memory'
  // },
  // {
  //   code: 'network',
  //   label: 'Network',
  //   icon: 'wifi'
  // }];
  categories = {
    undefined:  {
      label: undefined,
      icon: 'quiz'
    },
    ics:  {
      label: 'ICS (Physical Equipment)',
      icon: 'whatshot'
    },
    digital:  {
      label: 'Digital (ICS Process)',
      icon: 'memory'
    },
    network:  {
      label: 'Network',
      icon: 'wifi'
    },
  };

  step = -1;

  constructor(
    private route: ActivatedRoute,
    public assessSvc: AssessmentService,
    public cyoteSvc: CyoteService,
    ) { }

  ngOnInit(): void {

    this.loading = false;
    this.assessSvc.currentTab = 'questions';

    this.route.url.subscribe(segments => {
      this.page = segments[0].path;
      // Reset the current step index
      this.step = -1;
    });
  }

  drop(event: CdkDragDrop<any[]>) {
    let curStep = this.step > -1 && this.step < this.cyoteSvc.anomalies.length ? this.cyoteSvc.anomalies[this.step] : null;
    moveItemInArray(this.cyoteSvc.anomalies, event.previousIndex, event.currentIndex);
    // if(event.previousIndex == this.step) {
    //   this.step = event.currentIndex;
    // } else if(event.previousIndex < this.step && event.currentIndex >= this.step)
    this.step = curStep == null ? -1 : this.cyoteSvc.anomalies.indexOf(curStep);
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

  onAddAnomaly() {
    const copy = [...this.cyoteSvc.anomalies,
      {
        id: this.cyoteSvc.nextAnomalyId++,
        category: 'undefined',
        title: '',
        description: '',
         reporter: '',
        isFirstTimeAooHasSeenObservable: false,
        categories: {
          physical: false,
          digital: false,
          network: false,
        },
        questions: {
          affectingOperations: false,
          affectingProcesses: false,
          multipleDevices: false,
          multipleNetworkLayers: false,
          meetsCyberEventThreshold: false,
          additionalComments: '',
        },
      }];
    this.cyoteSvc.anomalies = copy;
    this.step = this.cyoteSvc.anomalies.length - 1;
  }

  onRemoveAnomaly(index: number): void {
    const copy = [...this.cyoteSvc.anomalies];
    copy.splice(index, 1);
    this.cyoteSvc.anomalies = copy;
    if(this.step == index)
      this.step = -1;
  }

  trackByItems(index: number, item: any): number { return item.id; }

}
