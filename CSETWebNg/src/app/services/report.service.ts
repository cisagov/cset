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
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ConfigService } from './config.service';

const headers = {
    headers: new HttpHeaders()
        .set('Content-Type', 'application/json'),
    params: new HttpParams()
};
@Injectable()
export class ReportService {

    private initialized = false;
    private apiUrl: string;
    private reportsUrl: string;
    public hasACET: boolean = false;

    /**
     *
     */
    constructor(private http: HttpClient, private configSvc: ConfigService) {
        if (!this.initialized) {
            this.apiUrl = this.configSvc.apiUrl;
            this.reportsUrl = this.configSvc.reportsUrl;
            this.initialized = true;
        }
    }

    /**
     * Calls the GetReport API method and returns an Observable.
     */
    public getReport(reportId: string) {
        return this.http.get(this.apiUrl + 'reports/' + reportId);
    }

    public getPdf(pdfString: string) {
        return this.http
          .get(
            this.reportsUrl + 'getPdf?view='+ pdfString,
            {responseType:"blob", headers: headers.headers, params: headers.params}
          );
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
    getACET() {
        return this.http.get(this.configSvc.apiUrl + "standard/IsACET");
    }

    /**
     *
     */
    getNetworkDiagramImage(): any {
        
        return this.http.get(this.configSvc.apiUrl + 'diagram/getimage');
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
        const pieces = text.split("\n");
        let divs: string = "";
        pieces.forEach(p => {
            if (p.trim() !== '') {
                p = "<div>" + p + "</div>";
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
          pieces.forEach(x => {
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
}
