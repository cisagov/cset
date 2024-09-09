////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
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
import { Component, Input, OnChanges, OnInit } from '@angular/core';
import { QuestionsService } from '../../services/questions.service';
import { Utilities } from '../../services/utilities.service';
import { TranslocoService } from '@ngneat/transloco';

@Component({
  selector: 'app-component-question-list',
  templateUrl: './component-question-list.component.html',
  styleUrls: ['../reports.scss']
})
export class ComponentQuestionListComponent implements OnInit, OnChanges {

  @Input()
  data: any[];

  /**
   * 
   */
  constructor(
    public questionsSvc: QuestionsService,
    public utilitiesSvc: Utilities,
    public tSvc: TranslocoService
  ) { }

  /**
   * 
   */
  ngOnInit(): void { }

  /**
   * 
   */
  ngOnChanges(): void {
    this.data.forEach(x => {
      x.componentName = this.utilitiesSvc.removeHtmlTags(x.componentName, true);
    });
  }
}
