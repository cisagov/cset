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
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { ReportService } from '../../../services/report.service';


@Component({
  selector: 'app-module-content',
  templateUrl: './module-content.component.html',
  styleUrls: ['./module-content.component.scss', '../../../reports/reports.scss']
})
export class ModuleContentComponent implements OnInit {

  setName: string;
  set: any;

  modelId: string;
  model: any;

  loading = true;

  /**
   * 
   */
  constructor(
    public reportSvc: ReportService,
    public route: ActivatedRoute
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.set = null;
    this.model = null;

    this.route.queryParams
      .subscribe(params => {
        this.setName = params.m;
        this.modelId = params.mm;

        if (!!this.setName) {
          this.reportSvc.getModuleContent(this.setName).subscribe(rpt => {
            this.loading = false;
            this.set = rpt;
          });
        }

        if (!!this.modelId) {
          this.reportSvc.getModelContent(this.modelId).subscribe(rpt => {
            this.loading = false;
            this.model = rpt;
          });
        }
      });
  }

  toggleShowGuidance(evt: any) {
    this.reportSvc.showGuidance = evt.target.checked;
  }

  toggleShowReferences(evt: any) {
    this.reportSvc.showReferences = evt.target.checked;
  }

  toggleShowQuestions(evt: any) {
    this.reportSvc.showQuestions = evt.target.checked;
  }
}
