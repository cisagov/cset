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
import { Injectable } from '@angular/core';
import { HttpHeaders, HttpParams, HttpClient } from '@angular/common/http';
import { ConfigService } from './config.service';
import { AssessmentService } from './assessment.service';
import { Domain } from '../models/questions.model';


const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

export class ACETFilter {
  DomainName: string;
  DomainId: number;
  B: boolean;
  E: boolean;
  Int: boolean;
  A: boolean;
  Inn: boolean;
}

@Injectable({
  providedIn: 'root'
})
export class AcetFiltersService {



  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    private assessmentSvc: AssessmentService
  ) {

  }

  getACETDomains() {
    return this.http.get(this.configSvc.apiUrl + 'ACETDomains');
  }

  getFilters() {
    return this.http.get(this.configSvc.apiUrl + 'GetAcetFilters');
  }

  saveFilter(domainName: string, f: string, e: any) {

    const filter = { DomainName: domainName, Field: f, Value: e };
    return this.http.post(this.configSvc.apiUrl + 'SaveAcetFilter', filter, headers);
  }

  saveFilters(filters: Map<string, Map<string, boolean>>) {
    const saveValue: ACETFilter[] = [];

    for (const entry of Array.from(filters.entries())) {
      const x: ACETFilter = new ACETFilter();
      x.DomainName = entry[0];
      x.DomainId = 0;
      x.B = entry[1].get('B');
      x.E = entry[1].get('E');
      x.Int = entry[1].get('Int');
      x.A = entry[1].get('A');
      x.Inn = entry[1].get('Inn');
      saveValue.push(x);
    }

    return this.http.post(this.configSvc.apiUrl + 'SaveAcetFilters', saveValue, headers);
  }
}

