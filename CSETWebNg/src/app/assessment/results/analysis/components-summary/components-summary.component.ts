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
import { Router } from '../../../../../../node_modules/@angular/router';
import { AnalysisService } from '../../../../services/analysis.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { NavigationService } from '../../../../services/navigation/navigation.service';

@Component({
  selector: 'app-components-summary',
  templateUrl: './components-summary.component.html'
})
export class ComponentsSummaryComponent implements OnInit {

  dataRows: { title: string; number: number; total: number; percent: number; }[];
  initialized = false;
  canvasComponentSummary: any;
  componentCount: any; 

  constructor(
    private analysisSvc: AnalysisService,
    private assessSvc: AssessmentService,
    public navSvc: NavigationService,
    private router: Router
  ) { }

  ngOnInit() {
    this.analysisSvc.getComponentsSummary().subscribe(x => {
      if (this.canvasComponentSummary) {
        this.canvasComponentSummary.destroy();
      }
      this.canvasComponentSummary = this.analysisSvc.buildComponentsSummary('canvasComponentSummary', x);
      this.dataRows = x.dataRowsPie;
      this.initialized = true;
      this.componentCount = x.componentCount
    });
    
  }
}
