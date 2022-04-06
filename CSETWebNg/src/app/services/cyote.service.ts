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

import { Injectable } from '@angular/core';
import { ConfigService } from './config.service';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { AssessmentService } from './assessment.service';
import { Observable } from 'rxjs';
import { CyoteObservable } from '../models/cyote.model';

const headers = {
  headers: new HttpHeaders().set("Content-Type", "application/json"),
  params: new HttpParams()
};


@Injectable({
  providedIn: 'root'
})

export class CyoteService {

  apiUrl: string;
  defaultQuestions: any[];

  /**
   *
   * @param http
   * @param configSvc
   */
  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    private assessSvc: AssessmentService
  ) {
    this.apiUrl = this.configSvc.apiUrl + 'cyote/';
  }


  public meetsCyberEventThreshold = false;
  public additionalComments: '';

  /**
   * The list of observations for the current assessment
   */
  public anomalies: any[] = [];

  public nextAnomalyId: number = this.anomalies.length + 1;

  /**
   * 
   */
  getCyoteDetail() {
    return this.http.get(this.apiUrl + 'detail');
  }

  /**
   * 
   */
  saveObservable(observable: CyoteObservable) {
    return this.http.post(this.apiUrl + 'observable', observable);
  }

  /**
   * 
   */
  saveObservableSequence(observables: any[]) {
    return this.http.post(this.apiUrl + 'sequence', observables);
  }

  deleteObservable(observable: CyoteObservable) {
    this.http.get(this.apiUrl + "observable/delete?id=" + observable.observableId).subscribe();
  }


  /**
   * Returns a hard-coded object with a grouping/question/option structure
   */
  getDemoGroupings() {
    var resp =
      [{
        "groupType": "Section",
        "description": "",
        "abbreviation": null,
        "groupingId": 2314,
        "title": "",
        "groupings": [],
        "questions": [{
          "questionId": 5963,
          "questionType": null,
          "sequence": 1,
          "displayNumber": "",
          "questionText": "Where was this observed?",
          "answerText": null,
          "answerMemo": null,
          "referenceText": null,
          "parentQuestionId": null,
          "parentOptionId": null,
          "options": [{
            "optionId": 193,
            "optionType": "checkbox",
            "optionText": "Control Server",
            "sequence": 2,
            "weight": null,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": [
              {
                "questionId": 20000,
                "questionText": "You selected Control Server and indicated that this was a network related attack.<br>Please select the data sources you would most like to investigate?",
                "options": [
                  {
                    "optionId": 10014,
                    "optionType": "checkbox",
                    "optionText": "Network Traffic: Network Traffic Flow",
                    "selected": false,
                    "followups": [{
                      "questionText": "Which tool/datasource do you have access to?",
                      "options": [
                        {
                          "optionId": 10013,
                          "optionText": "NetFlow logs",
                          "optionType": "checkbox",
                          "selected": false,
                          "options": [
                            {
                              "optionId": 10012,
                              "optionText": "Does network or ICS network traffic appear unusually busy between network layers or devices?",
                              "optionType": "checkbox",
                              "selected": false,
                              "options": []
                            },
                            {
                              "optionId": 10011,
                              "optionText": "Is there any ICS process network traffic that appears unusually busy, either between devices, or across the ICS boundaries?",
                              "optionType": "checkbox",
                              "selected": false,
                              "options": []
                            },
                            {
                              "optionId": 10010,
                              "optionText": "Do you see inbound or outbound traffic between ICS network and any other network, including the internet?",
                              "optionType": "checkbox",
                              "selected": false,
                              "options": []
                            },
                            {
                              "optionId": 10009,
                              "optionText": "Have you checked for any queries to multiple sites via IP not DNS? Are there any anomalous inbound or outbound telnet, FTP, TFTP, HTTP, HTTPS to or from unknown IPs?",
                              "optionType": "checkbox",
                              "selected": false,
                              "options": []
                            },
                            {
                              "optionId": 10008,
                              "optionText": "Is there any ICS process network traffic that appears unusually busy, either between devices or across the ICS boundaries?",
                              "optionType": "checkbox",
                              "selected": false,
                              "options": []
                            },
                            {
                              "optionId": 10007,
                              "optionText": "Is there any inbound or outbound traffic from unknown IP addresses?",
                              "optionType": "checkbox",
                              "selected": false,
                              "options": [],
                              "followups": [
                                {
                                  "questionText": "Unfamiliar IP addresses noted in NetFlow logs<div class='ml-4'><a href='" 
                                    + this.configSvc.docUrl + "CyOTE/T843-Program-Download-Technique-Detection-Capability-Sheet.pdf' target='_blank'>" 
                                    + "TECHNIQUE T843: Program Download Technique Detection Capability</a><div><strong>Yes, we think you should investigate further</strong></div><div style='border: 2px solid black; padding: .5rem; margin: .5rem 0'>Please provide comments and list unknown IPs and date times of observation if known. Include suficient information that an analyst could follow up and reach your findings.</div></div>",
                                  "options": [
                                    {
                                      "optionId": 10006,
                                      "optionText": "Can you determine what process is generating the traffic?",
                                      "optionType": "checkbox"
                                    }
                                  ]
                                }
                              ]
                            },
                          ]
                        },
                        {
                          "optionId": 10005,
                          "optionText": "Network Protocol Analysis",
                          "optionType": "checkbox",
                          "selected": false,
                          "options": []
                        },
                        {
                          "optionId": 10004,
                          "optionText": "Network Traffic Analyzer",
                          "optionType": "checkbox",
                          "selected": false,
                          "options": []
                        }]
                    }
                    ]
                  },
                  {
                    "optionId": 10003,
                    "optionType": "checkbox",
                    "optionText": "Network Share: Network Share Access",
                    "selected": false
                  },
                  {
                    "optionId": 10002,
                    "optionType": "checkbox",
                    "optionText": "Network Traffic: Network Connection Creation",
                    "selected": false
                  },
                  {
                    "optionId": 10001,
                    "optionType": "checkbox",
                    "optionText": "Network Traffic: Network Traffic Content",
                    "selected": false
                  }
                ]
              }
            ]
          }, {
            "optionId": 194,
            "optionType": "checkbox",
            "optionText": "Data Historian",
            "sequence": 3,
            "weight": null,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": []
          }, {
            "optionId": 165,
            "optionType": "checkbox",
            "optionText": "Device Configuration/Parameters",
            "sequence": 4,
            "weight": null,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": []
          }, {
            "optionId": 173,
            "optionType": "checkbox",
            "optionText": "Engineering Workstation",
            "sequence": 5,
            "weight": null,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": []
          },
          {
            "optionId": 8173,
            "optionType": "checkbox",
            "optionText": "Field Controller/RTU/PLC/IED",
            "sequence": 5,
            "weight": null,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": []
          },
          {
            "optionId": 8174,
            "optionType": "checkbox",
            "optionText": "Human-Machine Interface",
            "sequence": 5,
            "weight": null,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": []
          },
          {
            "optionId": 8175,
            "optionType": "checkbox",
            "optionText": "Input/Output Server",
            "sequence": 5,
            "weight": null,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": []
          },
          {
            "optionId": 8176,
            "optionType": "checkbox",
            "optionText": "Protection Relay",
            "sequence": 5,
            "weight": null,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": []
          },
          {
            "optionId": 8177,
            "optionType": "checkbox",
            "optionText": "Safety Instrumented System",
            "sequence": 5,
            "weight": null,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": []
          },
          {
            "optionId": 8178,
            "optionType": "checkbox",
            "optionText": "Windows",
            "sequence": 5,
            "weight": null,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": []
          },
          {
            "optionId": 195,
            "optionType": "checkbox",
            "optionText": "None of the above",
            "sequence": 6,
            "weight": null,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": []
          }
          ],
          "followups": []
        }]
      }
      ];
    return resp;
  }
}