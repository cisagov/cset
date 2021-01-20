////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
import { Component, OnInit, Output, EventEmitter, Input } from '@angular/core';
import { QuestionsService } from '../../../services/questions.service';
import { AcetFiltersService } from '../../../services/acet-filters.service';
import { QuestionsAcetService } from '../../../services/questions-acet.service';
import { QuestionGrouping } from '../../../models/questions.model';

/**
 * A visible checkbox control that marks questions in the associated
 * domain as visible or not, depending on the maturity level of the
 * question vs the selected level of this control.
 */
@Component({
  selector: 'app-maturity-filter',
  templateUrl: './maturity-filter.component.html'
})
export class MaturityFilterComponent implements OnInit {

  @Input()
  levels: any[];

  @Input()
  domain: QuestionGrouping;
  
  @Output()
  filtersChanged = new EventEmitter<Map<string, boolean>>();
  
  // the domain that we are filtering
  domainName: string;

  constructor(
    public questionsSvc: QuestionsService,
    public acetQuestionSvc: QuestionsAcetService,
    private filterSvc: AcetFiltersService
  ) { }

  /**
   * 
   */
  ngOnInit() {
    this.domainName = this.domain.Title;

    ////// TEMP CODE -- playing with filter selection
    this.levels.forEach(l => {
      l.Applicable = true;
    });
  }

  /**
   * Indicates whether the specified maturity level
   * corresponds to the overall IRP risk level.
   * @param mat
   */
  isDefaultMatLevel(mat: string) {
    return (this.acetQuestionSvc.isDefaultMatLevel(mat));
  }

  /**
   * Sets the new value in the service's filter map and tells the host page
   * to refresh the question list.
   * @param f
   * @param e
   */
  filterChanged(f: string, e) {
    // set my filter settings in questions service
    this.acetQuestionSvc.domainMatFilters.get(this.domainName).set(f, e);
    this.filterSvc.saveFilter(this.domainName,f,e).subscribe();
    // tell my host page
    this.filtersChanged.emit(this.acetQuestionSvc.domainMatFilters.get(this.domainName));
  }
}