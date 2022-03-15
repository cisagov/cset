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

import { CdkDragDrop, moveItemInArray } from '@angular/cdk/drag-drop';
import { CyoteService } from '../../../services/cyote.service';
import { CyoteObservable } from '../../../models/cyote.model';

@Component({
  selector: 'app-cyote-questions',
  templateUrl: './cyote-questions.component.html',
  styleUrls: ['./cyote-questions.component.scss']
})
export class CyoteQuestionsComponent implements OnInit {

  loading = true;
  questions = [];
  page = '';


  categories = {
    undefined: {
      label: undefined,
      icon: 'quiz'
    },
    ics: {
      label: 'ICS (Physical Equipment)',
      icon: 'whatshot'
    },
    digital: {
      label: 'Digital (ICS Process)',
      icon: 'memory'
    },
    network: {
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


    // get the cyote content for the assessment
    this.cyoteSvc.getCyoteDetail().subscribe((detail: any) => {
      this.cyoteSvc.anomalies = detail.observables;

      console.log('just loaded model');
      console.log(this.cyoteSvc.anomalies);
    });


    this.route.url.subscribe(segments => {
      this.page = segments[0].path;

      // Reset the current step index
      this.step = -1;
    });
  }
}
