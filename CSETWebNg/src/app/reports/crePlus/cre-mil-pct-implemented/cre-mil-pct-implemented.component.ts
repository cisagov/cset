////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
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
import { CreService } from '../../../services/cre.service';
import { ConfigService } from '../../../services/config.service';
import { TranslocoService } from '@jsverse/transloco';
import { firstValueFrom } from 'rxjs';

@Component({
  selector: 'app-cre-mil-pct-implemented',
  standalone: false,
  templateUrl: './cre-mil-pct-implemented.component.html',
  styleUrls: ['../../reports.scss', './cre-mil-pct-implemented.component.scss']
})
export class CreMilPctImplementedComponent implements OnInit {

  newList: any[];


  /**
   * 
   */
  constructor(
    public creSvc: CreService,
    public configSvc: ConfigService,
    public tSvc: TranslocoService
  ) { }

  /**
   * 
   */
  async ngOnInit(): Promise<void> {
    //const origList = await this.getFullModel(24);

    const origList = await this.creSvc.getMilIncludingMil1();

    this.newList = this.convertData(origList);
  }


  /**
   * Builds an object that the chart can use to display the MIL values
   */
  convertData(data: any[]): any[] {
    const top: any[] = [];

    for (let domain of data) {
      const newDom = { name: domain.name, series: [] as { name: string; value: number }[] };

      for (let mil of domain.subgroups) {
        newDom.series.push({ name: mil.name, value: mil.series[0].value });
      }

      top.push(newDom);
    }

    return top;
  }

  /**
   * 
   */
  calcHeight(s) {
    return Math.max(180, s * 100);
  }
}
