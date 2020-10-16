////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
import { Component, OnInit, AfterViewChecked, AfterViewInit, ElementRef, ViewChild } from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { ConfigService } from '../../services/config.service';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
@Component({
  selector: 'sitesummary',
  templateUrl: './sitesummary-cmmc.component.html',
  styleUrls: ['../reports.scss']
})
export class SitesummaryCMMCComponent implements OnInit, AfterViewChecked, AfterViewInit {
  
  pieChartVals = "";
  pieColorYes = "#ffc107"
  pieColorNo = "#f2b844"

  cmmcModel;
  statsByLevel;
 
  levelDescriptions = {
    1: "Safeguard Federal Contract Information (FCI)",
    2: "Serves as transition step in cybersecurity maturity progression to protect CUI",
    3: "Protect Controlled Unclassified Information (CUI)",
    4: "Protect CUI and reduce risk of Advanced Persistent Threats (APTs)",
    5: "Protect CUI and reduce risk of Advanced Persistent Threats (APTs)",
  }

  blueGradient = "linear-gradient(5deg, rgba(31,82,132,1) 0%, rgba(58,128,194,1) 100%)"
  greenGradient = "linear-gradient(5deg, rgba(98,154,109,1) 0%, rgba(31,77,67,1) 100%)"
  grayGradient = "linear-gradient(5deg, rgba(98,98,98,1) 0%, rgba(120,120,120,1) 100%)"

  ngstyleCalls = 0;

  divElement: HTMLElement;

  response: any;
  pageInitialized = false;


  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    private titleService: Title,
    private sanitizer: DomSanitizer
  ) { }

  getRadi(i){
    let degreeOfNo = Math.round(i.questionUnAnswered / i.questionCount * 360)

    let val = {
      backgroundImage: `conic-gradient(${this.pieColorYes} ${degreeOfNo}deg, rgba(0,0,0,0) 0 1deg)`
    }
    this.ngstyleCalls += 1;
    console.log(this.ngstyleCalls)
    return val
  }
  getBorder(input){
    return `solid ${input} black`
  }

  getBarSettings(input){
    let width = Math.round(input.questionAnswered / input.questionCount * 100)
    let color = "linear-gradient(5deg, rgba(100,100,100,1) 0%, rgba(200,200,200,1) 100%)"
    if(input.ModelLevel < this.cmmcModel.TargetLevel){
      color = this.blueGradient;
    }else if(input.ModelLevel == this.cmmcModel.TargetLevel){
      color = this.greenGradient;
    } else {
      color = this.grayGradient;
    }
    let val = {
      width: `${width}%`,
      background: color
    }
    console.log(val)
    return val
  }

  isWithinModelLevel(level){
    if(level.ModelLevel == "CMMC"){ return false;}
    let val = Number(level.ModelLevel)
    if(!isNaN(val)){
      if(val <= this.cmmcModel.TargetLevel){
        return true;
      }
    }
    return false;
  }

  ngOnInit() {
    this.titleService.setTitle("Site Summary Report - CSET");

    this.reportSvc.getReport('sitesummarycmmc').subscribe(
      (r: any) => {
        this.response = r;
        if(r.MaturityModels){
          r.MaturityModels.forEach(model => {
            if(model.MaturityModelName == "CMMC"){
              this.cmmcModel = model
              this.statsByLevel = this.cmmcModel.StatsByLevel.filter(obj => obj.ModelLevel != "Aggregate")
            }
          });    
          console.log(this.cmmcModel)
          console.log(this.statsByLevel)
        }
        // console.log(this.statsByLevel)
        // this.statsByLevel
        // console.log(r)

        // let testYes = 75
        // let testNo = 25
        // let totalQues = testYes + testNo 
        // let degreeOfNo = Math.round(testNo / totalQues * 360)

        // this.divElement = this.PieChartByLevel3.nativeElement;
        // let pieVal = `conic-gradient(${this.pieColorYes} ${degreeOfNo}deg, rgba(0,0,0,0) 0 1deg)`
        // this.divElement.style.backgroundImage= pieVal
      },
      error => console.log('Site Summary report load Error: ' + (<Error>error).message)
    );
  }

  ngAfterViewInit(){
    // console.log(this.pieChartDiv)    
  }

  ngAfterViewChecked() {
    // if (this.pageInitialized) {
    //   return;
    // }
  }

}
