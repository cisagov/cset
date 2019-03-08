////////////////////////////////
//
//   Copyright 2018 Battelle Energy Alliance, LLC
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
import { Title } from '@angular/platform-browser';
import { ReportService } from '../services/report.service';
// import { SecurityPlanResponse } from '../models/requirement-control.model';
// import { Discovery, Individual } from '../models/discoveries.model';

@Component({
  selector: 'rapp-discoveries',
  templateUrl: './discovery-tearouts.component.html',
  styleUrls: ['./discovery-tearouts.component.scss']
})
export class DiscoveryTearoutsComponent implements OnInit {

  response: any;

  /**
   * Constructor.
   * @param titleService
   * @param reportSvc
   */
  public constructor(private titleService: Title, private reportSvc: ReportService) { }

  ngOnInit() {
    this.titleService.setTitle("Observations Tear Out Sheets - CSET");

    this.reportSvc.getReport('discoveries').subscribe(
      (r: any) => {
        this.response = r;
      },
      error => console.log('Discoveries Tear Out Sheets report load Error: ' + (<Error>error).message)
    );
  }

  /**
   * This generates an ID, but Angular doesn't support this kind of href link
   * so it won't work for production.
   * @param individual
   */
  private buildTocEntry(individual: any) {
    return "#indiv_" + individual.INDIVIDUALFULLNAME.replace(' ', '_');
  }
}
