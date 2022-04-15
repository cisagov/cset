////////////////////////////////
//
//   Copyright 2022 Battelle Energy Alliance, LLC
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
import { ConfigService } from './config.service';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { AssessmentService } from './assessment.service';
import { Answer } from '../models/questions.model';
import { of as observableOf, BehaviorSubject, Observable, of } from "rxjs";
const headers = {
  headers: new HttpHeaders().set("Content-Type", "application/json"),
  params: new HttpParams()
};

@Injectable({
  providedIn: 'root'
})
export class CisService {

  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    public assessSvc: AssessmentService
  ) { }


  /**
   * Builds and returns the list of CIS subnodes for navigation
   */
  cisSubnodeList$ = new Observable((observer) => {
    var list = [];
    this.getCisSubnodes().subscribe((data: any) => {
      data.forEach(n => {
        let ccc = {
          displayText: n.title,
          pageId: 'maturity-questions-nested-' + n.id,
          level: n.level,
          path: 'assessment/{:id}/maturity-questions-nested/' + n.id,
          condition: 'MATURITY-CIST'
        }

        // remove the path of 'parent' nodes to prevent direct navigation to them
        if (n.hasChildren) {
          Reflect.deleteProperty(ccc, 'path');
        }

        list.push(ccc);
      });

      observer.next(list);
    });
  })
  
  /**
   * Gets the CIS structure from the API.
   */
  getCisSubnodes() {
    return this.http.get(this.configSvc.apiUrl + 'maturity/cis/navstruct');
  }

  /**
   * 
   */
  getCisSection(sectionId: Number) {
    return this.http.get(this.configSvc.apiUrl + 'maturity/cis/questions?sectionId=' + sectionId);
  }


  /**
   * Sends a single answer to the API to be persisted.  
   */
  storeAnswer(answer: Answer) {
    answer.questionType = localStorage.getItem('questionSet');
    return this.http.post(this.configSvc.apiUrl + 'answerquestion', answer, headers);
  }

  /**
   * Sends a group of answers to the API to be persisted.  
   */
  storeAnswers(answers: Answer[], sectionId:number) {
    return this.http.post(this.configSvc.apiUrl + 'answerquestions?sectionId='+sectionId, answers, headers);
  }


  /// The service can emit the score that is given to it
  cisScore: BehaviorSubject<number> = new BehaviorSubject(0);
  changeScore(s: number) {
    this.cisScore.next(s);
  }
}
