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
import { Title } from '@angular/platform-browser';
import { ConfigService } from '../../services/config.service';
import { ReportService } from '../../services/report.service';
import { TranslocoService } from '@ngneat/transloco';

@Component({
  selector: 'observations',
  templateUrl: './observation-tearouts.component.html',
  styleUrls: ['../reports.scss']
})
export class ObservationTearoutsComponent implements OnInit {

  response: any;

  /**
   * Constructor.
   * @param titleService
   * @param reportSvc
   */
  public constructor(
    private titleService: Title,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    private tSvc: TranslocoService
  ) { }

  ngOnInit() {
    this.reportSvc.getReport('observations').subscribe(
      (r: any) => {
        this.response = r;
        this.titleService.setTitle(this.tSvc.translate('reports.observations tear-out sheets.tab title', { defaultTitle: this.configSvc.behaviors.defaultTitle }));
      },
      error => console.log('Observation Tear Out Sheets report load Error: ' + (<Error>error).message)
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
