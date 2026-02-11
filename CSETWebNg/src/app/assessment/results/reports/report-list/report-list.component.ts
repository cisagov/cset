////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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
import { Component, Input, OnInit } from '@angular/core';
import { ReportService } from '../../../../services/report.service';
import { TranslocoService } from '@jsverse/transloco';
import { AssessmentService } from '../../../../services/assessment.service';
import { ObservationsService } from '../../../../services/observations.service';
import { MaturityService } from '../../../../services/maturity.service';

/**
 * This component displays a list of report launching links.  
 * The links defined for each assessment type is defined in report-list.json
 * Two types of links are supported.  Most launch an HTML report in a new tab, 
 * defined with a 'linkUrl' property.
 * The other will launch an exported Excel spreadsheet, defined with an 'exportUrl' 
 * property.
 */
@Component({
    selector: 'app-report-list',
    templateUrl: './report-list.component.html',
    styleUrls: ['./report-list.component.scss'],
    standalone: false
})
export class ReportListComponent implements OnInit {


  @Input()
  confidentiality: any;

  @Input()
  sectionId?: string;

  sectionTitle?: string;

  @Input()
  list?: any[];


  /**
   * 
   */
  constructor(
    public reportSvc: ReportService,
    public tSvc: TranslocoService,
    public assessSvc: AssessmentService,
    public maturitySvc: MaturityService,
    public observationsSvc: ObservationsService
  ) { }

  ngOnInit(): void {
    if (!this.sectionId) {
      return;
    }

    const key = 'reports.launch.' + this.sectionId.toLowerCase() + '.sectionTitle';
    this.sectionTitle = this.tSvc.translate(key);
  }

  /**
   * 
   */
  onSelectSecurity(val: string) {
    this.confidentiality = val;
    this.reportSvc.confidentiality = val;
  }

  /**
   * Returns the translation, or an empty string
   */
  translateDesc(section: string, index: number): string {
    const key = 'reports.launch.' + section.toLowerCase() + '.' + (index + 1) + '.desc';
    const val = this.tSvc.translate(key);
    return val === key ? '' : val;
  }

  /**
   * Evaluates certain conditions to indicate if a report link
   * should be disabled.
   */
  isDisabled(condition: string) {
    return false;
  }
}
