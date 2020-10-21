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
import { Component, OnInit, AfterViewChecked, AfterViewInit, ElementRef, ViewChild, HostListener } from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { ConfigService } from '../../services/config.service';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import * as $ from 'jquery';
import {BehaviorSubject} from 'rxjs';
import { MAT_RIPPLE_GLOBAL_OPTIONS } from '@angular/material/core';
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

  blueText= "rgba(41,100,162,1)"
  greenText= "rgba(60,110,85,1)"
  whiteText= "rgba(255,255,255,1)"

  statsByDomain;
  gridColumnCount = 10
  gridColumns = new Array(this.gridColumnCount);
  @ViewChild("gridChartDataDiv") gridChartData: ElementRef;
  @ViewChild("gridTiles") gridChartTiles: Array<any>;
  
  columnWidthEmitter: BehaviorSubject<number>;
  columnWidthPx = 25;

  ngstyleCalls = 0;


  stackBarChartData;
  divElement: HTMLElement;

  response: any;
  pageInitialized = false;


  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    private titleService: Title,
    private sanitizer: DomSanitizer
  ) { 
    this.columnWidthEmitter = new BehaviorSubject<number>(25)

  }

  getGradient(color,alpha=1){
    console.log(color)
    switch(color){
      case "blue":{
        console.log("BLEUFJ")
        return `linear-gradient(5deg, rgba(31,82,132,${alpha}) 0%, rgba(58,128,194,${alpha}) 100%)`
      }
      case "green":{
        return `linear-gradient(5deg, rgba(98,154,109,${alpha}) 0%, rgba(31,77,67,${alpha}) 100%)`
      }
      case "grey":{
        return `linear-gradient(5deg, rgba(98,98,98,${alpha}) 0%, rgba(120,120,120,${alpha}) 100%)`
      }
      case "orange":{
        return `linear-gradient(5deg, rgba(200,98,98,${alpha}) 0%, rgba(220,120,120,${alpha}) 100%)`
      }
      default: {
        return "rgba(255,0,0,1)"
      }
    }
  }

  getRadi(i){
    let degreeOfNo = Math.round(i.questionUnAnswered / i.questionCount * 360)
    let val = {
      backgroundImage: `conic-gradient(${this.pieColorYes} ${degreeOfNo}deg, rgba(0,0,0,0) 0 1deg)`
    }
    return val
  }
  getBorder(input){
    return `solid ${input} black`
  }

  getBarSettings(input){
    let width = Math.round(input.questionAnswered / input.questionCount * 100)
    let color = "linear-gradient(5deg, rgba(100,100,100,1) 0%, rgba(200,200,200,1) 100%)"
    if(input.ModelLevel < this.cmmcModel.TargetLevel){
      color = this.getGradient("blue");
    }else if(input.ModelLevel == this.cmmcModel.TargetLevel){
      color = this.getGradient("green");
    } else {
      color = this.getGradient("grey");
    }
    let val = {
      width: `${width}%`,
      background: color
    }
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
              this.statsByLevel = this.cmmcModel.StatsByLevel.filter(obj => obj.ModelLevel != "Aggregate").reverse()
              this.statsByDomain = this.cmmcModel.StatsByDomain
              this.stackBarChartData = this.generateStackedBarChartData(this.statsByLevel)
            }            
          });    
          console.log(this.cmmcModel)
          console.log(this.statsByLevel)
          window.dispatchEvent(new Event('resize'));
        }
      },
      error => console.log('Site Summary report load Error: ' + (<Error>error).message)
    ),(finish) => {

    };
    this.columnWidthEmitter.subscribe(item => {
      $(".gridCell").css("width",`${item}px`)
    })
  }

  generateStackedBarChartData(data){
    let sortedData = data.sort((a,b) => (a.ModelLevel > b.ModelLevel) ? 1: -1)
    let outputData = []
    let stackedChartData = []
    console.log(sortedData)
    console.log(outputData)
    for(let i = 0; i <sortedData.length; i++){
      
      let dataEle = []
      if(i == 0){
        // dataEle.push(data[i])
      } else {
        console.log(outputData)
        outputData[i-1].forEach(outputEle => {
          dataEle.push(outputEle)
        });
      }      
      //dataEle.push(data[i])
      this.getStackBarChartData(sortedData[i]).forEach(element => {
        dataEle.unshift(element)
      });
      outputData.push(dataEle)      
    console.log(outputData  )
    }
    console.log(stackedChartData)
    console.log(outputData)
    return outputData
  }


  getStackBarChartData(data){
    return [
      {
        count: data.questionAnswered,
        totalForLevel: data.questionCount,
        type: "Yes",
        modelLevel: data.ModelLevel,
      },{
        count: data.questionUnAnswered,
        totalForLevel: data.questionCount,
        type: "No",
        modelLevel: data.ModelLevel,

      }
    ]
  }

  
  getStackedChartSectionStyle(data){
    let retVal = []

    if(data.type == "Yes"){ 
      let alpha = 1.2 - (.2 * data.modelLevel)  
      retVal["backgroundColor"] = this.getGradient("blue",alpha)
    }
    else {
      retVal["backgroundColor"] = this.getGradient("orange")
    }
    if(data.count > (data.totalForLevel / 2)) {
      retVal["innerHtml"] = `${data.count} / ${data.totalForLevel}`
    }
    if(data.count == 0){
      retVal["display"] = "none";
    } else {
      let percent = (data.count / data.totalForLevel) * 100
      retVal["flex-basis"] = `calc(${percent}% + var(--corner-size))`
    }
    console.log(data)
    console.log(retVal)

    return retVal

  }

  ngAfterViewInit(){
    this.getcolumnWidth();
  }

  ngAfterViewChecked() {
    this.getcolumnWidth();
    // if (this.pageInitialized) {
    //   return;
    // }
  }

  getBlueGradientWithAlpha(alpha){
    
  }

  //horizontalDomainBarChat
  getcolumnWidth(){    
    this.columnWidthPx = this.gridChartData.nativeElement.clientWidth / this.gridColumns.length;
    this.columnWidthEmitter.next(this.columnWidthPx)
  }
  getBarWidth(data){
    return { 
      'flex-grow': data.questionAnswered / data.questionCount,
      'background': this.getGradient("blue")
    }
  }

  @HostListener ('window:resize',['$event'])
  onResize(event) {
    this.getcolumnWidth();
  }


  //Pyramid Chart
  getPyramidRowColor(level){
    let backgroundColor = this.getGradient("blue",.1);
    let textColor = this.blueText
    if(this.cmmcModel?.TargetLevel){
      if(level == this.cmmcModel?.TargetLevel){
        backgroundColor = this.getGradient("green")
        textColor = this.whiteText
      }
      else if(level < this.cmmcModel?.TargetLevel){
        backgroundColor = this.getGradient("blue")
        textColor = this.whiteText
      }
    }
    return {
      background: backgroundColor,
      color: textColor
    }
  }
  

}
