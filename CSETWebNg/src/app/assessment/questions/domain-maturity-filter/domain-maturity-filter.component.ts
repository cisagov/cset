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
import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { QuestionsService } from '../../../services/questions.service';
import { MaturityFilteringService } from '../../../services/filtering/maturity-filtering/maturity-filtering.service';
import { QuestionGrouping } from '../../../models/questions.model';
import { AcetFilteringService } from '../../../services/filtering/maturity-filtering/acet-filtering.service';


/**
 * A visible checkbox control that marks questions in the associated
 * domain as visible or not, depending on the maturity level of the
 * question vs the selected level of this control.
 */
@Component({
  selector: 'app-domain-maturity-filter',
  templateUrl: './domain-maturity-filter.component.html'
})
export class DomainMaturityFilterComponent implements OnInit {

  @Input()
  domain: QuestionGrouping;

  @Input()
  maturityLevels: any[];

  @Output()
  changed = new EventEmitter<string>();


  // the domain that we are filtering
  domainName: string;

  constructor(
    public questionsSvc: QuestionsService,
    public maturityFilteringSvc: MaturityFilteringService,
    public acetFilteringSvc: AcetFilteringService,
  ) { }

  /**
   * 
   */
  ngOnInit() {
    this.domainName = this.domain.Title;
  }


  /**
   * Returns the Value property for the domain and level
   */
  getNgModel(level: any) {
    return this.acetFilteringSvc.domainFilters?.find(d => d.DomainName == this.domainName)?.Settings.find(s => s.Level == level.Level).Value;
  }

  /**
   * 
   * @param level 
   * @param e event
   */
  filterChanged(level: number, e: boolean) {
    this.acetFilteringSvc.filterChanged(this.domainName, level, e);
    this.changed.emit('');
  }

  /**
   * 
   * @param level 
   */
  isFilterActive(level: any) {
    const filterForDomain = this.acetFilteringSvc.domainFilters.find(f => f.DomainName == this.domain.Title);
    if (!filterForDomain) {
      return false;
    }
    return filterForDomain.Settings.find(s => s.Level == level.Level).Value;
  }

}