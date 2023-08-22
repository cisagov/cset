////////////////////////////////
//
//   Copyright 2023 Battelle Energy Alliance, LLC
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
import { CrrService } from './../../../services/crr.service';
import { CmuReportModel, CrrReportModel } from '../../../models/reports.model';
import { Title } from '@angular/platform-browser';
import { ConfigService } from '../../../services/config.service';
import { CmuService } from '../../../services/cmu.service';

@Component({
  selector: 'app-imr-report',
  templateUrl: './imr-report.component.html',
  styleUrls: ['./imr-report.component.scss']
})
export class ImrReportComponent implements OnInit {

  model: CmuReportModel;
  securityLevel: string = '';

  constructor(
    private cmuSvc: CmuService,
    private titleSvc: Title,
    public configSvc: ConfigService) { }

  ngOnInit(): void {

    const securityLevel = localStorage.getItem('crrReportConfidentiality');
    if (securityLevel) {
      securityLevel !== 'None' ? this.securityLevel = securityLevel : this.securityLevel = '';
      localStorage.removeItem('crrReportConfidentiality');
    }

    this.titleSvc.setTitle('IMR Report - ' + this.configSvc.behaviors.defaultTitle);
    this.cmuSvc.getModel().subscribe((data: CmuReportModel) => {

      data.structure.Model.Domain.forEach(d => {
        d.Goal.forEach(g => {
          // The Question object needs to be an array for the template to work.
          // A singular question will be an object.  Create an array and push the question into it
          if (!Array.isArray(g.Question)) {
            var onlyChild = Object.assign({}, g.Question);
            g.Question = [];
            g.Question.push(onlyChild);
          }
        });
      });

      this.model = data
      console.log(this.model);
    },
      error => console.log('Error loading IMR report: ' + (<Error>error).message)
    );
  }

  printReport() {
    window.print();
  }
}
