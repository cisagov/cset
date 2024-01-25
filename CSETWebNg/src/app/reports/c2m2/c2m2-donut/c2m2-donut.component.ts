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
import { Component, Input, OnInit, AfterViewInit, ViewChild } from '@angular/core';

@Component({
  selector: 'app-c2m2-donut',
  templateUrl: './c2m2-donut.component.html',
  styleUrls: ['./c2m2-donut.component.scss']
})
export class C2m2DonutComponent implements OnInit, AfterViewInit {


  @ViewChild('pieChart') pieChart;
  @Input() questionDistribution: any;
  totalQuestionsCount: number;
  loading: boolean = true;

  data: any[];
  view: any[] = [100, 100];

  colorScheme = {
    // Dark mode scheme?
    // domain: ['#005c99', '#8ba6ca', '#fad980', '#e69f00', '#cccccc']
    domain: ['#265B94', '#90A5C7', '#F5DA8C', '#DCA237', '#E6E6E6']
  };

  constructor() {
  }

  ngOnInit(): void {
    this.data = [
      {
        name: "Fully Implemented",
        value: this.questionDistribution.fi
      },
      {
        name: "Largely Implemented",
        value: this.questionDistribution.li
      },
      {
        name: "Partially Implemented",
        value: this.questionDistribution.pi
      },
      {
        name: "Not Implemented",
        value: this.questionDistribution.ni
      },
      {
        name: "Unanswered",
        value: this.questionDistribution.u
      },
    ]

    this.totalQuestionsCount = this.data.map(x => x.value).reduce((a, b) => a + b);
    this.loading = false;

  }

  ngAfterViewInit() {
    this.drawOnPieChart();
  }

  // This places the answer counts inside the pie chart itself
  private drawOnPieChart() {
    // get the ngx chart element
    let node = this.pieChart.chartElement.nativeElement;
    let svg;

    // set the margins of the pie chart to be a bit more compact
    this.pieChart.margins = [10, 10, 10, 10];
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

    for (let i = 0; i < slices.length; i++) {
      const value = this.data[i].value;
      let color = 'black';
      // sets white text only for the FI slice
      if (this.data[i].name == "Fully Implemented") {
        color = 'white';
      }

      let startingValue = 0;
      for (let j = 0; j < i; j++) {
        startingValue += (this.data[j].value / this.totalQuestionsCount * 100);
      }

      const text = this.generateText(value, maxX - minX, startingValue, color);
      svg.append(text);
    }
  }

  private generateText(value: number, diagonal: number, startingValue: number, color: string) {
    // create text element
    const text = document.createElementNS('http://www.w3.org/2000/svg', 'text');

    const r = Math.round(diagonal / 2.3);
    // angle = summed angle of previous slices + half of current slice - 90 degrees (starting at the top of the circle)
    const angle = ((startingValue * 2 + (value / this.totalQuestionsCount * 100)) / 100 - 0.5) * Math.PI;
    const x = r * Math.cos(angle);
    const y = r * Math.sin(angle) + 5;

    text.setAttribute('x', '' + x);
    text.setAttribute('y', '' + y);
    text.setAttribute('fill', color);
    text.textContent = value != 0 ? value.toString() : '';
    text.setAttribute('style', 'font-size: 12px')
    text.setAttribute('text-anchor', 'middle');
    text.setAttribute('pointer-events', 'none');
    return text;
  }
}
