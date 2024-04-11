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
import { Component, OnInit, Input, ElementRef, AfterViewInit, ViewChildren, QueryList } from '@angular/core';
import { ReportService } from '../../services/report.service';
import { HttpClient } from '@angular/common/http';


@Component({
  selector: 'app-pdf-reports',
  templateUrl: './pdf-reports.component.html',
  styleUrls: ['./pdf-reports.component.scss']
})

export class PdfReportsComponent implements OnInit, AfterViewInit {
  // Input Data
  @Input() assessmentInfo;
  @Input() donutData;
  @Input() tableData;
  @ViewChildren('overallMilPieChart') overallPieChartsFromTemplate: QueryList<ElementRef>;
  @ViewChildren('individualMilPieChart') breakdownPieChartsFromTemplate: QueryList<ElementRef>;

  pdfDocument: any = null;
  loading = true;
  disabled = false;

  // Intro + Section 1
  coverImage: any = null;
  reportGeneratedDate: Date;

  // Section 3
  milAchievementData: any[] = [];
  managementActivitiesData = [];
  tableTwoStructure = [];
  figureTwoColorScheme = { domain: ['#0A5278'] };
  figureTwoData: any[] = [];
  figureTwoChart: any = null;

  overallMilPieCharts = [];
  overallMilData = [];
  overallMilHTML = [];
  overallMilQuestionCounts = [];
  overallMilChartHTML = [];


  // Section 4
  objectiveTitles = [];
  objectiveData = [];

  breakdownMilPieCharts = []; //pieCharts = [];
  breakdownMilData = []; //donutChartData = [];
  breakdownMilQuestionCounts = []; //totalQuestionsCount
  breakdownMilChartHTML = []; //donutChartHTML = [];
  runningCount = 0;

  donutColorScheme = { domain: ['#265B94', '#90A5C7', '#F5DA8C', '#DCA237', '#E6E6E6'] };

  heatMaps = [];
  convertedHeatMaps = [];

  // Section 6
  commentMap = new Map();
  commentData: {
    id: string,
    mil: string,
    practiceText: string,
    response: string,
    comment: string
  }[] = [];

  // Section 7 
  partiallyCompleteData: {
    mil: string,
    response: string,
    id: string,
    practiceText: string,
    comment: string,
  }[] = [];

  orderedByMil = [];
  orderedByDomain = [];
  sectionSevenBody = [];


  // Pdf Style Variables
  normalSpacing = 12;
  smallSpacing = 6;
  largeSpacing = 24;
  extraLargeSpacing = 36;


  constructor(
    public reportSvc: ReportService,
    private http: HttpClient,
  ) { }


  ngOnInit(): void {
    this.reportGeneratedDate = new Date();
    this.getCoverSheetBase64('assets/images/C2M2/C2M2-Report-Cover-Sheet.png');
    this.getFigureTwoData();
    this.getMilAchievementChartData();
    this.getManagementActivitiesData();
    this.getMilChartsData();
    this.parseTableData();
  }

  ngAfterViewInit() {
    this.overallMilPieCharts = this.overallPieChartsFromTemplate.toArray();
    this.breakdownMilPieCharts = this.breakdownPieChartsFromTemplate.toArray();

    for (let i = 0; i < this.overallMilPieCharts.length; i++) {
      this.drawOnPieChart(i, 'overall');
    }

    for (let i = 0; i < this.breakdownMilPieCharts.length; i++) {
      this.drawOnPieChart(i, 'breakdown');
    }

  }

  // This places the answer counts inside the pie chart itself
  private drawOnPieChart(num: number, category: string) {
    // get the ngx chart element
    let svg;
    let node;
    if (category == 'overall') {
      node = this.overallMilPieCharts[num].chartElement.nativeElement;
      this.overallMilPieCharts[num].margins = [10, 10, 10, 10];
    } else {
      node = this.breakdownMilPieCharts[num].chartElement.nativeElement;
      this.breakdownMilPieCharts[num].margins = [10, 10, 10, 10];
    }

    for (let i = 0; i < 5; i++) {
      if (i === 3) {
        // this is the pie chart svg
        svg = node.childNodes[0];
      }
      // at the end of this loop, the node should contain all slices in its children node
      node = node.childNodes[0];
    }
    // get all the slices
    const slices: HTMLCollection = node.children;
    let minX = 0;
    let maxX = 0;

    for (let i = 0; i < slices.length; i++) {
      const bbox = (<any>slices.item(i)).getBBox();
      minX = Math.round((bbox.x < minX ? bbox.x : minX) * 10) / 10;
      maxX = Math.round((bbox.x + bbox.width > maxX ? bbox.x + bbox.width : maxX) * 10) / 10;
    }

    let data = null;
    if (category == 'overall') {
      data = this.overallMilData[num];
    } else {
      data = this.breakdownMilData[num];
    }

    for (let i = 0; i < slices.length; i++) {
      const value = data[i].value;
      let color = 'black';
      // sets white text only for the FI slice
      if (data[i].name == "Fully Implemented") {
        color = 'white';
      }

      let startingValue = 0;
      for (let j = 0; j < i; j++) {
        if (category == 'overall') {
          startingValue += (data[j].value / this.overallMilQuestionCounts[num] * 100);
        } else {
          startingValue += (data[j].value / this.breakdownMilQuestionCounts[num] * 100);
        }
      }
      const text = this.generateText(value, maxX - minX, startingValue, color, num, category);

      svg.append(text);
    }
  }

  private generateText(value: number, diagonal: number, startingValue: number, color: string, num: number, category: string) {
    // create text element
    const text = document.createElementNS('http://www.w3.org/2000/svg', 'text');

    let r;
    if (category == 'overall') {
      r = Math.round(diagonal / 2.0);
    } else {
      r = Math.round(diagonal / 2.3);
    }

    // angle = summed angle of previous slices + half of current slice - 90 degrees (starting at the top of the circle)
    let angle = null;
    if (category == 'overall') {
      angle = ((startingValue * 2 + (value / this.overallMilQuestionCounts[num] * 100)) / 100 - 0.5) * Math.PI;
    } else {
      angle = ((startingValue * 2 + (value / this.breakdownMilQuestionCounts[num] * 100)) / 100 - 0.5) * Math.PI;
    }

    const x = r * Math.cos(angle);
    const y = r * Math.sin(angle) + 5;

    text.setAttribute('x', '' + x);
    text.setAttribute('y', '' + y);
    text.setAttribute('fill', color);
    text.textContent = value != 0 ? value.toString() : '';
    if (category == 'overall') {
      text.setAttribute('style', 'font-size: 10px')
    } else {
      text.setAttribute('style', 'font-size: 12px')
    }
    text.setAttribute('text-anchor', 'middle');
    text.setAttribute('pointer-events', 'none');
    return text;
  }


  getCoverSheetBase64(path: string) {
    this.http.get(path, { responseType: 'blob' })
      .subscribe(blob => {
        const reader = new FileReader();
        const binaryString = reader.readAsDataURL(blob);
        reader.onload = (event: any) => {
          this.coverImage = "<img width='700' src='" + event.target.result + "'>";
        }
        reader.onerror = (event: any) => {
          console.log("File could not be read: " + event.target.error.code);
        };
      });
  }


  xAxisTickFormatting(label) {
    return `MIL${label}`
  }


  getFigureTwoData() {
    this.donutData.forEach(domain => {
      this.figureTwoData.push(
        {
          name: domain.shortTitle,
          value: domain.milAchieved
        }
      );
    });
  }


  getMilAchievementChartData() {
    this.donutData.forEach(domain => {
      this.milAchievementData.push({ name: domain.shortTitle, value: domain.milAchieved });
    });
  }


  getManagementActivitiesData() {
    for (let i = 0; i < this.tableData.managementQuestions.length; i++) {
      for (let j = 0; j < this.tableData.managementQuestions[i].domainAnswers.length; j++) {
        if (this.tableData.managementQuestions[i].domainAnswers[j].answer == null) {
          this.tableData.managementQuestions[i].domainAnswers[j].answer = "U";
        }
        this.managementActivitiesData.push(this.tableData.managementQuestions[i].domainAnswers[j].answer);
      }
    }

    this.buildManagementTable();
  }


  getMilChartsData() {
    for (let i = 0; i < this.donutData.length; i++) {

      // Get overall MIL data
      for (let j = 0; j < this.donutData[i].domainMilRollup.length; j++) {
        let overallMil = this.donutData[i].domainMilRollup[j];

        this.overallMilData.push(
          [
            { name: "Fully Implemented", value: overallMil.fi },
            { name: "Largely Implemented", value: overallMil.li },
            { name: "Partially Implemented", value: overallMil.pi },
            { name: "Not Implemented", value: overallMil.ni },
            { name: "Unanswered", value: overallMil.u },
          ]);

        let total = (overallMil.fi + overallMil.li + overallMil.pi + overallMil.ni + overallMil.u);
        this.overallMilQuestionCounts.push(total);
      }

      // Also get the individual MIL breakdown
      for (let j = 0; j < this.donutData[i].objectives.length; j++) {
        let objective = this.donutData[i].objectives[j];

        this.breakdownMilData.push(
          [
            { name: "Fully Implemented", value: objective.fi },
            { name: "Largely Implemented", value: objective.li },
            { name: "Partially Implemented", value: objective.pi },
            { name: "Not Implemented", value: objective.ni },
            { name: "Unanswered", value: objective.u },
          ]);

        let total = (objective.fi + objective.li + objective.pi + objective.ni + objective.u);
        this.breakdownMilQuestionCounts.push(total);
      }
    }
  }


  buildManagementTable() {
    for (let k = 0; k < this.managementActivitiesData.length; k++) {
      let fillColor = 'white';
      let textColor = 'black';

      fillColor = this.getFillColor(this.managementActivitiesData[k]);

      if (this.managementActivitiesData[k].answerText === 'FI') {
        textColor = 'white';
      }

      this.tableTwoStructure.push({ text: this.managementActivitiesData[k], alignment: 'center', marginTop: 15, fillColor: fillColor, color: textColor });
    }
  }


  parseTableData() {
    for (let i = 0; i < this.tableData.domainList.length; i++) {
      for (let j = 0; j < this.tableData.domainList[i].objectives.length; j++) {
        this.objectiveTitles.push(this.tableData.domainList[i].objectives[j].title);

        for (let k = 0; k < this.tableData.domainList[i].objectives[j].practices.length; k++) {
          let data = this.tableData.domainList[i].objectives[j].practices[k];
          let formattedResponse = this.formatResponse(data.answerText); // "Fully Implemented (FI)" instead of just "FI"

          // Objective Data for section 4
          this.objectiveData.push(data);

          // Comments for section 6
          if (data.comment !== null && data.comment !== '') {

            this.commentData.push({
              "id": data.title,
              "mil": data.mil,
              "practiceText": data.questionText,
              "response": formattedResponse,
              "comment": data.comment
            });
          }

          // Partially Completed data for section 7
          if (data.answerText != 'FI' && data.answerText != 'LI') {
            this.partiallyCompleteData.push({
              "id": data.title,
              "mil": data.mil,
              "practiceText": data.questionText,
              "response": formattedResponse,
              "comment": data.comment
            });
          }
        }
      }
    }

    this.orderByMil();
  }


  orderByMil() {
    this.orderedByMil = [];
    let milOnes = [];
    let milTwos = [];
    let milThrees = [];

    for (let i = 0; i < this.partiallyCompleteData.length; i++) {

      if (this.partiallyCompleteData[i].mil == "1" || this.partiallyCompleteData[i].mil == "MIL-1") {
        milOnes.push(this.partiallyCompleteData[i]);

      }
      if (this.partiallyCompleteData[i].mil == "2" || this.partiallyCompleteData[i].mil == "MIL-2") {
        milTwos.push(this.partiallyCompleteData[i]);

      }
      if (this.partiallyCompleteData[i].mil == "3" || this.partiallyCompleteData[i].mil == "MIL-3") {
        milThrees.push(this.partiallyCompleteData[i]);
      }
    }

    for (let i = 0; i < milOnes.length; i++) {
      this.orderedByMil.push(milOnes[i]);
    }

    for (let i = 0; i < milTwos.length; i++) {
      this.orderedByMil.push(milTwos[i]);
    }

    for (let i = 0; i < milThrees.length; i++) {
      this.orderedByMil.push(milThrees[i]);
    }

    this.orderByDomain();
  }


  orderByDomain() {
    this.orderedByDomain = [];

    for (let i = 0; i < this.milAchievementData.length; i++) { // Run through each of the domains names "ASSET", "ACCESS", etc
      for (let j = 0; j < this.orderedByMil.length; j++) {
        let id = (this.orderedByMil[j].id.split('-')[0] !== "THIRD" ? this.orderedByMil[j].id.split('-')[0] : "THIRD-PARTIES");
        if (id == this.milAchievementData[i].name) {
          this.orderedByDomain.push(this.orderedByMil[j]);
        }
      }
    }

    this.loading = false;
  }

  buildGiantDonutChart() {
    let htmlToPdfmake = require('html-to-pdfmake');

    let milOneHtmlMakeObjects = [];
    let milTwoHtmlMakeObjects = [];
    let milThreeHtmlMakeObjects = [];

    let milOneInnerNumArray = [];
    let milTwoInnerNumArray = [];
    let milThreeInnerNumArray = [];

    let milOneDonutRow = [];
    let milTwoDonutRow = [];
    let milThreeDonutRow = [];

    let num = 0;

    // Get all the numbers inside each donut circle
    for (let i = 0; i < this.overallMilChartHTML.length; i++) {
      if (num === 0) {
        milOneHtmlMakeObjects.push(htmlToPdfmake(this.overallMilChartHTML[i]));
        milOneInnerNumArray.push('<svg width="30" height="30" viewBox="0 0 30 30" overflow="visible"><text x="0" y="0" style="font-size: 10px;">' + this.overallMilQuestionCounts[i] + '</text></svg>');
      } else if (num === 1) {
        milTwoHtmlMakeObjects.push(htmlToPdfmake(this.overallMilChartHTML[i]));
        milTwoInnerNumArray.push('<svg width="30" height="30" viewBox="0 0 30 30" overflow="visible"><text x="0" y="0" style="font-size: 10px;">' + this.overallMilQuestionCounts[i] + '</text></svg>');
      } else if (num === 2) {
        milThreeHtmlMakeObjects.push(htmlToPdfmake(this.overallMilChartHTML[i]));
        milThreeInnerNumArray.push('<svg width="30" height="30" viewBox="0 0 30 30" overflow="visible"><text x="0" y="0" style="font-size: 10px;">' + this.overallMilQuestionCounts[i] + '</text></svg>');
      }

      if (num === 2) {
        num = 0;
      } else {
        num++;
      }
    }

    // Grab the raw svg of each ngx chart so we can move it around the page, broken up into the 3 MIL categories
    let milOneInnerNumbers = [];
    let milTwoInnerNumbers = [];
    let milThreeInnerNumbers = [];

    let milOneInnerNumMargins = [[32, -78, 0, 0], [36, -78, 0, 0], [36, -78, 0, 0], [36, -78, 0, 0], [36, -78, 0, 0], [36, -78, 0, 0], [36, -78, 0, 0], [41, -78, 0, 0], [36, -78, 0, 0], [42, -78, 0, 0]];
    let milTwoInnerNumMargins = [[30, -151, 0, 0], [33, -151, 0, 0], [34, -151, 0, 0], [34, -151, 0, 0], [34, -151, 0, 0], [34, -151, 0, 0], [34, -151, 0, 0], [38, -151, 0, 0], [33, -151, 0, 0], [39, -151, 0, 0]];
    let milThreeInnerNumMargins = [[30, -224, 0, 0], [34, -224, 0, 0], [34, -224, 0, 0], [34, -224, 0, 0], [34, -224, 0, 0], [34, -224, 0, 0], [34, -224, 0, 0], [38, -224, 0, 0], [33, -224, 0, 0], [39, -224, 0, 0]];

    for (let i = 0; i < milOneHtmlMakeObjects.length; i++) {
      let donutSvg = milOneHtmlMakeObjects[i][0].stack[0].stack[0].stack[0].svg;
      let donutMargins = [-7, 0, 0, 0];

      if (i === 0) {
        milOneDonutRow.push({ text: 'MIL1', alignment: 'center', margin: [0, 28, 0, 0] });
        milOneInnerNumbers.push('');
      }

      milOneDonutRow.push({ svg: donutSvg, margin: donutMargins });
      milOneInnerNumbers.push({ svg: milOneInnerNumArray[i], margin: milOneInnerNumMargins[i] });
    }

    for (let i = 0; i < milTwoHtmlMakeObjects.length; i++) {
      let donutSvg = milTwoHtmlMakeObjects[i][0].stack[0].stack[0].stack[0].svg;
      let donutMargins = [-7, 0, 0, 0];

      if (i === 0) {
        milTwoDonutRow.push({ text: 'MIL2', alignment: 'center', margin: [0, 28, 0, 0] });
        milTwoInnerNumbers.push('');
      }

      milTwoDonutRow.push({ svg: donutSvg, margin: donutMargins });
      milTwoInnerNumbers.push({ svg: milTwoInnerNumArray[i], margin: milTwoInnerNumMargins[i] });
    }

    for (let i = 0; i < milThreeHtmlMakeObjects.length; i++) {
      let donutSvg = milThreeHtmlMakeObjects[i][0].stack[0].stack[0].stack[0].svg;
      let donutMargins = [-7, 0, 0, 0];

      if (i === 0) {
        milThreeDonutRow.push({ text: 'MIL3', alignment: 'center', margin: [0, 28, 0, 0] });
        milThreeInnerNumbers.push('');
      }

      milThreeDonutRow.push({ svg: donutSvg, margin: donutMargins });
      milThreeInnerNumbers.push({ svg: milThreeInnerNumArray[i], margin: milThreeInnerNumMargins[i] });
    }

    // Build the table header, and the bottom "mil achieved" row
    let tableHeaderRow = [];
    let milAchievedRow = [];
    let achievedMargin = [0, 4, 0, 0];
    tableHeaderRow.push({ text: '', border: [false, false, false, false] }, { text: 'ASSET', fontSize: 10, alignment: 'center' }, { text: 'THREAT', fontSize: 10, alignment: 'center' }, { text: 'RISK', fontSize: 10, alignment: 'center' }, { text: 'ACCESS', fontSize: 10, alignment: 'center' }, { text: 'SITUATION', fontSize: 10, alignment: 'center' }, { text: 'RESPONSE', fontSize: 10, alignment: 'center' }, { text: 'THIRD-PARTIES', fontSize: 10, alignment: 'center' }, { text: 'WORKFORCE', fontSize: 10, alignment: 'center' }, { text: 'ARCHITECTURE', fontSize: 10, alignment: 'center' }, { text: 'PROGRAM', fontSize: 10, alignment: 'center' });
    milAchievedRow.push({ text: 'MIL ACHIEVED', fontSize: 10, alignment: 'center' }, { text: 10, alignment: 'center', margin: achievedMargin }, { text: 10, alignment: 'center', margin: achievedMargin }, { text: 10, alignment: 'center', margin: achievedMargin }, { text: 10, alignment: 'center', margin: achievedMargin }, { text: 10, alignment: 'center', margin: achievedMargin }, { text: 10, alignment: 'center', margin: achievedMargin }, { text: 10, alignment: 'center', margin: achievedMargin }, { text: 10, alignment: 'center', margin: achievedMargin }, { text: 10, alignment: 'center', margin: achievedMargin }, { text: 10, alignment: 'center', margin: achievedMargin });

    // Table contents
    let donutSection = {
      table: {
        widths: [48, 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto'],
        body: [tableHeaderRow, milThreeDonutRow, milTwoDonutRow, milOneDonutRow, milAchievedRow],
      },
      layout: {
        hLineColor: function (i, node) {
          return 'gray';
        },
        vLineColor: function (i, node) {
          return 'gray';
        },
      },
    }

    let innerNumbers = {
      table: {
        widths: [48, 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto'],
        body: [milThreeInnerNumbers, milTwoInnerNumbers, milOneInnerNumbers],
      },
      layout: 'noBorders'
    }

    // A seperate table for the table key
    let tableLegend = {
      layout: 'noBorders',
      table: {
        widths: [38, 10, 122, 10, 136, 10, 142, 10, 118, 10, 139],
        body: [
          [{ text: '' }, { text: '', fillColor: '#265B94' }, 'Fully Implemented (FI)', { text: '', fillColor: '#90A5C7' }, 'Largely Implemented (LI)', { text: '', fillColor: '#F5DABC' }, 'Partially Implemented (PI)', { text: '', fillColor: '#DCA237' }, 'Not Implemented (NI)', { text: '', fillColor: '#E6E6E6' }, 'Unanswered (U)'],
        ],
      },
    }

    // This pdfmake table object is modified to fit into the column pdfmake object. Don't "fix" it.
    let table = {
      body: [
        [donutSection],
        [innerNumbers],
        [{ text: '', marginBottom: 15 }],
        [tableLegend],
      ],
    }

    return table;
  }


  buildHeatMaps(domain: string, mil: number) {
    let chartData = [];
    let widthArray = [];
    let boxHeight = 25;

    let body = [];
    let table = {};

    let fontColor = 'black';

    for (let i = 0; i < this.objectiveData.length; i++) {
      if (this.objectiveData[i].title.split('-')[0] == domain) {
        if (this.objectiveData[i].mil.split('-')[1] == mil || this.objectiveData[i].mil == mil) {
          chartData.push(this.objectiveData[i]);
        }
      }
    }

    for (var i = 0; i < chartData.length; i++) {
      if (domain == "ARCHITECTURE") { // Domain is the only one too long at width 20.
        widthArray.push(16);
      } else {
        widthArray.push(20);
      }
    }


    for (let i = 0; i < chartData.length; i++) {
      if (chartData[i].answerText == "FI") {
        fontColor = 'white';
      } else {
        fontColor = 'black';
      }


      if (domain == "ARCHITECTURE") {
        body.push({ text: chartData[i].title.split('-')[1], fontSize: 10, alignment: 'center', marginTop: 6, fillColor: this.getHeatMapColor(chartData[i].answerText), color: fontColor });
      } else if (domain == "THIRD") {
        body.push({ text: chartData[i].title.split('-')[2], fontSize: 12, alignment: 'center', marginTop: 5, fillColor: this.getHeatMapColor(chartData[i].answerText), color: fontColor });
      } else {
        body.push({ text: chartData[i].title.split('-')[1], fontSize: 12, alignment: 'center', marginTop: 5, fillColor: this.getHeatMapColor(chartData[i].answerText), color: fontColor });
      }
    }

    table = {
      table: {
        widths: widthArray,
        heights: boxHeight,
        body: [
          body
        ],
      },
      marginBottom: 6
    }

    return table;
  }


  buildObjectivesTable(domain: string, objective: number) {
    let body = [];
    let id = domain + "-" + objective;
    let fillColor = 'white';
    let textColor = 'black';

    for (let i = 0; i < this.objectiveData.length; i++) {
      if (this.objectiveData[i].answerText == null || this.objectiveData[i].answerText == undefined) {
        this.objectiveData[i].answerText = 'U';
      }

      if (this.objectiveData[i].mil.split('-')[1] === undefined) {
        this.objectiveData[i].mil = "MIL-" + this.objectiveData[i].mil;
      }

      fillColor = this.getFillColor(this.objectiveData[i].answerText);

      if (this.objectiveData[i].answerText === 'FI') {
        textColor = 'white';
      } else {
        textColor = 'black';
      }

      if (this.objectiveData[i].title.includes(id)) {
        // On first pass through, create the table headers
        if (body.length === 0) {
          body.push([{ text: 'MIL', alignment: 'center', marginTop: 12 }, { text: 'ID', alignment: 'center', marginTop: 12 }, { text: 'Practice Statement', alignment: 'center', marginTop: 12 }, { text: 'Response', alignment: 'center', marginTop: 12 }]);
        }

        body.push([{ text: this.objectiveData[i].mil, alignment: 'center', marginTop: 12 }, { text: this.objectiveData[i].title, alignment: 'center', marginTop: 12, noWrap: true }, { text: this.objectiveData[i].questionText }, { text: this.objectiveData[i].answerText, alignment: 'center', marginTop: 12, fillColor: fillColor, color: textColor }]);
      }
    }

    // Build & return the Pdfmake JSON structure
    let table = {
      table: {
        headerRows: 0,
        widths: ['auto', 'auto', 'auto', 'auto'],
        heights: 40,
        body,
        dontBreakRows: true,
      },
      layout: {
        fillColor: function (rowIndex, node) {
          return (rowIndex === 0) ? '#f0f0f0' : null;
        },
        marginBottom: this.normalSpacing,
      },
    }

    return table;
  }


  buildCommentsTable(domain: string) {
    let body = [];
    let rowHeights = []
    let commentCount = 0;
    let fillColor = 'white';
    let textColor = 'black';
    let myComments = [];

    // On first pass through, create the table headers
    if (body.length === 0) {
      body.push([{ text: 'ID', alignment: 'center', marginTop: 2 }, { text: 'MIL', alignment: 'center', marginTop: 2 }, { text: 'Practice', alignment: 'center', marginTop: 2 }, { text: 'Response', alignment: 'center', marginTop: 2 }, { text: 'Self-Evaluation Notes', alignment: 'center', marginTop: 2, noWrap: true }]);
    }

    // Then, check if we have comments
    for (let i = 0; i < this.commentData.length; i++) {
      let id = this.commentData[i].id.split('-')[0];

      if (domain === id) {
        commentCount++;
        myComments.push(this.commentData[i]);
      }
    }

    if (commentCount > 0) {
      for (let i = 0; i < commentCount; i++) {
        fillColor = this.getFillColor(this.commentData[i].response);

        if (this.commentData[i].response == "Fully Implemented (FI)") {
          textColor = 'white';
        } else {
          textColor = 'black';
        }

        body.push([{ text: myComments[i].id, alignment: 'center' }, { text: myComments[i].mil, alignment: 'center' }, { text: myComments[i].practiceText, }, { text: myComments[i].response, alignment: 'center', fillColor: fillColor, color: textColor }, { text: myComments[i].comment }])
      }
    } else {
      rowHeights = [20, 60];
      body.push([{ colSpan: 5, text: 'Notes were not enetered for the ' + domain + ' domain. Added notes will appear in this table.', alignment: 'center', marginTop: 20 }])
    }

    // Build & return the Pdfmake JSON structure
    let table = {
      table: {
        headerRows: 0,
        widths: ['auto', 'auto', 'auto', 'auto', '*'],
        heights: rowHeights,
        body,
        dontBreakRows: true,
      },
      layout: {
        fillColor: function (rowIndex, node) {
          return (rowIndex === 0) ? '#f0f0f0' : null;
        },
      },
      marginBottom: this.largeSpacing,
    }
    return table;
  }


  buildImplementedTable(domain: string, mil: string, runCount: number) {
    let rowHeights = [];
    let partialCount = 0;
    let data = [];
    let dataCounts = [];

    if (runCount == 0) {
      this.sectionSevenBody = [];
    }

    // Track how many partially implemented items we have in our request domain + mil level.
    for (let i = 0; i < this.orderedByDomain.length; i++) {
      let id = (this.orderedByDomain[i].id.split('-')[0] != "THIRD" ? this.orderedByDomain[i].id.split('-')[0] : "THIRD-PARTIES");

      if (id == domain && (this.orderedByDomain[i].mil == mil || "MIL-" + this.orderedByDomain[i].mil == mil)) {
        partialCount++;
        data.push(this.orderedByDomain[i]);
      }
    }

    // Check how long our rowspans should be (combine duplicate responses into 1 large row)
    let arrPI = [];
    let arrNI = [];
    let arrU = [];
    let piCount = 0;
    let niCount = 0;
    let uCount = 0;

    for (let i = 0; i < data.length; i++) {
      if (data[i].response == "Partially Implemented (PI)") {
        arrPI.push(data[i]);
        piCount++;
      }

      if (data[i].response == "Not Implemented (NI)") {
        arrNI.push(data[i]);
        niCount++;
      }

      if (data[i].response == "Unanswered (U)") {
        arrU.push(data[i]);
        uCount++;
      }
    }

    data = [...arrPI, ...arrNI, ...arrU];


    // On first pass through, create the table headers
    if (this.sectionSevenBody.length === 0 && runCount == 0) {
      this.sectionSevenBody.push([{ text: 'MIL', alignment: 'center', marginTop: 2 }, { text: 'Response', alignment: 'center', marginTop: 2 }, { text: 'ID', alignment: 'center', marginTop: 2 }, { text: 'Practice', alignment: 'center', marginTop: 2 }, { text: 'Self-Evaluation Notes', alignment: 'center', marginTop: 2, noWrap: true }]);
    }

    // Now, if we have any PI/NI/U statements, add them to the table body
    if (partialCount > 0) {
      let span = 1;

      for (let i = 0; i < data.length; i++) {
        if (data[i].response == "Partially Implemented (PI)") {
          span = piCount;
        } else if (data[i].response == "Not Implemented (NI)") {
          span = niCount;
        } else if (data[i].response == "Unanswered (U)") {
          span = uCount;
        }

        this.sectionSevenBody.push([
          { text: (data[i].mil.split('-')[1] != undefined ? data[i].mil.split('-')[1] : data[i].mil), rowSpan: data.length, alignment: 'center' },
          { text: data[i].response, rowSpan: span, alignment: 'center', fillColor: this.getFillColor(data[i].response) },
          { text: data[i].id, alignment: 'center' }, { text: data[i].practiceText }, { text: data[i].comment }
        ]);

      }
    }
    // If we don't have any PI/NI/U statements, add the default
    else {
      rowHeights = [20, 60];

      if (runCount == 2 && this.sectionSevenBody.length == 1) {
        this.sectionSevenBody.push([{ colSpan: 5, text: 'All Practices Largely or Fully Implemented for the ' + domain + ' Domain.', alignment: 'center', marginTop: 20 }])
      }
    }

    // Build & return the Pdfmake JSON structure
    if (runCount == 2) {
      let table = {
        table: {
          headerRows: 0,
          widths: ['auto', 'auto', 'auto', 'auto', '*'],
          heights: rowHeights,
          body: this.sectionSevenBody,
          dontBreakRows: true,
        },
        layout: {
          fillColor: function (rowIndex, node) {
            return (rowIndex === 0) ? '#f0f0f0' : null;
          },
        },
        marginBottom: this.largeSpacing,
      }

      return table;
    }
  }


  buildDonutChart(num: number, objectives: any, position: number) {
    let htmlToPdfmake = require('html-to-pdfmake');
    let htmlMakeObjects = [];
    let donutChartArray = [];
    let innerNumValues = [];
    let innerNumArray = [];
    let donutNames = [];
    let tableWidth = [];

    let timesRun = 0;
    for (let i = this.runningCount; timesRun < num; i++) {
      htmlMakeObjects.push(htmlToPdfmake(this.breakdownMilChartHTML[i]));
      innerNumValues.push(this.breakdownMilQuestionCounts[i]);
      innerNumArray.push('<svg width="30" height="30" viewBox="0 0 30 30" overflow="visible"><text x="0" y="0" style="font-size: 12px;">' + this.breakdownMilQuestionCounts[i] + '</text></svg>');
      timesRun++;
    }

    // Grab the raw svg of each ngx chart so we can move it around the page
    for (let i = 0; i < htmlMakeObjects.length; i++) {
      let donutSvg = htmlMakeObjects[i][0].stack[0].stack[0].stack[0].svg;
      let donutMargins = [];
      let numberMargins = [];

      if (objectives.length == 6) {
        donutMargins = [11, 0, 0, 0];
        numberMargins = [-62, 54, 0, 0];
        if (innerNumValues[i] > 9) {
          numberMargins = [-65, 54, 0, 0];
        }
      } else if (objectives.length == 5) {
        donutMargins = [22, 0, 0, 0];
        numberMargins = [-76, 54, 0, 0];
        if (innerNumValues[i] > 9) {
          numberMargins = [-79, 54, 0, 0];
        }
      } else if (objectives.length == 4) {
        donutMargins = [40, 0, 0, 0];
        numberMargins = [-96, 54, 0, 0];
        if (innerNumValues[i] > 9) {
          numberMargins = [-99, 54, 0, 0];
        }
      } else if (objectives.length == 3) {
        donutMargins = [72, 0, 0, 0];
        numberMargins = [-127, 54, 0, 0];
        if (innerNumValues[i] > 9) {
          numberMargins = [-131, 54, 0, 0];
        }
      }

      donutChartArray.push({ svg: donutSvg, margin: donutMargins }, { svg: innerNumArray[i], margin: numberMargins });
    }

    for (let i = 0; i < num; i++) {
      donutNames.push({ text: objectives[i].title, alignment: 'center' }, { text: '' });
      tableWidth.push('*');
      tableWidth.push(0);
    }

    let tableLegend = {
      layout: 'noBorders',
      table: {
        widths: [15, 134, 10, 140, 10, 130],
        heights: 10,
        body: [
          [{ text: '', fillColor: '#265B94' }, 'Fully Implemented (FI)', { text: '', fillColor: '#F5DABC' }, 'Partially Implemented (PI)', { text: '', fillColor: '#E6E6E6' }, 'Unanswered (U)'],
          ['', '', '', '', '', ''],
          [{ text: '', fillColor: '#90A5C7' }, 'Largely Implemented (LI)', { text: '', fillColor: '#DCA237' }, 'Not Implemented (NI)', '', ''],
        ],
      },
    }

    let donutSection = {
      table: {
        widths: tableWidth,
        body: [
          donutChartArray,
          donutNames,
        ],
      },
      layout: 'noBorders',
    }

    let table = {
      layout: {
        hLineWidth: function (i, node) {
          return (i === 0 || i === node.table.body.length) ? 0.5 : 0;
        },
        vLineWidth: function (i, node) {
          return (i === 0 || i === node.table.widths.length) ? 0.5 : 0;
        },
      },
      table: {
        width: [15, 134, 10, 140, 10, 130],
        heights: 10,
        body: [
          [tableLegend],
          [{ text: '', marginBottom: 15 }],
          [donutSection],
        ],
      },
      marginBottom: 20,
    }

    this.runningCount += num;
    return table;
  }


  // Used by the comment table to change "FI" into Fully Implemented (FI)"
  formatResponse(text: string) {
    if (text === 'FI') {
      return 'Fully Implemented (FI)';
    } else if (text === 'LI') {
      return 'Largely Implemented (LI)';
    } else if (text === 'PI') {
      return 'Partially Implemented (PI)';
    } else if (text === 'NI') {
      return 'Not Implemented (NI)';
    } else {
      return 'Unanswered (U)';
    }
  }


  getFillColor(text: string) {
    let color = '';
    if (text === "FI" || text === "Fully Implemented (FI)") {
      color = '#005c99';
    } else if (text === "LI" || text === "Laregly Implemented (LI)") {
      color = '#8ba6ca';
    } else if (text === "PI" || text === "Partially Implemented (PI)") {
      color = '#fad980';
    } else if (text === "NI" || text === "Not Implemented (NI)") {
      color = '#e69f00';
    } else {
      color = '#E6E6E6';
    }

    return color;
  }


  getHeatMapColor(answer: string) {
    switch (answer) {
      case 'FI':
        return '#265B94';
      case 'LI':
        return '#90A5C7';
      case 'PI':
        return '#F5DA8C';
      case 'NI':
        return '#DCA237';
      case 'U':
      case null:
        return '#E6E6E6';
    }
  }

  getHeapMapTextColor(answer: string) {
    if (answer == "FI") {
      return 'white';
    } else {
      return 'black';
    }
  }


  startPdf(download) {
    this.disabled = true;
    setTimeout(() => {
      this.figureTwoChart = document.getElementById('figureTwo').innerHTML;

      if (this.overallMilChartHTML.length === 0) {
        for (let i = 0; i < this.overallMilData.length; i++) {
          this.overallMilChartHTML.push(document.getElementById('overallMilDonut' + i).innerHTML);
        }
      }

      if (this.breakdownMilChartHTML.length === 0) {
        for (let i = 0; i < this.breakdownMilData.length; i++) {
          this.breakdownMilChartHTML.push(document.getElementById('donutChart' + i).innerHTML);
        }
      } else {
        this.runningCount = 0;
      }

      this.generatePdf(download);
      this.disabled = false;
    }, 1500);
  }


  generatePdf(download) {
    let normalSpacing = 12;
    let smallSpacing = 6;
    let largeSpacing = 24;
    let extraLargeSpacing = 36;

    let pdfMake = require('pdfmake/build/pdfmake.js');
    let pdfFonts = require('pdfmake/build/vfs_fonts.js');
    let htmlToPdfmake = require('html-to-pdfmake');
    pdfMake.vfs = pdfFonts.pdfMake.vfs;

    // Section 3.2 Table Vertical Headers
    let assetSvg = { svg: '<svg height="120" width="200"><text x="-118" y="20" fill="black" transform="rotate(-90)">ASSET</text></svg>' };
    let threatSvg = { svg: '<svg height="120" width="200"><text x="-118" y="20" fill="black" transform="rotate(-90)">THREAT</text></svg>' };
    let riskSvg = { svg: '<svg height="120" width="200"><text x="-118" y="20" fill="black" transform="rotate(-90)">RISK</text></svg>' };
    let accessSvg = { svg: '<svg height="120" width="200"><text x="-118" y="20" fill="black" transform="rotate(-90)">ACCESS</text></svg>' };
    let situationSvg = { svg: '<svg height="120" width="200"><text x="-118" y="20" fill="black" transform="rotate(-90)">SITUATION</text></svg>' };
    let responseSvg = { svg: '<svg height="120" width="200"><text x="-118" y="20" fill="black" transform="rotate(-90)">RESPONSE</text></svg>' };
    let thirdpartySvg = { svg: '<svg height="120" width="200"><text x="-118" y="20" fill="black" transform="rotate(-90)">THIRD-PARTIES</text></svg>' };
    let workforceSvg = { svg: '<svg height="120" width="200"><text x="-118" y="20" fill="black" transform="rotate(-90)">WORKFORCE</text></svg>' };
    let architectureSvg = { svg: '<svg height="120" width="200"><text x="-118" y="20" fill="black" transform="rotate(-90)">ARCHITECTURE</text></svg>' };
    let programSvg = { svg: '<svg height="120" width="200"><text x="-118" y="20" fill="black" transform="rotate(-90)">PROGRAM</text></svg>' };


    this.pdfDocument = {
      info: {
        title: 'C2M2 Report',
      },
      content: [
        // Cover Image
        htmlToPdfmake(this.coverImage),
        { text: '', pageBreak: 'after' },

        // Notification Page
        { text: 'Notification', style: 'header', marginBottom: largeSpacing },
        { text: 'This report is provided “as is” for informational purposes only. The Department of Energy (DOE) does not provide any warranties of any kind regarding any information contained within. In no event shall the United States Government or its contractors or subcontractors be liable for any damages, including, but not limited to, direct, indirect, special, or consequential damages and including damages based on any negligence of the United States Government or its contractors or subcontractors, arising out of, resulting from, or in any way connected with this report, whether or not based upon warranty, contract, tort, or otherwise, whether or not injury was sustained from, or arose out of the results of, or reliance upon the report.', marginBottom: normalSpacing },
        { text: 'DOE does not endorse any commercial product or service, including the subject of the analysis in this report. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation, or favoring by the agencies.', marginBottom: normalSpacing },
        { text: 'The display of the DOE official seal or other visual identities on this report shall not be interpreted to provide the recipient organization authorization to use the official seal, insignia, or other visual identities of the Department. The DOE seal, insignia, or other visual identities shall not be used in any manner to imply endorsement of any commercial product or activity by DOE or the United States Government. Use of the DOE seal without proper authorization violates federal law (e.g., 18 U.S.C. §§ 506, 701, 1017), and is against DOE policies governing usage of its seal.', marginBottom: normalSpacing },
        { text: '', pageBreak: 'after' },

        // Section 1: Introduction
        { text: '1. Introduction', style: 'header', marginBottom: largeSpacing },
        { text: 'The Cybersecurity Capability Maturity Model (C2M2) can help organizations of all sectors, types, and sizes to evaluate and make improvements to their cybersecurity programs and strengthen their operational resilience. This report presents the results of a C2M2 self-evaluation. The results included in this report may be used to measure and improve an existing cybersecurity program. It also may serve as an input for other activities, such as informing cybersecurity risk managers about the controls in place to mitigate cybersecurity risks within an organization.', marginBottom: normalSpacing },
        { text: 'The results presented in this report are based on participant responses describing the degree to which C2M2 practices are implemented. This report may include sensitive information and should be protected accordingly.', marginBottom: extraLargeSpacing },
        { text: 'Assessment Information: ', marginBottom: largeSpacing },
        { text: 'ASSESSMENT NAME:' },
        { text: this.assessmentInfo?.assessment_Name, marginBottom: largeSpacing },
        { text: 'SELF-EVALUATION DATE:' },
        { text: this.assessmentInfo?.assessment_Date, marginBottom: largeSpacing },
        { text: 'ASSESSOR NAME:' },
        { text: this.assessmentInfo?.assessor_Name, marginBottom: largeSpacing },
        { text: 'This report was generated by CSET® on ' + this.reportGeneratedDate, italics: true },
        { text: '', pageBreak: 'after' },

        // Section 2: Model Architecture
        { text: '2. Model Architecture', style: 'header', marginBottom: largeSpacing },
        { text: 'The model is organized into 10 domains. Each domain is a logical grouping of cybersecurity practices. The practices within a domain are grouped by objective - target achievements that support the domain. Within each objective, the practices are ordered by maturity indicator levels (MILs).', marginBottom: normalSpacing },
        { text: 'The following section include additional information about the domains and the MILs.' },
        { text: '', pageBreak: 'after' },

        // Section 2.1: Domains, Objectives, and Practices
        { text: '2.1 Domains, Objectives, and Practices', style: 'header', marginBottom: largeSpacing },
        { text: 'The C2M2 includes 356 cybersecurity practices, which are grouped into 10 domains. These practices represent the activities an organization can perform to establish and mature capability in the domain. For example, the Asset, Change, and Configuration Management domain is a group of practices that an organization can perform to establish and mature asset management, change management, and configuration management capabilities.', marginBottom: normalSpacing },
        { text: 'The practices within each domain are organized into objectives, which represent achievements that support the domain. For example, the Asset, Change, and Configuration Management domain comprises five objectives:', marginBottom: normalSpacing },
        {
          text: '',
          ol: [
            'Manage IT and OT Asset Inventory',
            'Manage Information Asset Inventory',
            'Manage IT and OT Asset Configurations',
            'Manage Changes to IT and OT Assets',
            'Management Activities for the ASSET domain',
          ],
          marginBottom: normalSpacing
        },
        { text: 'Each of the objectives in a domain comprises a set of practices, which are ordered by MIL. Figure 1 summarizes the elements of each domain.', marginBottom: largeSpacing },
        { svg: '<svg width="535" viewBox="0 150 895 444"><title id="MIL_DefinitionTitle">Model Architecture</title><desc id="MIL_DefinitionDesc">Figure 1: Model and Domain Elements. A graphic representation of the Model, Domain and Objective hierarchy and associated Maturity Indicator Levels. Model contains 10 domains. Each domain contains Approach Objectives, one or more, unique to each domain. Approach Objectives are supported by a progression of practices that are unique to the domain. Each domain contains a Management Objective and this is similar in each domain. Each Management Objective is supported by a progression of practices that are similar in each domain and describe institutionalization activities.</desc><path fill="none" stroke="#737373" stroke-width="4" d="M366 440v99a16 16 0 0016 16h32 M366 440v32a16 16 0 0016 16h32 M190 105v300a16 16 0 0016 16h32 M366 172v166a16 16 0 0016 16h32 M366 172v99a16 16 0 0016 16h32 M366 172v32a16 16 0 0016 16h32 M190 105v32a16 16 0 0016 16h32 M64 38v32a16 16 0 0016 16h32"></path><g fill="#FFF" font-weight="bold" text-anchor="middle"><g transform="translate(64 25)"><rect x="-64" y="-25" width="128" height="38" fill="#292929" rx="4"></rect><text>Model</text></g><g transform="translate(190 92)"><rect x="-78" y="-25" width="156" height="38" fill="#4d4d4d" rx="4"></rect><text>Domain</text></g><g transform="translate(366 159)"><rect id="a" x="-128" y="-25" width="256" height="38" fill="#666666" rx="4"></rect><text>Approach Objectives</text></g><g transform="translate(522 226)"><rect id="b" x="-108" y="-25" width="216" height="38" fill="#8c8c8c" rx="4"></rect><text>Practices at MIL1</text></g><g transform="translate(522 293)"><use href="#b"></use><text>Practices at MIL2</text></g><g transform="translate(522 360)"><use href="#b"></use><text>Practices at MIL3</text></g><g transform="translate(366 427)"><use href="#a"></use><text>Management Objectives</text></g><g transform="translate(522 494)"><use href="#b"></use><text>Practices at MIL2</text></g><g transform="translate(522 561)"><use href="#b"></use><text>Practices at MIL3</text></g></g><g fill="currentColor"><text x="294" y="89">Model contains 10 domains</text><text transform="translate(518 149)">(one or more per domain)<tspan x="0" dy="19">Unique to each domain</tspan></text><text transform="translate(654 264)">Approach objectives are<tspan x="0" dy="19">supported by a progression of</tspan><tspan x="0" dy="19">practices that are unique to</tspan><tspan x="0" dy="19">the domain</tspan></text><text transform="translate(518 417)">(one per domain)<tspan x="0" dy="19">Similar in each domain</tspan></text><text transform="translate(654 489)">Each management objective<tspan x="0" dy="19">is supported by a progression</tspan><tspan x="0" dy="19">of practices that are similar in</tspan><tspan x="0" dy="19">each domain and describe</tspan><tspan x="0" dy="19">institutionalization activities</tspan></text></g></svg>' },
        { text: 'Figure 1: Model and Domain Elements', style: 'caption', marginTop: -85, pageBreak: 'after' },
        { text: 'For each domain, this report provides a purpose statement, which is a high-level summary of the intent of the domain. Further guidance for each of the domains, such as introductory discussions and example scenarios is provided in the C2M2 V2.1 model document.', marginBottom: normalSpacing },
        { text: 'The purpose statement for each of the 10 domains follows in the order in which the domains appear in the model and in this report. Next to each of the domain names, a short name is provided that is used throughout the model.', marginBottom: largeSpacing },

        { text: 'Domain: Asset, Change, and Configuration Management (ASSET)', style: 'subHeader', marginBottom: smallSpacing },
        { text: 'Manage the organization\'s IT and OT assets, including both hardware and software, and information assets commensurate with the risk to critical infrastructure and organizational objectives.', marginBottom: largeSpacing },
        { text: 'Domain: Threat and Vulnerability Management (THREAT)', style: 'subHeader', marginBottom: smallSpacing },
        { text: 'Establish and maintain plans, procedures, and technologies to detect, identify, analyze, manage, and respond to cybersecurity threats and vulnerabilities, commensurate with the risk to the organization\'s infrastructure (such as critical, IT, and operational) and organizational objectives.', marginBottom: largeSpacing },
        { text: 'Domain: Risk Management (RISK)', style: 'subHeader', marginBottom: smallSpacing },
        { text: 'Establish, operate, and maintain an enterprise cyber risk management program to identify, analyze, and respond to cyber risk the organization is subject to, including its business units, subsidiaries, related interconnected infrastructure, and stakeholders.', marginBottom: largeSpacing },
        { text: 'Domain: Identify and Access Management (ACCESS)', style: 'subHeader', marginBottom: smallSpacing },
        { text: 'Create and manage identities for entities that may be granted logical or physical access to the organization\'s assets. Control access to the organization\'s assets, commensurate with the risk to critical infrastructure and organizational objectives.', marginBottom: largeSpacing },
        { text: 'Domain: Situational Awareness (SITUATION)', style: 'subHeader', marginBottom: smallSpacing },
        { text: 'Establish and maintain activities and technologies to collect, monitor, analyze, alarm, report, and use operational, security, and threat information, including status and summary information from the other model domains, to establish situational awareness for both the organization\'s operational state and cybersecurity state.', marginBottom: largeSpacing },
        { text: 'Domain: Event and Incident Response, Continuity of Operations (RESPONSE)', style: 'subHeader', marginBottom: smallSpacing },
        { text: 'Establish and maintain plans, procedures, and technologies to detect, analyze, mitigate, respond to, and recover from cybersecurity events and incidents and to sustain operations during cybersecurity incidents, commensurate with the risk to critical infrastructure and organizational objectives.', marginBottom: largeSpacing },
        { text: 'Domain: Third-Party Risk Management (THIRD-PARTIES)', style: 'subHeader', marginBottom: smallSpacing },
        { text: 'Establish and maintain controls to manage the cyber risks arising from suppliers and other third parties, commensurate with the risk to critical infrastructure and organizational objectives.', marginBottom: largeSpacing },
        { text: 'Domain: Workforce Management (WORKFORCE)', style: 'subHeader', marginBottom: smallSpacing },
        { text: 'Establish and maintain plans, procedures, technologies, and controls to create a culture of cybersecurity and to ensure the ongoing suitability and competence of personnel, commensurate with the risk to critical infrastructure and organizational objectives.', marginBottom: largeSpacing },
        { text: 'Domain: Cybersecurity Architecture (ARCHITECTURE)', style: 'subHeader', marginBottom: smallSpacing },
        { text: 'Establish and maintain the structure and behavior of the organization\'s cybersecurity architecture, including controls, processes, technologies, and other elements, commensurate with the risk to critical infrastructure and organizational objectives.', marginBottom: largeSpacing },
        { text: 'Domain: Cybersecurity Program Management (PROGRAM)', style: 'subHeader', marginBottom: smallSpacing },
        { text: 'Establish and maintain an enterprise cybersecurity program that provides governance, strategic planning, and sponsorship for the organization\'s cybersecurity activities in a manner that aligns cybersecurity objectives with both the organization\'s strategic objectives and the risk to critical infrastructure.', marginBottom: largeSpacing },
        { text: 'For a more in-depth discussion of the C2M2 domains, refer to the C2M2 V2.1 model document available here: https://energy.gov/C2M2.', pageBreak: 'after' },

        // Section 2.2 Maturity Indicator Levels'
        { text: '2.2 Maturity Indicator Levels', style: 'header', marginBottom: largeSpacing },
        { text: 'The model defines four maturity indicator levels (MILs), MIL0 through MIL3, which apply independently to each domain in the mode. The MILs define a dual progression of maturity: an approach progression and a management progression.', marginBottom: normalSpacing },
        {
          text: 'Four aspects of the MILs are important for understanding and applying the model: ',
          ul: [
            'The maturity indicator levels apply independently to each domain. As a result, an organization using the model may be operating at different MIL ratings in different domains. For example, an organization could be operating at MIL1 in one domain, MIL2 in another domain, and MIL3 in a third domain.',
            'The MILs—MIL0 through MIL3—are cumulative within each domain. To earn a MIL in a given domain, an organization must perform all of the practices in that level and its predecessor level. For example, an organization must perform all of the domain practices in MIL1 and MIL2 to achieve MIL2 in the domain. Similarly, the organization must perform all practices in MIL1, MIL2, and MIL3 to achieve MIL3.',
            'Establishing a target MIL for each domain is an effective strategy for using the model to guide cybersecurity program improvement. Organizations should become familiar with the practices in the model prior to determining target MILs. Then, they can focus gap analysis activities and improvement efforts on achieving those target levels.',
            'Practice performance and MIL achievement need to align with business objectives and the organization\'s cybersecurity program strategy. Striving to achieve the highest MIL in all domains may not be optimal. Companies should evaluate the costs of achieving a specific MIL versus its potential benefits. However, the model was designed so that all companies, regardless of size, should be able to achieve MIL1 across all domains.',
          ],
          marginBottom: normalSpacing
        },
        { text: 'For a more in-depth discussion of the C2M2 domains, refer to the C2M2 V2.1 model document available here: https://energy.gov/C2M2.', marginBottom: normalSpacing },
        { text: '', pageBreak: 'after' },

        // Section 2.3 Maturity Indicator Level Scoring
        { text: '2.3 Maturity Indicator Level Scoring', style: 'header', marginBottom: largeSpacing },
        { text: 'MIL achievement scores are derived from responses entered into the C2M2 Self-Evaluation Tool. Responses are chosen from a four-point scale: Fully Implemented (FI), Largely Implemented (LI), Partially Implemented (PI), and Not Implemented (NI). A MIL is achieved when all practices in that MIL and all preceding MILs receive responses of Fully Implemented or Largely Implemented. A MIL is not achieved if any practices in that MIL or a preceding MIL have received a response of Partially Implemented or Not Implemented. ', marginBottom: normalSpacing },
        {
          text: 'In other words, achieving a MIL in a domain requires the following: ',
          ol: [
            'Responses of Fully Implemented or Largely Implemented for all practices in that MIL.',
            'Responses of Fully Implemented or Largely Implemented for all practices in the preceding MILs in that domain.',
          ],
          marginBottom: normalSpacing
        },
        { text: 'For example, to achieve MIL1 in a domain with four MIL1 practices, all four MIL1 practices have responses of Fully Implemented or Largely Implemented. To achieve MIL2 in that same domain, all MIL1 and MIL2 practices must have responses of Fully Implemented or Largely Implemented.', marginBottom: normalSpacing },
        { text: 'Descriptions for self-evaluation response options are shown in the following table.', marginBottom: normalSpacing },
        {
          table: {
            headerRows: 1,
            widths: ['*', 'auto'],
            body: [
              [{ text: 'Response', bold: true, alignment: 'center' }, { text: 'Implementation Description', bold: true, alignment: 'center' }],
              [{ text: 'Fully Implemented (FI)', fillColor: '#005c99', color: 'white', alignment: 'center' }, 'Complete'],
              [{ text: 'Largely Implemented (LI)', fillColor: '#8ba6ca', alignment: 'center' }, 'Complete, but with a recognized opportunity for improvement'],
              [{ text: 'Partially Implemented (PI)', fillColor: '#fad980', alignment: 'center' }, 'Incomplete; there are multiple opportunities for improvement'],
              [{ text: 'Not Implemented (NI)', fillColor: '#e69f00', alignment: 'center' }, 'Absent; the practice is not performed by the organization'],
            ],
          },
          marginBottom: smallSpacing
        },
        { text: 'Table 1: Description of Self-Evaluation Response Options', style: 'caption', marginBottom: normalSpacing },
        { text: '', pageBreak: 'after' },

        // Section 3 Summary of Self-Evaluation Results
        { text: '3. Summary of Self-Evaluation Results', style: 'header', marginBottom: largeSpacing },

        // Section 3.1 MIL Achievement by Domain
        { text: '3.1 MIL Achievement by Domain', style: 'header', marginBottom: extraLargeSpacing },
        { text: 'Figure 2 shows the MIL achieved for each C2M2 domain.', marginBottom: normalSpacing },
        htmlToPdfmake(this.figureTwoChart),
        { text: 'Figure 2: MIL Achieved by Domain', style: 'caption', marginBottom: normalSpacing },
        { text: '', pageBreak: 'after' },

        // Section 3.2 Practice Implementation by Domain
        { text: '3.2 Practice Implementation by Domain', style: 'header', marginBottom: largeSpacing },
        { text: 'Figure 3 shows summarized implementation level responses for each C2M2 practice, grouped by domain. The MIL achieved for each domain is listed at the bottom of the figure. A MIL is achieved when all practices in that MIL and all preceding MILs receive responses of Fully Implemented or Largely Implemented. A high-level understanding of the organization\'s self evaluation results can be gained from this figure and may be useful when evaluating areas for future improvement.', marginBottom: normalSpacing },
        { text: 'The number in the center of each donut chart represents the cumulative number of practices in that MIL for that domain. Refer to Section 4.2 of the C2M2 V2.1 model document for a description of how MIL achievement is determined.', marginBottom: normalSpacing, pageBreak: 'after', pageOrientation: 'landscape' },
        {
          columns: [
            {
              margin: [-23, 0, 0, 0],
              width: 'auto',
              table: this.buildGiantDonutChart(),
              layout: 'noBorders',
            },
            { width: '*', text: '' },
          ]
        },
        { text: '', marginBottom: largeSpacing },
        { text: 'Figure 3: Summary of Responses Input by MIL and Domain', style: 'caption', marginBottom: normalSpacing },
        { text: '', pageBreak: 'after', pageOrientation: 'portrait' },

        // Section 3.3 Implementation of Management Activities across Domains
        { text: '3.3 Implementation of Management Activities across Domains', style: 'header', marginBottom: largeSpacing },
        { text: 'The final objective of each C2M2 domain includes practices focused on cybersecurity management activities. These practices focus on the extent to which cybersecurity practices are institutionalized, or ingrained, in the organization\'s operations. The more deeply ingrained an activity, the more likely it is that the organization will continue to perform the activity over time; the activity will be retained under time of stress; and the outcomes of the activity will be consistent, repeatable, and of high quality. Table 2 provides a high-level overview of implementation of the Management Activities from two perspectives: 1) implementation of all Management Activities within each domain and 2) implementation of each Management Activities practice across the ten C2M2 domains.', marginBottom: normalSpacing },
        { text: '', marginBottom: smallSpacing },
        {
          table:
          {
            widths: [170, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25],
            body: [
              ['', assetSvg, threatSvg, riskSvg, accessSvg, situationSvg, responseSvg, thirdpartySvg, workforceSvg, architectureSvg, programSvg],
              [this.tableData.managementQuestions[0].questionText, this.tableTwoStructure[0], this.tableTwoStructure[1], this.tableTwoStructure[2], this.tableTwoStructure[3], this.tableTwoStructure[4], this.tableTwoStructure[5], this.tableTwoStructure[6], this.tableTwoStructure[7], this.tableTwoStructure[8], this.tableTwoStructure[9]],
              [this.tableData.managementQuestions[1].questionText, this.tableTwoStructure[10], this.tableTwoStructure[11], this.tableTwoStructure[12], this.tableTwoStructure[13], this.tableTwoStructure[14], this.tableTwoStructure[15], this.tableTwoStructure[16], this.tableTwoStructure[17], this.tableTwoStructure[18], this.tableTwoStructure[19]],
              [this.tableData.managementQuestions[2].questionText, this.tableTwoStructure[20], this.tableTwoStructure[21], this.tableTwoStructure[22], this.tableTwoStructure[23], this.tableTwoStructure[24], this.tableTwoStructure[25], this.tableTwoStructure[26], this.tableTwoStructure[27], this.tableTwoStructure[28], this.tableTwoStructure[29]],
              [this.tableData.managementQuestions[3].questionText, this.tableTwoStructure[30], this.tableTwoStructure[31], this.tableTwoStructure[32], this.tableTwoStructure[33], this.tableTwoStructure[34], this.tableTwoStructure[35], this.tableTwoStructure[36], this.tableTwoStructure[37], this.tableTwoStructure[38], this.tableTwoStructure[39]],
              [this.tableData.managementQuestions[4].questionText, this.tableTwoStructure[40], this.tableTwoStructure[41], this.tableTwoStructure[42], this.tableTwoStructure[43], this.tableTwoStructure[44], this.tableTwoStructure[45], this.tableTwoStructure[46], this.tableTwoStructure[47], this.tableTwoStructure[48], this.tableTwoStructure[49]],
              [this.tableData.managementQuestions[5].questionText, this.tableTwoStructure[50], this.tableTwoStructure[51], this.tableTwoStructure[52], this.tableTwoStructure[53], this.tableTwoStructure[54], this.tableTwoStructure[55], this.tableTwoStructure[56], this.tableTwoStructure[57], this.tableTwoStructure[58], this.tableTwoStructure[59]],
            ]
          },
          layout: {
            hLineColor: function (i, node) {
              return '#b3b3b3';
            },
            vLineColor: function (i, node) {
              return '#b3b3b3';
            },
          }, marginBottom: smallSpacing
        },
        { text: 'Table 2: Management Activities', style: 'caption', marginBottom: normalSpacing },
        { text: '', pageBreak: 'after' },

        // Section 4 Detailed Self-Evaluation Results
        { text: '4. Detailed Self-Evaluation Results', style: 'header', marginBottom: largeSpacing },
        { text: 'This section provides the level of implementation (i.e., Fully Implemented, Largely Implemented, Partially Implemented, and Not Implemented) input to the self-evaluation tool for each C2M2 practice by domain, objective, and MIL. See Section 2.3 Maturity Indicator Level Scoring for a detailed explanation of the scoring process and Section 5 Using the Model for further detail regarding self-evaluation results.', marginBottom: normalSpacing },
        { text: '', pageBreak: 'after', pageOrientation: 'landscape' },

        // Section 4.1 Domain: Asset. Change, and Configuration Management (ASSET)
        { text: '4.1 Domain: Asset, Change, and Configuration Management (ASSET)', style: 'header', marginBottom: largeSpacing },
        { text: 'Manage the organization\'s IT and OT assets, including both hardware and software, and information assets commensurate with the risk to critical infrastructure and organizational objectives.', marginBottom: normalSpacing },

        this.buildDonutChart(5, this.donutData[0].objectives, 0),

        {
          columns: [
            {
              width: 'auto',
              text: "MIL1", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("ASSET", 1),
          ]
        },
        {
          columns: [
            {
              width: 'auto',
              text: "MIL2", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("ASSET", 2),
          ]
        },
        {
          columns: [
            {
              width: 'auto',
              text: "MIL3", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("ASSET", 3),
          ]
        },

        { text: '', pageBreak: 'after', pageOrientation: 'portrait' },

        { text: 'Objective 1: ' + this.objectiveTitles[0], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("ASSET", 1),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 2: ' + this.objectiveTitles[1], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("ASSET", 2),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 3: ' + this.objectiveTitles[2], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("ASSET", 3),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 4: ' + this.objectiveTitles[3], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("ASSET", 4),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 5: ' + this.objectiveTitles[4], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("ASSET", 5),
        { text: '', pageBreak: 'after', pageOrientation: 'landscape' },

        // Section 4.2 Domain: Threat and Vulnerability Management (THREAT)
        { text: '4.2 Domain: Threat and Vulnerability Management (THREAT)', style: 'header', marginBottom: largeSpacing },
        { text: 'Establish and maintain plans, procedures, and technologies to detect, identify, analyze, manage, and respond to cybersecurity threats and vulnerabilities, commensurate with the risk to the organization\'s infrastructure (such as critical, IT, and operational) and organizational objectives.', marginBottom: normalSpacing },

        this.buildDonutChart(3, this.donutData[1].objectives, 1),

        {
          columns: [
            {
              width: 'auto',
              text: "MIL1", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("THREAT", 1),
          ]
        },
        {
          columns: [
            {
              width: 'auto',
              text: "MIL2", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("THREAT", 2),
          ]
        },
        {
          columns: [
            {
              width: 'auto',
              text: "MIL3", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("THREAT", 3),
          ]
        },

        { text: '', pageBreak: 'after', pageOrientation: 'portrait' },

        { text: 'Objective 1: ' + this.objectiveTitles[5], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("THREAT", 1),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 2: ' + this.objectiveTitles[6], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("THREAT", 2),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 3: ' + this.objectiveTitles[7], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("THREAT", 3),
        { text: '', pageBreak: 'after', pageOrientation: 'landscape' },


        // Section 4.3 Domain: Risk Management (RISK)
        { text: '4.3 Domain: Risk Management (RISK) ', style: 'header', marginBottom: largeSpacing },
        { text: 'Establish, operate, and maintain an enterprise cyber risk management program to identify, analyze, and response to cyber risk the organization is subject to, including its business units, subsidiaries, related interconnected infrastructure, and stakeholders.', marginBottom: normalSpacing },

        this.buildDonutChart(5, this.donutData[2].objectives, 2),

        {
          columns: [
            {
              width: 'auto',
              text: "MIL1", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("RISK", 1),
          ]
        },
        {
          columns: [
            {
              width: 'auto',
              text: "MIL2", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("RISK", 2),
          ]
        },
        {
          columns: [
            {
              width: 'auto',
              text: "MIL3", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("RISK", 3),
          ]
        },

        { text: '', pageBreak: 'after', pageOrientation: 'portrait' },

        { text: 'Objective 1: ' + this.objectiveTitles[8], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("RISK", 1),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 2: ' + this.objectiveTitles[9], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("RISK", 2),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 3: ' + this.objectiveTitles[10], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("RISK", 3),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 4: ' + this.objectiveTitles[11], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("RISK", 4),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 5: ' + this.objectiveTitles[12], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("RISK", 5),
        { text: '', pageBreak: 'after', pageOrientation: 'landscape' },

        // Section 4.4 Domain: Identity and Access Management (ACCESS) 
        { text: '4.4 Domain: Identity and Access Management (ACCESS)', style: 'header', marginBottom: largeSpacing },
        { text: 'Create and manage identities for the entities that may be granted logical or physical access to the organization\'s assets. Control access to the organization\'s assets, commensurate with the risk to critical infrastructure and organizational objectives.', marginBottom: normalSpacing },

        this.buildDonutChart(4, this.donutData[3].objectives, 3),

        {
          columns: [
            {
              width: 'auto',
              text: "MIL1", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("ACCESS", 1),
          ]
        },
        {
          columns: [
            {
              width: 'auto',
              text: "MIL2", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("ACCESS", 2),
          ]
        },
        {
          columns: [
            {
              width: 'auto',
              text: "MIL3", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("ACCESS", 3),
          ]
        },

        { text: '', pageBreak: 'after', pageOrientation: 'portrait' },

        { text: 'Objective 1: ' + this.objectiveTitles[13], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("ACCESS", 1),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 2: ' + this.objectiveTitles[14], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("ACCESS", 2),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 3: ' + this.objectiveTitles[15], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("ACCESS", 3),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 4: ' + this.objectiveTitles[16], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("ACCESS", 4),
        { text: '', pageBreak: 'after', pageOrientation: 'landscape' },

        // Section 4.5 Domain: Situational Awareness (SITUATION)
        { text: '4.5 Domain: Situational Awareness (SITUATION)', style: 'header', marginBottom: largeSpacing },
        { text: 'Establish and maintain activities and technologies to collect, monitor, analyze, alarm, report, and use operational, security, and threat information, including status and summary information from the other model domains, to establish situational awareness for both the organization\'s operational state and cybersecurity state.', marginBottom: normalSpacing },

        this.buildDonutChart(4, this.donutData[4].objectives, 4),

        {
          columns: [
            {
              width: 'auto',
              text: "MIL1", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("SITUATION", 1),
          ]
        },
        {
          columns: [
            {
              width: 'auto',
              text: "MIL2", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("SITUATION", 2),
          ]
        },
        {
          columns: [
            {
              width: 'auto',
              text: "MIL3", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("SITUATION", 3),
          ]
        },

        { text: '', pageBreak: 'after', pageOrientation: 'portrait' },

        { text: 'Objective 1: ' + this.objectiveTitles[17], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("SITUATION", 1),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 2: ' + this.objectiveTitles[18], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("SITUATION", 2),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 3: ' + this.objectiveTitles[19], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("SITUATION", 3),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 4: ' + this.objectiveTitles[20], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("SITUATION", 4),
        { text: '', pageBreak: 'after', pageOrientation: 'landscape' },

        // Section 4.6 Domain: Event and Incident Response, Continuity of Operations (RESPONSE)
        { text: '4.6 Domain: Event and Incident Response, Continuity of Operations (RESPONSE)', style: 'header', marginBottom: largeSpacing },
        { text: 'Establish and maintain plans, procedures, and technologies to detect, analyze, mitigate, respond to, and recovery from cybersecurity events and incidents and to sustain operations during cybersecurity incidents, commensurate with the risk to critical and organizational objectives.', marginBottom: normalSpacing },

        this.buildDonutChart(5, this.donutData[5].objectives, 5),

        {
          columns: [
            {
              width: 'auto',
              text: "MIL1", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("RESPONSE", 1),
          ]
        },
        {
          columns: [
            {
              width: 'auto',
              text: "MIL2", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("RESPONSE", 2),
          ]
        },
        {
          columns: [
            {
              width: 'auto',
              text: "MIL3", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("RESPONSE", 3),
          ]
        },

        { text: '', pageBreak: 'after', pageOrientation: 'portrait' },

        { text: 'Objective 1:  ' + this.objectiveTitles[21], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("RESPONSE", 1),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 2: ' + this.objectiveTitles[22], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("RESPONSE", 2),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 3: ' + this.objectiveTitles[23], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("RESPONSE", 3),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 4: ' + this.objectiveTitles[24], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("RESPONSE", 4),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 5: ' + this.objectiveTitles[25], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("RESPONSE", 5),
        { text: '', pageBreak: 'after', pageOrientation: 'landscape' },

        // Section 4.7 Domain: Third-Party Risk Management (THIRD-PARTIES)
        { text: '4.7 Domain: Third-Party Risk Management (THIRD-PARTIES)', style: 'header', marginBottom: largeSpacing },
        { text: 'Establish and maintain controls to manage the cyber risks arising from suppliers and other third parties, commensurate with the risk to critical infrastructure and organizational objectives.', marginBottom: normalSpacing },

        this.buildDonutChart(3, this.donutData[6].objectives, 6),

        {
          columns: [
            {
              width: 'auto',
              text: "MIL1", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("THIRD", 1),
          ]
        },
        {
          columns: [
            {
              width: 'auto',
              text: "MIL2", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("THIRD", 2),
          ]
        },
        {
          columns: [
            {
              width: 'auto',
              text: "MIL3", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("THIRD", 3),
          ]
        },

        { text: '', pageBreak: 'after', pageOrientation: 'portrait' },

        { text: 'Objective 1: ' + this.objectiveTitles[26], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("THIRD-PARTIES", 1),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 2: ' + this.objectiveTitles[27], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("THIRD-PARTIES", 2),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 3: ' + this.objectiveTitles[28], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("THIRD-PARTIES", 3),
        { text: '', pageBreak: 'after', pageOrientation: 'landscape' },

        // Section 4.8 Domain: Workforce Management (WORKFORCE)
        { text: '4.8 Domain: Workforce Management (WORKFORCE)', style: 'header', marginBottom: largeSpacing },
        { text: 'Establish and maintain plans, proceudres, technologies, and controls to create a culture of cybersecurity and to ensure the ongoing suitability and competence of personnel, commensurate with the risk to critical infrastructure and organizational objectives.', marginBottom: normalSpacing },
        { text: '', marginBottom: normalSpacing },

        this.buildDonutChart(5, this.donutData[7].objectives, 7),

        {
          columns: [
            {
              width: 'auto',
              text: "MIL1", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("WORKFORCE", 1),
          ]
        },
        {
          columns: [
            {
              width: 'auto',
              text: "MIL2", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("WORKFORCE", 2),
          ]
        },
        {
          columns: [
            {
              width: 'auto',
              text: "MIL3", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("WORKFORCE", 3),
          ]
        },

        { text: '', pageBreak: 'after', pageOrientation: 'portrait' },

        { text: 'Objective 1: ' + this.objectiveTitles[29], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("WORKFORCE", 1),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 2:  ' + this.objectiveTitles[30], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("WORKFORCE", 2),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 3: ' + this.objectiveTitles[31], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("WORKFORCE", 3),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 4: ' + this.objectiveTitles[32], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("WORKFORCE", 4),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 5: ' + this.objectiveTitles[33], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("WORKFORCE", 5),
        { text: '', pageBreak: 'after', pageOrientation: 'landscape' },

        // Section 4.9 Domain: Cybersecurity Architecture (ARCHITECTURE)
        { text: '4.9 Domain: Cybersecurity Architecture (ARCHITECTURE)', style: 'header', marginBottom: largeSpacing },
        { text: 'Establish and maintain the structure and behavior of the organization\'s cybersecurity architecture, including controls, processes, technologies, and other elements, commensurate with the risk to critical infrastructure and organizational objectives.', marginBottom: normalSpacing },

        this.buildDonutChart(6, this.donutData[8].objectives, 8),

        {
          columns: [
            {
              width: 'auto',
              text: "MIL1", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("ARCHITECTURE", 1),
          ]
        },
        {
          columns: [
            {
              width: 'auto',
              text: "MIL2", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("ARCHITECTURE", 2),
          ]
        },
        {
          columns: [
            {
              width: 'auto',
              text: "MIL3", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("ARCHITECTURE", 3),
          ]
        },

        { text: '', pageBreak: 'after', pageOrientation: 'portrait' },

        { text: 'Objective 1: ' + this.objectiveTitles[34], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("ARCHITECTURE", 1),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 2: ' + this.objectiveTitles[35], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("ARCHITECTURE", 2),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 3: ' + this.objectiveTitles[36], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("ARCHITECTURE", 3),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 4: ' + this.objectiveTitles[37], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("ARCHITECTURE", 4),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 5: ' + this.objectiveTitles[38], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("ARCHITECTURE", 5),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 6: ' + this.objectiveTitles[39], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("ARCHITECTURE", 6),
        { text: '', pageBreak: 'after', pageOrientation: 'landscape' },

        // Section 4.10 Domain: Cybersecurity Program Management (PROGRAM)
        { text: '4.10 Domain: Cybersecurity Program Management (PROGRAM) ', style: 'header', marginBottom: largeSpacing },
        { text: 'Establish and maintain an enterprise cybersecurity program that provides governance, strategic planning, and sponsorship for the organization\'s cybersecurity activities in a manner that aligns cybersecurity objectives with both the organization\'s strategic objectives and the risk to critical infrastructure.', marginBottom: normalSpacing },

        this.buildDonutChart(3, this.donutData[9].objectives, 9),

        {
          columns: [
            {
              width: 'auto',
              text: "MIL1", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("PROGRAM", 1),
          ]
        },
        {
          columns: [
            {
              width: 'auto',
              text: "MIL2", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("PROGRAM", 2),
          ]
        },
        {
          columns: [
            {
              width: 'auto',
              text: "MIL3", fontSize: 12, marginTop: 9, marginRight: 10
            },

            this.buildHeatMaps("PROGRAM", 3),
          ]
        },

        { text: '', pageBreak: 'after', pageOrientation: 'portrait' },

        { text: 'Objective 1: ' + this.objectiveTitles[40], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("PROGRAM", 1),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 2: ' + this.objectiveTitles[41], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("PROGRAM", 2),
        { text: '', pageBreak: 'after' },

        { text: 'Objective 3: ' + this.objectiveTitles[42], style: 'subHeader', marginBottom: smallSpacing },
        this.buildObjectivesTable("PROGRAM", 3),
        { text: '', pageBreak: 'after' },

        // Section 5: Using the Self-Evaluation Results
        { text: '5. Using the Self-Evaluation Results', style: 'header', marginBottom: largeSpacing },
        { text: 'The C2M2 is meant to be used by an organization to evaluate its cybersecurity capabilities consistently, to communicate its capability levels in meaningful terms, and to inform the prioritization of its cybersecurity investments. Figure 4 summarizes a potential approach for using the model. An organization performs a self-evaluation against the model, uses that self evaluation to identify gaps in capability, prioritizes those gaps and develops plans to address them, and finally implements plans to address the gaps. As plans are implemented, business objectives change, and the risk environment evolves, the process is repeated. This section offers a brief overview of how to use the self-evaluation results in this approach. For a more detailed review of these steps and additional guidance, see the "Using the Model" section of the C2M2 V2.1 model document available here: https://energy.gov/C2M2.', marginBottom: smallSpacing },
        { svg: '<svg width="335" viewBox="-700 -230 895 444" fill="#fff" font-family="Calibri" font-size="36" text-anchor="middle" overflow="visible"><title id="assessmentApproachTitle">Figure 4: Potential Approach for Using the Model</title><desc id="assessmentApproachDesc">Figure 4: Potential Approach for Using the Model. A flow chart graphic showing 4 steps in a circular formation with arrows demonstrating a clockwise movement. The steps are Perform Evaluation, Analyze Identified Gaps, Prioritize and Plan, and Implement Plans.</desc><g id="aa-use" transform="translate(350) rotate(45)"><circle r="150" fill="#015289"></circle><path fill="#015289" d="M0 300l50-40H30v-50h-60v50h-20z"></path></g><use href="#aa-use" transform="rotate(90)"></use><use href="#aa-use" transform="rotate(180)"></use><use href="#aa-use" transform="rotate(270)"></use><text x="-350"><tspan dy="-.8em">Implement</tspan><tspan x="-350" dy="1.2em">Plans</tspan></text><text y="-350"><tspan dy="-.8em">Perform a</tspan><tspan x="0" dy="1.2em">Self-</tspan><tspan x="0" dy="1.2em">Evaluation</tspan></text><text x="350"><tspan dy="-.8em">Analyze</tspan><tspan x="350" dy="1.2em">Identified</tspan><tspan x="350" dy="1.2em">Gaps</tspan></text><text y="350"><tspan x="0" dy="-.6em">Prioritize</tspan><tspan x="0" dy="1.2em">and Plan</tspan></text></svg>', marginBottom: -15 },
        { text: 'Figure 4: Proposed Approach for Using the Model', style: 'caption', marginBottom: extraLargeSpacing },
        { text: 'This report summarizes the results of the organization\'s self-evaluation conducted in Step 1, Perform a Self Evaluation', marginBottom: normalSpacing },
        { text: 'It provides a point-in-tine view of the cybersecurity posture of the in-scope function. Self evaluation workshop participants should review this report and collectively address any discrepancies or questions before the next step.', marginBottom: normalSpacing },
        { text: 'In Step 2, Analyze Identified Gaps, the organization identifies gaps in the performance of model practices by examining the self evaluation results against its target profile - the desired profile that represents the organization\'s target MIL rating for each domain in the model. Organizations using the model for the first time may identify the target profile after performing a self evaluation, while others often identify a target profile before conducting a self-evaluation. For more information on setting targets, see Appendix D, "Setting Targets" in the C2M2 Self Evaluation Guide available here: https://energy.gov/C2M2.', marginBottom: normalSpacing },
        { text: 'In Step 3, Prioritize and Plan, the organization uses the gap analysis to prioritize the actions needed to fully implement the practices in the target profile. A cost-benefit analysis may help to inform the prioritization of actions needed. The organization should then develop a plan to address the selected gaps and assign ownership of the plan to an individual with sufficient authority to oversee implementation.', marginBottom: normalSpacing },
        { text: 'Regular reviews by organizational leadership should be conducted to evaluate status, clear obstacles, and identify any necessary course corrections as implementation progresses.', marginBottom: normalSpacing },
        { text: 'In Step 4, Implement Plans and Periodically Reevaluate, plans developed in the previous step should be implemented to address the identified gaps. Subsequent model self-evaluations are particularly useful in tracking implementation and should be conducted periodically to ensure that desired progress is achieved. Reevaluations should also be considered in response to major changes in business, technology, market, or threat environments to ensure that the current profile matches the organization\'s desired state.', marinBottom: normalSpacing },
        { text: '', pageBreak: 'after' },

        // Section 6 Self-Evaluation Notes
        { text: '6. Self-Evaluation Notes', style: 'header', marginBottom: largeSpacing },
        { text: 'This section lists all practices for which notes were captured during the self-evaluation, regardless of implementation status. Reviewing the notes may provide the rationale for the selection of an implementation response during the completion of the self-evaluation. The tables in this section are ordered by model practice identifier.', marginBottom: largeSpacing },

        { text: 'Domain: Asset, Change, and Configuration Management (ASSET)', style: 'subHeader', marginBottom: smallSpacing },
        this.buildCommentsTable("ASSET"),

        { text: 'Domain: Threat and Vulnerability Management (THREAT)', style: 'subHeader', marginBottom: smallSpacing },
        this.buildCommentsTable("THREAT"),

        { text: 'Domain: Risk Management (RISK)', style: 'subHeader', marginBottom: smallSpacing },
        this.buildCommentsTable("RISK"),

        { text: 'Domain: Identity and Access Management (ACCESS)', style: 'subHeader', marginBottom: smallSpacing },
        this.buildCommentsTable("ACCESS"),

        { text: 'Domain: Situational Awareness (SITUATION)', style: 'subHeader', marginBottom: smallSpacing },
        this.buildCommentsTable("SITUATION"),

        { text: 'Domain: Event and Incident Response, Continuity of Operations (RESPONSE)', style: 'subHeader', marginBottom: smallSpacing },
        this.buildCommentsTable("RESPONSE"),

        { text: 'Domain: Third-Party Risk Management (THIRD-PARTIES)', style: 'subHeader', marginBottom: smallSpacing },
        this.buildCommentsTable("THIRD-PARTIES"),

        { text: 'Domain: Workforce Management (WORKFORCE)', style: 'subHeader', marginBottom: smallSpacing },
        this.buildCommentsTable("WORKFORCE"),

        { text: 'Domain: Cybersecurity Architecture (ARCHITECTURE)', style: 'subHeader', marginBottom: smallSpacing },
        this.buildCommentsTable("ARCHITECTURE"),

        { text: 'Domain: Cybersecurity Program Management (PROGRAM)', style: 'subHeader', marginBottom: smallSpacing },
        this.buildCommentsTable("PROGRAM"),
        { text: '', pageBreak: 'after' },

        // Section 7 List of Partially Implemented and Not Implemented Practices
        { text: '7. List of Partially Implemented and Not Implemented Practices', style: 'header', marginBottom: largeSpacing },
        { text: 'Practices that received a response of Partially Implemented or Not Implemented are consolidated in this section and shown with any notes captured during the self-evaluation. If an organization is targeting a MIL in a specific domain, these tables will highlight the practices the organization must prioritize to achieve the target MIL.', marginBottom: normalSpacing },
        { text: 'The tables in this section are ordered first by MIL, then further ordered by the implementation response for practices at that MIL, with Partially Implemented practices followed by Not Implemented practices. This highlights the practices that may be the focus of improvement efforts to reach a MIL target in each domain.', marginBottom: largeSpacing },

        { text: 'Domain: Asset, Change, and Configuration Management (ASSET)', style: 'subHeader', marginBottom: smallSpacing },
        this.buildImplementedTable("ASSET", "MIL-1", 0),
        this.buildImplementedTable("ASSET", "MIL-2", 1),
        this.buildImplementedTable("ASSET", "MIL-3", 2),

        { text: 'Domain: Threat and Vulnerability Management (THREAT)', style: 'subHeader', marginBottom: smallSpacing },
        this.buildImplementedTable("THREAT", "MIL-1", 0),
        this.buildImplementedTable("THREAT", "MIL-2", 1),
        this.buildImplementedTable("THREAT", "MIL-3", 2),

        { text: 'Domain: Risk Management (RISK)', style: 'subHeader', marginBottom: smallSpacing },
        this.buildImplementedTable("RISK", "MIL-1", 0),
        this.buildImplementedTable("RISK", "MIL-2", 1),
        this.buildImplementedTable("RISK", "MIL-3", 2),

        { text: 'Domain: Identity and Access Management (ACCESS)', style: 'subHeader', marginBottom: smallSpacing },
        this.buildImplementedTable("ACCESS", "MIL-1", 0),
        this.buildImplementedTable("ACCESS", "MIL-2", 1),
        this.buildImplementedTable("ACCESS", "MIL-3", 2),

        { text: 'Domain: Situational Awareness (SITUATION)', style: 'subHeader', marginBottom: smallSpacing },
        this.buildImplementedTable("SITUATION", "MIL-1", 0),
        this.buildImplementedTable("SITUATION", "MIL-2", 1),
        this.buildImplementedTable("SITUATION", "MIL-3", 2),

        { text: 'Domain: Event and Incident Response, Continuity of Operations (RESPONSE)', style: 'subHeader', marginBottom: smallSpacing },
        this.buildImplementedTable("RESPONSE", "MIL-1", 0),
        this.buildImplementedTable("RESPONSE", "MIL-2", 1),
        this.buildImplementedTable("RESPONSE", "MIL-3", 2),

        { text: 'Domain: Third-Party Risk Management (THIRD-PARTIES)', style: 'subHeader', marginBottom: smallSpacing },
        this.buildImplementedTable("THIRD-PARTIES", "MIL-1", 0),
        this.buildImplementedTable("THIRD-PARTIES", "MIL-2", 1),
        this.buildImplementedTable("THIRD-PARTIES", "MIL-3", 2),


        { text: 'Domain: Workforce Management (WORKFORCE)', style: 'subHeader', marginBottom: smallSpacing },
        this.buildImplementedTable("WORKFORCE", "MIL-1", 0),
        this.buildImplementedTable("WORKFORCE", "MIL-2", 1),
        this.buildImplementedTable("WORKFORCE", "MIL-3", 2),

        { text: 'Domain: Cybersecurity Architecture (ARCHITECTURE)', style: 'subHeader', marginBottom: smallSpacing },
        this.buildImplementedTable("ARCHITECTURE", "MIL-1", 0),
        this.buildImplementedTable("ARCHITECTURE", "MIL-2", 1),
        this.buildImplementedTable("ARCHITECTURE", "MIL-3", 2),

        { text: 'Domain: Cybersecurity Program Management (PROGRAM)', style: 'subHeader', marginBottom: smallSpacing },
        this.buildImplementedTable("PROGRAM", "MIL-1", 0),
        this.buildImplementedTable("PROGRAM", "MIL-2", 1),
        this.buildImplementedTable("PROGRAM", "MIL-3", 2),
      ],

      styles: {
        header: { fontSize: 28, bold: true, color: '#0A5278' },
        subHeader: { fontSize: 16, color: '#0A5278' },
        caption: { fontSize: 12, color: '#0A5278', alignment: 'center' },
        defaultStyle: { fontSize: 12 }
      }
    };

    if (download) {
      pdfMake.createPdf(this.pdfDocument).download("C2M2 Report.pdf");
    } else {
      pdfMake.createPdf(this.pdfDocument).open();
    }

  }
}