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
import { CmuService } from './../../../services/cmu.service';
import { CmuReportModel } from '../../../models/reports.model';
import { Title } from '@angular/platform-browser';
import { ConfigService } from '../../../services/config.service';
import { ReportService } from '../../../services/report.service';
import { ActivatedRoute, Route, Router } from '@angular/router';

@Component({
  selector: 'app-crr-report',
  templateUrl: './crr-report.component.html',
  styleUrls: ['./crr-report.component.scss']
})
export class CrrReportComponent implements OnInit {
  cmuModel: CmuReportModel;
  confidentiality: string = '';

  constructor(
    private cmuSvc: CmuService,
    private titleSvc: Title,
    public configSvc: ConfigService,
    public reportSvc: ReportService,
    public route: ActivatedRoute
  ) { }

  ngOnInit(): void {
    const conf = localStorage.getItem('report-confidentiality');
    localStorage.removeItem('report-confidentiality');

    if (conf) {
      conf !== 'None' ? (this.confidentiality = conf) : (this.confidentiality = '');
    }

    this.titleSvc.setTitle('CRR Report - ' + this.configSvc.behaviors.defaultTitle);
    this.cmuSvc.getCmuModel().subscribe(
      (data: CmuReportModel) => {
        data.structure.Model.Domain.forEach((d) => {
          d.Goal.forEach((g) => {
            // The Question object needs to be an array for the template to work.
            // A singular question will be an object.  Create an array and push the question into it
            if (!Array.isArray(g.Question)) {
              const onlyChild = Object.assign({}, g.Question);
              g.Question = [];
              g.Question.push(onlyChild);
            }
          });
        });

        this.cmuModel = data;
      },
      (error) => console.error('Error loading CRR report: ' + (<Error>error).message)
    );
  }

  printReport() {
    window.print();
  }
}
