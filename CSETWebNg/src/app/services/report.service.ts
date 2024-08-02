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
import { ConfigService } from './config.service';
import { TranslocoService } from '@ngneat/transloco';
import { AuthenticationService } from './authentication.service';
import { JwtParser } from '../helpers/jwt-parser';
import { DateTime } from 'luxon';
import { ConfigurableFocusTrap } from '@angular/cdk/a11y';
import { AssessmentService } from './assessment.service';
// import { NCUAService } from './ncua.service';
import { ACETService } from './acet.service';
import { ObservationsService } from './observations.service';

const headers = {
  headers: new HttpHeaders().set('Content-Type', 'application/json'),
  params: new HttpParams()
};
@Injectable()
export class ReportService {
  private initialized = false;
  private apiUrl: string;

  confidentialityLevels: any[];
  confidentiality = '';

  disableIseReportLinks: boolean = false;

  /**
   *
   */
  constructor(private http: HttpClient, 
    private configSvc: ConfigService, private tSvc: TranslocoService,
    private authSvc: AuthenticationService
  ) {
    if (!this.initialized) {
      this.apiUrl = this.configSvc.apiUrl;
      this.initialized = true;
    }

    this.getConfidentialityLevels().subscribe((x: any) => {
      this.confidentialityLevels = x;
    });
  }

  /**
   * 
   */
  public getConfidentialityLevels() {
    return this.http.get(this.apiUrl + 'reports/getconfidentialtypes');
  }

  /**
   *
   */
  isInstallation(mode: string): boolean {
    return this.configSvc.installationMode == mode;
  }

  /**
   * Calls the GetReport API method and returns an Observable.
   */
  public getReport(reportId: string) {
    return this.http.get(this.apiUrl + 'reports/' + reportId);
  }

  /**
   * Calls the API to get basic information about the assessment for a report
   */
  public getAssessmentInfoForReport() {
    return this.http.get(this.apiUrl + 'reports/info');
  }

  public getAggReport(reportId: string, aggId: number) {
    return this.http.get(this.apiUrl + 'reports/' + reportId + '?aggregationID=' + aggId);
  }

  public getPdf(pdfString: string, security: string) {
    return this.http.get(this.apiUrl + 'getPdf?view=' + pdfString + '&security=' + security, {
      responseType: 'blob',
      headers: headers.headers,
      params: headers.params
    });
  }

  /**
   * Calls the getAltList API endpoint to get all ALT answer justifications for the assessment.
   * @returns
   */
  getAltList() {
    return this.http.get(this.apiUrl + 'reports/getAltList', headers);
  }

  /**
   *
   */
  getNetworkDiagramImage(): any {
    return this.http.get(this.configSvc.apiUrl + 'diagram/getimage');
  }

  /**
   *
   */
  getCRRSummary(): any {
    this.http.get(this.configSvc.apiUrl + 'diagram/getimage').subscribe((val) => console.log(val));
    return this.http.get(this.configSvc.apiUrl + 'diagram/getimage');
  }

  /**
   *
   */
  getHydroActionItemsReport() {
    return this.http.get(this.configSvc.apiUrl + 'reports/getHydroActionItemsReport', headers);
  }

  /**
   * Calls the API to get the structure of a SET.
   */
  getModuleContent(setName: string): any {
    return this.http.get(this.configSvc.apiUrl + 'reports/modulecontent?set=' + setName);
  }

  /**
   * Calls the API to get the structure of a (maturity) model.
   */
  getModelContent(modelId: string): any {
    return this.http.get(this.configSvc.apiUrl + 'maturity/structure?modelId=' + modelId);
  }

  /**
   * Opens a new window/tab
   */
  clickReportLink(reportType: string, print: boolean = false) {
    const url = '/index.html?returnPath=report/' + reportType;
    localStorage.setItem('REPORT-' + reportType.toUpperCase(), print.toString());
    localStorage.setItem('report-confidentiality', this.confidentiality);
    window.open(url, '_blank');
  }

  /**
   * Converts linebreak characters to HTML <br> tag.
   */
  formatLinebreaks(text: string) {
    if (!text) {
      return '';
    }
    return text.replace(/(?:\r\n|\r|\n)/g, '<br />');
  }

  /**
   * Split paragraphs into divs
   */
  public fixWarningNewlines(text: string) {
    const pieces = text.split('\n');
    let divs: string = '';
    pieces.forEach((p) => {
      if (p.trim() !== '') {
        p = '<div>' + p + '</div>';
        divs += p;
      }
    });
    return divs;
  }

  /**
   * Returns question text that has been scrubbed of glossary markup.
   */
  public scrubGlossaryMarkup(questionText: string): string {
    if (!questionText) {
      return '';
    }

    if (questionText.indexOf('[[') < 0) {
      return questionText;
    }

    // we have one or more glossary terms; mediate them
    let s = '';

    const pieces = questionText.split(']]');
    pieces.forEach((x) => {
      const startBracketPos = x.lastIndexOf('[[');
      if (startBracketPos >= 0) {
        const leadingText = x.substring(0, startBracketPos);
        let term = x.substring(startBracketPos + 2);
        let displayWord = term;

        if (term.indexOf('|') > 0) {
          const p = term.split('|');
          term = p[0];
          displayWord = p[1];
        }

        s += leadingText;
        s += displayWord;
      } else {
        // no starter bracket, just dump the whole thing
        s += x;
      }
    });

    return s;
  }

  getC2M2Donuts() {
    return this.http.get(this.configSvc.apiUrl + 'c2m2/donutheatmap');
  }

  getC2M2TableData() {
    return this.http.get(this.configSvc.apiUrl + 'c2m2/questionTable');
  }

  validateCisaAssessorFields() {
    return this.http.get(this.configSvc.apiUrl + 'reports/CisaAssessorWorkflowValidateFields');
  }

  applyJwtOffset(d: DateTime, format: string) {
    const jwt = new JwtParser();
    const parsedToken = jwt.decodeToken(this.authSvc.userToken());
    let t = DateTime.fromISO(d.toString());
    t = t.plus({ minute: t.offset });

    if (format == 'date') {
      return t.setLocale(this.tSvc.getActiveLang()).toLocaleString(DateTime.DATE_SHORT);
    }
    else {
      return t.setLocale(this.tSvc.getActiveLang()).toLocaleString(DateTime.DATETIME_SHORT_WITH_SECONDS);
    }
  }

  /**
   * Switches that define what to show on Module Content Reports
   */
  public showGuidance = true;
  public showReferences = true;
  public showQuestions = true;
}
