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
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { ConfigService } from '../../services/config.service';
import { Title, DomSanitizer } from '@angular/platform-browser';
import { MaturityService } from '../../services/maturity.service';

@Component({
  selector: 'app-cis-commentsmarked',
  templateUrl: './cis-commentsmarked.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss']
})
export class CisCommentsmarkedComponent implements OnInit {
  response: any = null;
  loading: boolean = false;

  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    private titleService: Title,
    public maturitySvc: MaturityService,
    private sanitizer: DomSanitizer
  ) { }

  ngOnInit(): void {
    this.loading = true;
    this.titleService.setTitle("Comments Report - CISA CIS");

    this.maturitySvc.getCommentsMarked().subscribe(
      (r: any) => {
        this.response = r;
        this.loading = false;
      },
      error => console.log('Comments Marked Report Error: ' + (<Error>error).message)
    );
  }
}
