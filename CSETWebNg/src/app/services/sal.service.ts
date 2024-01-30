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
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { NistSpecialFactor } from '../assessment/prepare/sals/sal-nist/nist-sal.models';
import { Sal } from '../models/sal.model';
import { ConfigService } from './config.service';
import { TranslocoService } from '@ngneat/transloco';

const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable()
export class SalService {

  apiUrlGenSal: string;
  apiUrl: string;

  public selectedSAL: Sal;


  levels: { value: string, imagepath: string }[] = [
    // eslint-disable-next-line max-len
    { value: 'Low', imagepath: 'm6.422,36.273c0.055,-16.495 13.442,-29.854 29.952,-29.854c16.509,0 29.896,13.358 29.951,29.854l6.422,0c-0.056,-20.041 -16.318,-36.273 -36.373,-36.273c-20.056,0 -36.318,16.232 -36.374,36.273l6.422,0zm34.387,-6.367c2.487,2.333 2.613,6.241 0.28,8.729c-2.332,2.489 -6.242,2.614 -8.729,0.281c-0.892,-0.836 -1.475,-1.876 -1.755,-2.98l-7.964,-14.6l15.082,7.011c1.12,0.208 2.195,0.724 3.087,1.56' },
    // eslint-disable-next-line max-len
    { value: 'Moderate', imagepath: 'M6.422 36.273C6.478 19.778 19.865 6.419 36.374 6.419 52.883 6.419 66.27 19.778 66.326 36.273L72.748 36.273C72.691 16.232 56.429 0 36.374 0 16.319 0 0.056 16.232 0 36.273zM42.284 34.508C42.284 37.918 39.519 40.683 36.108 40.683 32.698 40.683 29.932 37.918 29.932 34.508 29.932 33.284 30.293 32.147 30.906 31.188L36.108 15.391 41.311 31.188C41.924 32.147 42.284 33.284 42.284 34.508' },
    // eslint-disable-next-line max-len
    { value: 'High', imagepath: 'M6.422 36.273C6.478 19.778 19.865 6.419 36.374 6.419 52.883 6.419 66.27 19.778 66.326 36.273L72.748 36.273C72.691 16.232 56.429 0 36.374 0 16.319 0 0.056 16.232 0 36.273zM40.878 39.1C38.429 41.474 34.52 41.413 32.146 38.963 29.772 36.514 29.833 32.603 32.282 30.229 33.158 29.378 34.227 28.847 35.342 28.619L50.306 21.359 42.584 36.09C42.323 37.198 41.756 38.248 40.878 39.1' },
    // eslint-disable-next-line max-len
    { value: 'Very High', imagepath: 'M6.422 36.273C6.478 19.778 19.865 6.419 36.374 6.419 52.883 6.419 66.27 19.778 66.326 36.273L72.748 36.273C72.691 16.232 56.429 0 36.374 0 16.319 0 0.056 16.232 0 36.273zM36.294 41.026C32.884 40.992 30.147 38.2 30.182 34.789 30.216 31.379 33.008 28.64 36.418 28.676 37.641 28.686 38.775 29.06 39.728 29.682L55.472 35.042 39.623 40.085C38.657 40.691 37.518 41.039 36.294 41.026' }
  ];

  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    public tSvc: TranslocoService
  ) {
    this.apiUrl = this.configSvc.apiUrl + 'SAL';
    this.apiUrlGenSal = this.configSvc.apiUrl + 'GeneralSal';
  }

  saveSALType(newType: string): any {
    return this.http.get(this.apiUrl + '/Type?newType=' + newType);
  }

  /* note that the assessment id is baked into the security token */
  getSalSelection() {
    return this.http.get(this.apiUrl);
  }

  updateStandardSelection(sal: Sal): any {
    return this.http.post(this.apiUrl, sal, headers);
  }

  updateNistSpecialFactors(nistSal: NistSpecialFactor): any {
    return this.http.post(this.apiUrl + '/NistDataSpecialFactor', nistSal, headers);
  }

  getGenSalDescriptions(): any {
    return this.http.get(this.apiUrlGenSal + '/Descriptions');
  }

  getSaveGenSal(assessmentid: number, Slider_Value: number, slidername: string): any {
    const sw: SaveWeight = {
      assessmentid: assessmentid,
      Slider_Value: Slider_Value,
      slidername: slidername,
    };

    return this.http.post(this.apiUrlGenSal + '/SaveWeight', sw, { 'headers': headers.headers, params: headers.params, responseType: 'text' });
  }

  getInitialValue(): any {
    return this.http.get(this.apiUrlGenSal + '/Value');
  }

  getInformationTypes(): any {
    return this.http.get(this.apiUrl + '/NistData');
  }

  updateNistSalSelection(updateSal: any): any {
    return this.http.post(this.apiUrl + '/NistData', updateSal, headers);
  }

  updateNistDataQuestions(answer: any): any {
    return this.http.post(this.apiUrl + '/NistDataQuestions', answer, headers);
  }



  /**
   * Returns the svg imagepath to render the gauge
   * that corresponds to the specified level.
   * @param level
   */
  getImagePath(level: string): string {
    const lev = this.levels.find(l => l.value === level);
    if (lev != null) {
      return lev.imagepath;
    }
    return '';
  }

  /**
   * Returns the abbreviated version of a SAL level.
   * @param level
   */
  getSalAbbreviation(level: string): string {
    if (level === 'Moderate') {
      return 'Mod';
    }

    // for now, let's just try to fit the text
    return level;
  }

  /**
 * Primarily used to shorten the word MODERATE on NIST SAL grid
 * because it is too wide to display well on a phone.
 * 
 * Also translates to non-English if needed
 * @param level
 */
  getDisplayLevel(level: string): string {
    if (level === 'MODERATE') {
      level = 'MOD';
    }

    return this.tSvc.translate('titles.sal.nist.' + level.toLowerCase());
  }
}

export interface SaveWeight {
  assessmentid: number;
  Slider_Value: number;
  slidername: string;
}
