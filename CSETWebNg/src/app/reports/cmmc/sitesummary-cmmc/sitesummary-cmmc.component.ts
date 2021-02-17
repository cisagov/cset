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
import { Component, OnInit, AfterViewChecked, AfterViewInit, ElementRef, ViewChild, HostListener } from '@angular/core';
import { ReportAnalysisService } from '../../../services/report-analysis.service';
import { ReportService } from '../../../services/report.service';
import { ConfigService } from '../../../services/config.service';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { CmmcStyleService } from '../../../services/cmmc-style.service';
import * as $ from 'jquery';
import { BehaviorSubject } from 'rxjs';
import { MAT_RIPPLE_GLOBAL_OPTIONS } from '@angular/material/core';
import { first } from 'rxjs/operators';
@Component({
  selector: 'sitesummary',
  templateUrl: './sitesummary-cmmc.component.html',
  styleUrls: ['../../reports.scss'],
  // providers: [CmmcStyleService]
})
export class SitesummaryCMMCComponent implements OnInit, AfterViewChecked, AfterViewInit {

  response: any;
  pageInitialized = false;

  columnWidthPx: number;
  gridColumnCount = 10
  gridColumns = new Array(this.gridColumnCount);
  columnWidthEmitter: BehaviorSubject<number>;
  @ViewChild("gridChartDataDiv") gridChartData: ElementRef;
  @ViewChild("gridTiles") gridChartTiles: Array<any>;


  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    private titleService: Title,
    public cmmcStyleSvc: CmmcStyleService
  ) {
    this.columnWidthEmitter = new BehaviorSubject<number>(25)
  }

  ngOnInit() {
    this.cmmcStyleSvc.getData();
    this.titleService.setTitle("Site Summary - CSET");

    this.reportSvc.getReport('executivecmmc').subscribe(
      (r: any) => {
        this.response = r;
      },
      error => console.log('Executive report load Error: ' + (<Error>error).message)
    );
    this.columnWidthEmitter.subscribe(item => {
      $(".gridCell").css("width", `${item}px`)
    });
  }

  ngAfterViewInit() {
    this.getcolumnWidth();
  }

  ngAfterViewChecked() {
    this.getcolumnWidth();
  }
  //horizontalDomainBarChat
  getcolumnWidth() {
    this.columnWidthPx = this.gridChartData.nativeElement.clientWidth / this.gridColumns.length;
    this.columnWidthEmitter.next(this.columnWidthPx)
  }
  getBarWidth(data) {
    return {
      'flex-grow': data.questionAnswered / data.questionCount,
      'background': this.cmmcStyleSvc.getGradient("blue")
    }
  }

  @HostListener('window:resize', ['$event'])
  onResize(event) {
    this.getcolumnWidth();
  }
}
