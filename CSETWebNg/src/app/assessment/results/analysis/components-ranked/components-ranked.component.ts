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
import Chart from 'chart.js/auto';

@Component({
  selector: 'app-components-ranked',
  templateUrl: './components-ranked.component.html'
})
export class ComponentsRankedComponent implements OnInit {
  canvasComponentRank: Chart;
  dataRows: { title: string; rank: number; failed: number; total: number; percent: number; }[];
  initialized = false;
  componentCount: any; 

  constructor(
    private analysisSvc: AnalysisService,
    private assessSvc: AssessmentService,
    public navSvc: NavigationService,
    private router: Router
  ) { }

  ngOnInit() {
    this.analysisSvc.getComponentsRankedCategories().subscribe(x => {
      this.analysisSvc.buildComponentsRankedCategories('canvasComponentRank', x);

      this.dataRows = x.dataRows;
      this.dataRows.map(r => {
        r.percent = parseFloat((r.percent * 100).toFixed());
        r.rank = parseFloat(r.rank.toFixed());
      });

      this.initialized = true;
      this.componentCount = x.data.length
    });
  }
}
