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
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ConfigService } from './config.service';
import { firstValueFrom, Observable } from 'rxjs';
import { TranslocoService } from '@jsverse/transloco';

const headers = {
  headers: new HttpHeaders().set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable({
  providedIn: 'root'
})
export class CreService {

  public colorScheme = {
    domain: ['#5AA454', '#367190', '#b17300', '#DC3545', '#EEEEEE']
  }

  public milPercentScheme = {
    domain: ['#367190', '#4D89A6', '#66A1BC', '#80BAD2', '#99D2E8']
  }

  /**
   * 
   */
  constructor(
    private configSvc: ConfigService,
    private tSvc: TranslocoService,
    private http: HttpClient
  ) { }

  /*************
  Label and tooltip formatting functions 
  ***************/

  fmt1 = (value) => {
    return `${Math.round(value)}%`;
  };

  fmt3 = (obj) => {
    return `${obj.data.name}<br>${Math.round(obj.data.value)}%`;
  }



  /**
   * 
   */
  getAllAnswerDistrib(modelIds: number[]): Observable<any[]> {
    return this.http.get<any[]>(this.configSvc.apiUrl + `chart/maturity/answerdistribs/all?modelIds=${modelIds.join('|')}`);
  }

  /**
   * 
   */
  getDomainAnswerDistrib(modelIds: number[]): Observable<any[]> {
    return this.http.get<any[]>(this.configSvc.apiUrl + `chart/maturity/answerdistrib/domain?modelIds=${modelIds.join('|')}`);
  }

  /**
   * 
   */
  getDistribForModel(modelId: number): Observable<any[]> {
    return this.http.get<any[]>(this.configSvc.apiUrl + `chart/maturity/answerdistrib/model?modelId=${modelId}`);
  }


  /**
   * Gets the number of selected Goals or MILs for a CRE assessment.  This is intended
   * to be a quick way to decide sections of the CRE report to show/hide.
   */
  getSelectedGoalMilCount(modelId: number): Observable<number> {
    return this.http.get<number>(this.configSvc.apiUrl + `chart/maturity/goalcount?modelId=${modelId}`);
  }




  /**
   * Get the full answer distribution response from the API.
   * This contains all active domains and goals (subgroupings) for the model.
   */
  async getFullDistrib(modelId: number): Promise<any[]> {
    let resp = await firstValueFrom(this.getDistribForModel(modelId)) || [];

    resp.forEach(domain => {
      domain.subgroups.forEach(mil => {
        // shorten the label
        let i = mil.name.indexOf('-');
        mil.name = i !== -1 ? mil.name.substring(0, i).trim() : mil.name;

        this.translateAnswerOptions(modelId, mil.series);
      });
    });

    return resp;
  }

  /**
   * Gets the MIL model (24) and the Core model (22).  
   * Inserts the Core domain distributions into the MIL
   * model as "MIL1".
   */
  async getMilIncludingMil1(): Promise<any[]> {
    let list = await this.getFullDistrib(24);

    const mil1List = await firstValueFrom(this.getDomainAnswerDistrib([22]));
    mil1List.forEach(element => {
      this.translateAnswerOptions(22, element.series);
    });

    // insert the core distrib into the response as "MIL1"
    list.forEach(dom => {
      const mil1equivalent = mil1List.find(x => x.name == dom.name);
      dom.subgroups.unshift({ name: 'MIL1', series: mil1equivalent.series });
    });

    return list;
  }

  /**
   * Translate the answer option labels to their display values
   */
  translateAnswerOptions(modelId: number, items: any[]) {
    var behavior = this.configSvc.getModuleBehavior(modelId);
    var opts = behavior.answerOptions;

    items.forEach(ansCount => {
      const key = opts?.find(x => x.code === ansCount.name)?.buttonLabelKey.toLowerCase() ?? 'u';
      ansCount.name = this.tSvc.translate('answer-options.labels.' + key);
    });
  }
}
