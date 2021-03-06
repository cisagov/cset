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
import { Component, OnInit, Input } from '@angular/core';
import { EDMBarChartModel } from '../edm-bar-chart.model';
import { MaturityService } from '../../../services/maturity.service';


@Component({
  selector: 'edm-framework-summary',
  templateUrl: './edm-framework-summ.component.html',
  styleUrls: ['../../reports.scss']
})
export class EDMFrameworkSummary implements OnInit {

  @Input() framework_data: any;
  edm_framework_data: any[];
  func_count_totals: EDMBarChartModel = new EDMBarChartModel();

  constructor(
    private maturitySvc: MaturityService,
    ) { 
    
  }

  ngOnInit(): void {
    this.maturitySvc.getMatDetailEDMAppendixList().subscribe(
      (success) => {
        this.func_count_totals = this.getTotals(success)
        this.edm_framework_data = success as [];
      },
      (failure) => {
        console.log(failure)
      }
    )
  }

  getTotals(input){
    let retval = new EDMBarChartModel()
    retval.title = 'NIST CSF Summary'
    retval.green = 0;
    retval.yellow = 0;
    retval.red = 0;
    input.forEach(func => {     
      retval.green += func['totals']['Y']
      retval.yellow += func['totals']['I']
      retval.red += func['totals']['N']
    });
    return retval;
  }

  getTripleChartData(func){
    let retVal = new EDMBarChartModel()
    retVal.title = `${func['FunctionName']} (${func['Acronym']})`
    retVal.green = func['totals']['Y']
    retVal.yellow = func['totals']['I']
    retVal.red = func['totals']['N']
    return retVal
  }
  getHorizontalChartData(cat){
    let retVal = new EDMBarChartModel()
    retVal.green = cat['totals']['Y']
    retVal.yellow = cat['totals']['I']
    retVal.red = cat['totals']['N']
    return retVal
  }
  
  getFramgeworkColor(input){
    let color = "rgb(0,0,0)"
    switch(input){
      case 'ID': {
        color = "rgb(75,103,176)";
        break;
      }
      case 'PR': {
        color = "rgb(125,37,125)";
        break;
      }
      case 'DE': {
        color = "rgb(225,203,0)";
        break;
      }
      case 'RS': {
        color = "rgb(237,34,36)";
        break;
      }
      case 'RC': {
        color = "rgb(73,128,59)";
        break;
      }
    }
    let retVal = {
      'background-color': `${color}`
    }
    return retVal;
  }


}
