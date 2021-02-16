////////////////////////////////
//
//   Copyright 2021 Battelle Energy Alliance, LLC
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
import { Component, OnInit, AfterViewChecked, AfterViewInit } from '@angular/core';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { ReportService } from '../../services/report.service';
import { ACETService } from '../../services/acet.service';
import { ConfigService } from '../../services/config.service';


@Component({
  selector: 'app-acet-answeredquestions',
  templateUrl: './acet-answeredquestions.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss']
})
export class AcetAnsweredQuestionsComponent implements OnInit {
  response: any = {};

  constructor(
    public reportSvc: ReportService,
    private titleService: Title,
    public acetSvc: ACETService,
    public configSvc: ConfigService,

  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Answered Statements Report - ACET");

    this.acetSvc.getAnsweredQuestions().subscribe(
      (r: any) => {
        this.response = r;
        console.log(this.response);
      },
      error => console.log('Assessment Information Error: ' + (<Error>error).message)
    );
  }
}