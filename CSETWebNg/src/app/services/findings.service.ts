////////////////////////////////
//
//   Copyright 2019 Battelle Energy Alliance, LLC
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
import { String, StringBuilder } from 'typescript-string-operations';
import { Finding } from './../assessment/questions/findings/findings.model';
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { ConfigService } from './config.service';

const headers = {
  headers: new HttpHeaders()
      .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable({
  providedIn: 'root'
})
export class FindingsService {



  constructor(private http: HttpClient, private configSvc: ConfigService) {
  }


  GetImportance(): any {
    const qstring = this.configSvc.apiUrl + 'GetImportance';
    return this.http.get(qstring, headers);
  }

  GetFinding(answer_id: number, finding_id: number, Question_Id: number) {
    if (answer_id == null) { answer_id = 0; }
    const qstring = this.configSvc.apiUrl + 'GetFinding?Answer_Id=' + answer_id
      + '&Finding_Id=' + finding_id + '&Question_Id=' + Question_Id;
    return this.http.post(qstring, headers);
  }
  /**
   * retrieves all the discoveries
   */
  getAllDiscoveries(answer_id: number) {
    const qstring = 'AnswerAllDiscoveries?Answer_Id=' + answer_id;
    return this.http.post(this.configSvc.apiUrl + qstring, headers);
  }

  /**
   * saves the given discovery
   */
  SaveDiscovery(finding: Finding) {
    return this.http.post(this.configSvc.apiUrl + 'AnswerSaveDiscovery', finding, headers);
  }

  deleteFinding(findingId: number): any {
    return this.http.post(this.configSvc.apiUrl + 'DeleteFinding', findingId,  headers);
  }
}
