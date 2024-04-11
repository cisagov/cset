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
import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { QuestionsService } from '../../../services/questions.service';
import { MaturityFilteringService } from '../../../services/filtering/maturity-filtering/maturity-filtering.service';
import { QuestionGrouping } from '../../../models/questions.model';
import { AcetFilteringService } from '../../../services/filtering/maturity-filtering/acet-filtering.service';
import { NCUAService } from '../../../services/ncua.service';
import { AssessmentService } from '../../../services/assessment.service';
import { ACETService } from '../../../services/acet.service';
import { TranslocoService } from '@ngneat/transloco';


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
    public assessSvc: AssessmentService,
    public ncuaSvc: NCUAService,
    public acetSvc: ACETService,
    private tSvc: TranslocoService
  ) { }

  /**
   * 
   */
  ngOnInit() {
    this.domainName = this.domain.title;
    if (this.assessSvc.isISE()) {
      this.determineIseFilter();
    }
  }


  /**
   * Returns the Value property for the domain and level
   */
  getNgModel(level: any) {
    var tmp = this.acetFilteringSvc.domainFilters?.find(d => d.domainName == this.domainName)?.tiers.find(t => t.financial_Level_Id == level.level);
    return tmp?.isOn ?? false;
  }

  /**
   * 
   * @param level 
   * @param e event
   */
  filterChanged(level: number) {
    this.acetFilteringSvc.filterChanged(this.domainName, level);
    this.changed.emit('');
  }

  /**
   * 
   * @param level 
   */
  isFilterActive(level: any) {
    const filterForDomain = this.acetFilteringSvc.domainFilters.find(f => f.domainName == this.domain.title)?.tiers.find(t => t.financial_Level_Id == level.level);
    if (!filterForDomain) {
      return false;
    }
    return filterForDomain.isOn;
  }

  determineIseFilter() {
    if (this.ncuaSvc.proposedExamLevel === 'SCUEP' ||
      this.ncuaSvc.chosenOverrideLevel === "No Override" ||
      this.ncuaSvc.chosenOverrideLevel === 'SCUEP') {
      this.maturityLevels = [{ "level": "1", "label": "SCUEP", "applicable": true }];
    } else {
      this.maturityLevels = [{ "level": "2", "label": "CORE", "applicable": true }];
    }
  }

  checkFilterKeydown(level: any, event: any) {
    if (event) {
      if (event.key == "Enter") {
        this.filterChanged(level);
      }
    }
  }


}