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
        "title": "Personnel",
        "groupings": [],
        "questions": [{
          "questionId": 5963,
          "questionType": null,
          "sequence": 1,
          "displayNumber": "",
          "questionText": "14.1 Are the following positions formalized? (Check all that apply.)",
          "answerText": null,
          "answerMemo": null,
          "referenceText": null,
          "parentQuestionId": null,
          "parentOptionId": null,
          "options": [],
          "followups": [{
            "questionId": 6056,
            "questionType": null,
            "sequence": 1,
            "displayNumber": "",
            "questionText": "<b>Within your organization,</b>",
            "answerText": null,
            "answerMemo": null,
            "referenceText": null,
            "parentQuestionId": 5963,
            "parentOptionId": null,
            "options": [{
              "optionId": 193,
              "optionType": "Checkbox",
              "optionText": "Cybersecurity Policy and Planning Coordinator",
              "sequence": 2,
              "weight": null,
              "selected": false,
              "hasAnswerText": false,
              "answerText": null,
              "followups": []
            }, {
              "optionId": 194,
              "optionType": "Checkbox",
              "optionText": "Cybersecurity Training Official",
              "sequence": 3,
              "weight": null,
              "selected": false,
              "hasAnswerText": false,
              "answerText": null,
              "followups": []
            }, {
              "optionId": 165,
              "optionType": "Checkbox",
              "optionText": "Cybersecurity Incident Response Team Lead/Incident Commander",
              "sequence": 4,
              "weight": null,
              "selected": false,
              "hasAnswerText": false,
              "answerText": null,
              "followups": []
            }, {
              "optionId": 173,
              "optionType": "Checkbox",
              "optionText": "CERT Staff/Triage Staff (Incident Responder)",
              "sequence": 5,
              "weight": null,
              "selected": false,
              "hasAnswerText": false,
              "answerText": null,
              "followups": []
            }, {
              "optionId": 195,
              "optionType": "Checkbox",
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
          }, {
            "questionId": 6057,
            "questionType": null,
            "sequence": 1,
            "displayNumber": "",
            "questionText": "<b>Within the CCS environment,</b>",
            "answerText": null,
            "answerMemo": null,
            "referenceText": null,
            "parentQuestionId": 5963,
            "parentOptionId": null,
            "options": [{
              "optionId": 196,
              "optionType": "Checkbox",
              "optionText": "Cybersecurity Exercise Official",
              "sequence": 8,
              "weight": null,
              "selected": false,
              "hasAnswerText": false,
              "answerText": null,
              "followups": []
            }, {
              "optionId": 197,
              "optionType": "Checkbox",
              "optionText": "Security Operations Personnel (i.e., Security Administrators, Security Analysts)",
              "sequence": 9,
              "weight": null,
              "selected": false,
              "hasAnswerText": false,
              "answerText": null,
              "followups": []
            }, {
              "optionId": 198,
              "optionType": "Checkbox",
              "optionText": "Cybersecurity Threat Coordinator",
              "sequence": 10,
              "weight": null,
              "selected": false,
              "hasAnswerText": false,
              "answerText": null,
              "followups": []
            }, {
              "optionId": 199,
              "optionType": "Checkbox",
              "optionText": "IT Controls and Compliance Staff",
              "sequence": 11,
              "weight": null,
              "selected": false,
              "hasAnswerText": false,
              "answerText": null,
              "followups": []
            }, {
              "optionId": 200,
              "optionType": "Checkbox",
              "optionText": "Security Architect",
              "sequence": 12,
              "weight": null,
              "selected": false,
              "hasAnswerText": false,
              "answerText": null,
              "followups": []
            }, {
              "optionId": 201,
              "optionType": "Checkbox",
              "optionText": "Application Administrator/System Administrator",
              "sequence": 13,
              "weight": null,
              "selected": false,
              "hasAnswerText": false,
              "answerText": null,
              "followups": []
            }, {
              "optionId": 202,
              "optionType": "Checkbox",
              "optionText": "None of the above",
              "sequence": 14,
              "weight": null,
              "selected": false,
              "hasAnswerText": false,
              "answerText": null,
              "followups": []
            }
            ],
            "followups": []
          }
          ]
        }, {
          "questionId": 5964,
          "questionType": "LEGACY",
          "sequence": 2,
          "displayNumber": "",
          "questionText": "14.2 Do you have a policy that authorizes and holds accountable the personnel having these assignments?",
          "answerText": null,
          "answerMemo": null,
          "referenceText": null,
          "parentQuestionId": null,
          "parentOptionId": null,
          "options": [{
            "optionId": 650,
            "optionType": "Radio",
            "optionText": "No",
            "sequence": 1,
            "weight": 0.0,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": []
          }, {
            "optionId": 651,
            "optionType": "Radio",
            "optionText": "Yes",
            "sequence": 2,
            "weight": 100.0,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": []
          }
          ],
          "followups": []
        }, {
          "questionId": 5965,
          "questionType": "LEGACY",
          "sequence": 3,
          "displayNumber": "",
          "questionText": "14.3 Are background checks conducted for organizational and supporting personnel?",
          "answerText": null,
          "answerMemo": null,
          "referenceText": null,
          "parentQuestionId": null,
          "parentOptionId": null,
          "options": [{
            "optionId": 652,
            "optionType": "Radio",
            "optionText": "No",
            "sequence": 1,
            "weight": 73.0,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": []
          }, {
            "optionId": 653,
            "optionType": "Radio",
            "optionText": "Yes",
            "sequence": 2,
            "weight": 80.0,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": [{
              "questionId": 6139,
              "questionType": null,
              "sequence": 3,
              "displayNumber": "",
              "questionText": "<b>On whom are background checks conducted:</b>",
              "answerText": null,
              "answerMemo": null,
              "referenceText": null,
              "parentQuestionId": 5965,
              "parentOptionId": 653,
              "options": [],
              "followups": [{
                "questionId": 6140,
                "questionType": null,
                "sequence": 1,
                "displayNumber": "",
                "questionText": "Organizational cybersecurity personnel?",
                "answerText": null,
                "answerMemo": null,
                "referenceText": null,
                "parentQuestionId": 6139,
                "parentOptionId": null,
                "options": [{
                  "optionId": 834,
                  "optionType": "Radio",
                  "optionText": "N/A",
                  "sequence": 1,
                  "weight": null,
                  "selected": false,
                  "hasAnswerText": false,
                  "answerText": null,
                  "followups": []
                }, {
                  "optionId": 835,
                  "optionType": "Radio",
                  "optionText": "No",
                  "sequence": 2,
                  "weight": null,
                  "selected": false,
                  "hasAnswerText": false,
                  "answerText": null,
                  "followups": []
                }, {
                  "optionId": 836,
                  "optionType": "Radio",
                  "optionText": "Yes",
                  "sequence": 3,
                  "weight": null,
                  "selected": false,
                  "hasAnswerText": false,
                  "answerText": null,
                  "followups": [{
                    "questionId": 6141,
                    "questionType": null,
                    "sequence": 3,
                    "displayNumber": "",
                    "questionText": "Are recurring periodic background checks conducted?",
                    "answerText": null,
                    "answerMemo": null,
                    "referenceText": null,
                    "parentQuestionId": 6140,
                    "parentOptionId": 836,
                    "options": [{
                      "optionId": 837,
                      "optionType": "Radio",
                      "optionText": "No",
                      "sequence": 1,
                      "weight": null,
                      "selected": false,
                      "hasAnswerText": false,
                      "answerText": null,
                      "followups": []
                    }, {
                      "optionId": 838,
                      "optionType": "Radio",
                      "optionText": "Yes",
                      "sequence": 2,
                      "weight": null,
                      "selected": false,
                      "hasAnswerText": false,
                      "answerText": null,
                      "followups": []
                    }
                    ],
                    "followups": []
                  }
                  ]
                }
                ],
                "followups": []
              }, {
                "questionId": 6142,
                "questionType": null,
                "sequence": 2,
                "displayNumber": "",
                "questionText": "Contract cybersecurity personnel?",
                "answerText": null,
                "answerMemo": null,
                "referenceText": null,
                "parentQuestionId": 6139,
                "parentOptionId": null,
                "options": [{
                  "optionId": 839,
                  "optionType": "Radio",
                  "optionText": "N/A",
                  "sequence": 1,
                  "weight": null,
                  "selected": false,
                  "hasAnswerText": false,
                  "answerText": null,
                  "followups": []
                }, {
                  "optionId": 840,
                  "optionType": "Radio",
                  "optionText": "No",
                  "sequence": 2,
                  "weight": null,
                  "selected": false,
                  "hasAnswerText": false,
                  "answerText": null,
                  "followups": []
                }, {
                  "optionId": 841,
                  "optionType": "Radio",
                  "optionText": "Yes",
                  "sequence": 3,
                  "weight": null,
                  "selected": false,
                  "hasAnswerText": false,
                  "answerText": null,
                  "followups": [{
                    "questionId": 6143,
                    "questionType": null,
                    "sequence": 3,
                    "displayNumber": "",
                    "questionText": "Are recurring periodic background checks conducted?",
                    "answerText": null,
                    "answerMemo": null,
                    "referenceText": null,
                    "parentQuestionId": 6142,
                    "parentOptionId": 841,
                    "options": [{
                      "optionId": 842,
                      "optionType": "Radio",
                      "optionText": "No",
                      "sequence": 1,
                      "weight": null,
                      "selected": false,
                      "hasAnswerText": false,
                      "answerText": null,
                      "followups": []
                    }, {
                      "optionId": 843,
                      "optionType": "Radio",
                      "optionText": "Yes",
                      "sequence": 2,
                      "weight": null,
                      "selected": false,
                      "hasAnswerText": false,
                      "answerText": null,
                      "followups": []
                    }
                    ],
                    "followups": []
                  }
                  ]
                }
                ],
                "followups": []
              }, {
                "questionId": 6144,
                "questionType": null,
                "sequence": 3,
                "displayNumber": "",
                "questionText": "Cybersecurity Vendors?",
                "answerText": null,
                "answerMemo": null,
                "referenceText": null,
                "parentQuestionId": 6139,
                "parentOptionId": null,
                "options": [{
                  "optionId": 844,
                  "optionType": "Radio",
                  "optionText": "N/A",
                  "sequence": 1,
                  "weight": null,
                  "selected": false,
                  "hasAnswerText": false,
                  "answerText": null,
                  "followups": []
                }, {
                  "optionId": 845,
                  "optionType": "Radio",
                  "optionText": "No",
                  "sequence": 2,
                  "weight": null,
                  "selected": false,
                  "hasAnswerText": false,
                  "answerText": null,
                  "followups": []
                }, {
                  "optionId": 846,
                  "optionType": "Radio",
                  "optionText": "Yes",
                  "sequence": 3,
                  "weight": null,
                  "selected": false,
                  "hasAnswerText": false,
                  "answerText": null,
                  "followups": [{
                    "questionId": 6145,
                    "questionType": null,
                    "sequence": 3,
                    "displayNumber": "",
                    "questionText": "Are recurring periodic background checks conducted?",
                    "answerText": null,
                    "answerMemo": null,
                    "referenceText": null,
                    "parentQuestionId": 6144,
                    "parentOptionId": 846,
                    "options": [{
                      "optionId": 847,
                      "optionType": "Radio",
                      "optionText": "No",
                      "sequence": 1,
                      "weight": null,
                      "selected": false,
                      "hasAnswerText": false,
                      "answerText": null,
                      "followups": []
                    }, {
                      "optionId": 848,
                      "optionType": "Radio",
                      "optionText": "Yes",
                      "sequence": 2,
                      "weight": null,
                      "selected": false,
                      "hasAnswerText": false,
                      "answerText": null,
                      "followups": []
                    }
                    ],
                    "followups": []
                  }
                  ]
                }
                ],
                "followups": []
              }
              ]
            }
            ]
          }
          ],
          "followups": []
        }, {
          "questionId": 5966,
          "questionType": "MEMO",
          "sequence": 4,
          "displayNumber": "",
          "questionText": "14.4 Personnel Briefing Notes:",
          "answerText": null,
          "answerMemo": null,
          "referenceText": null,
          "parentQuestionId": null,
          "parentOptionId": null,
          "options": [],
          "followups": []
        }, {
          "questionId": 5967,
          "questionType": "MEMO",
          "sequence": 5,
          "displayNumber": "",
          "questionText": "14.5 Personnel Comments:",
          "answerText": null,
          "answerMemo": null,
          "referenceText": null,
          "parentQuestionId": null,
          "parentOptionId": null,
          "options": [],
          "followups": []
        }
        ]
      }, {
        "groupType": "Section",
        "description": "",
        "abbreviation": null,
        "groupingId": 2315,
        "title": "Cybersecurity Training",
        "groupings": [],
        "questions": [{
          "questionId": 5968,
          "questionType": "LEGACY",
          "sequence": 1,
          "displayNumber": "",
          "questionText": "15.1 Do cybersecurity personnel involved in day-to-day CCS operations receive cybersecurity training?",
          "answerText": null,
          "answerMemo": null,
          "referenceText": null,
          "parentQuestionId": null,
          "parentOptionId": null,
          "options": [{
            "optionId": 654,
            "optionType": "Radio",
            "optionText": "No",
            "sequence": 1,
            "weight": 0.0,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": []
          }, {
            "optionId": 655,
            "optionType": "Radio",
            "optionText": "Yes",
            "sequence": 2,
            "weight": 0.0,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": [{
              "questionId": 6058,
              "questionType": null,
              "sequence": 1,
              "displayNumber": "",
              "questionText": "The basis of the training programs are: (Check all that apply)",
              "answerText": null,
              "answerMemo": null,
              "referenceText": null,
              "parentQuestionId": null,
              "parentOptionId": 655,
              "options": [{
                "optionId": 203,
                "optionType": "Checkbox",
                "optionText": "Industry-recognized body of knowledge (e.g., ISO 27001)",
                "sequence": 4,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 204,
                "optionType": "Checkbox",
                "optionText": "In-house/Formal cybersecurity operations requirements",
                "sequence": 5,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 205,
                "optionType": "Checkbox",
                "optionText": "In-house/Informal cybersecurity operations requirements",
                "sequence": 6,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 206,
                "optionType": "Checkbox",
                "optionText": "Government-recognized body of knowledge",
                "sequence": 7,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 207,
                "optionType": "Checkbox",
                "optionText": "No basis",
                "sequence": 8,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }
              ],
              "followups": []
            }, {
              "questionId": 6059,
              "questionType": null,
              "sequence": 2,
              "displayNumber": "",
              "questionText": "How is training delivered?",
              "answerText": null,
              "answerMemo": null,
              "referenceText": null,
              "parentQuestionId": null,
              "parentOptionId": 655,
              "options": [{
                "optionId": 208,
                "optionType": "Checkbox",
                "optionText": "Video",
                "sequence": 10,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 209,
                "optionType": "Checkbox",
                "optionText": "Web-based/CBT",
                "sequence": 11,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 210,
                "optionType": "Checkbox",
                "optionText": "Classroom",
                "sequence": 12,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 211,
                "optionType": "Checkbox",
                "optionText": "OJT (on-the-job)",
                "sequence": 13,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 212,
                "optionType": "Checkbox",
                "optionText": "Other:",
                "sequence": 14,
                "weight": null,
                "selected": false,
                "hasAnswerText": true,
                "answerText": null,
                "followups": []
              }
              ],
              "followups": []
            }, {
              "questionId": 6146,
              "questionType": null,
              "sequence": 3,
              "displayNumber": "",
              "questionText": "Frequency of continuation/refresher training:",
              "answerText": null,
              "answerMemo": null,
              "referenceText": null,
              "parentQuestionId": null,
              "parentOptionId": 655,
              "options": [{
                "optionId": 582,
                "optionType": "Radio",
                "optionText": "Weekly",
                "sequence": 1,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 583,
                "optionType": "Radio",
                "optionText": "Monthly",
                "sequence": 2,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 584,
                "optionType": "Radio",
                "optionText": "Quarterly",
                "sequence": 3,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 585,
                "optionType": "Radio",
                "optionText": "Semiannually",
                "sequence": 4,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 586,
                "optionType": "Radio",
                "optionText": "Annually",
                "sequence": 5,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 587,
                "optionType": "Radio",
                "optionText": "Greater than one year",
                "sequence": 6,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 588,
                "optionType": "Radio",
                "optionText": "Never",
                "sequence": 7,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }
              ],
              "followups": []
            }, {
              "questionId": 6147,
              "questionType": null,
              "sequence": 4,
              "displayNumber": "",
              "questionText": "Are personnel trained in the following areas? (Check all that apply.)",
              "answerText": null,
              "answerMemo": null,
              "referenceText": null,
              "parentQuestionId": null,
              "parentOptionId": 655,
              "options": [{
                "optionId": 213,
                "optionType": "Checkbox",
                "optionText": "Contingency",
                "sequence": 25,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 214,
                "optionType": "Checkbox",
                "optionText": "Server administration",
                "sequence": 26,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 215,
                "optionType": "Checkbox",
                "optionText": "Network administration",
                "sequence": 27,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 216,
                "optionType": "Checkbox",
                "optionText": "Incident response",
                "sequence": 28,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 217,
                "optionType": "Checkbox",
                "optionText": "Threat analysis",
                "sequence": 29,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 218,
                "optionType": "Checkbox",
                "optionText": "Risk management",
                "sequence": 30,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 219,
                "optionType": "Checkbox",
                "optionText": "None of the above",
                "sequence": 31,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }
              ],
              "followups": []
            }
            ]
          }
          ],
          "followups": []
        }, {
          "questionId": 5969,
          "questionType": "LEGACY",
          "sequence": 2,
          "displayNumber": "",
          "questionText": "15.2 Are cyber personnel trained on the cybersecurity plan?",
          "answerText": null,
          "answerMemo": null,
          "referenceText": null,
          "parentQuestionId": null,
          "parentOptionId": null,
          "options": [{
            "optionId": 656,
            "optionType": "Radio",
            "optionText": "No",
            "sequence": 1,
            "weight": 89.0,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": []
          }, {
            "optionId": 657,
            "optionType": "Radio",
            "optionText": "Yes",
            "sequence": 2,
            "weight": 0.0,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": []
          }
          ],
          "followups": []
        }, {
          "questionId": 5970,
          "questionType": "LEGACY",
          "sequence": 3,
          "displayNumber": "",
          "questionText": "15.3 Has the organization established and documented a minimum level of training, education and/or experience required for cybersecurity personnel related to the CCS?",
          "answerText": null,
          "answerMemo": null,
          "referenceText": null,
          "parentQuestionId": null,
          "parentOptionId": null,
          "options": [{
            "optionId": 658,
            "optionType": "Radio",
            "optionText": "No",
            "sequence": 1,
            "weight": 0.0,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": []
          }, {
            "optionId": 659,
            "optionType": "Radio",
            "optionText": "Yes",
            "sequence": 2,
            "weight": 0.0,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": [{
              "questionId": 6148,
              "questionType": null,
              "sequence": 1,
              "displayNumber": "",
              "questionText": "How are the training, education, and experience recorded (evidenced)? (Check all that apply.)",
              "answerText": null,
              "answerMemo": null,
              "referenceText": null,
              "parentQuestionId": null,
              "parentOptionId": 659,
              "options": [{
                "optionId": 220,
                "optionType": "Checkbox",
                "optionText": "Current professional certification",
                "sequence": 4,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 221,
                "optionType": "Checkbox",
                "optionText": "Information security degree",
                "sequence": 5,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 222,
                "optionType": "Checkbox",
                "optionText": "Previous work experience",
                "sequence": 6,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 223,
                "optionType": "Checkbox",
                "optionText": "Performance management",
                "sequence": 7,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 224,
                "optionType": "Checkbox",
                "optionText": "Human resources file of professional development",
                "sequence": 8,
                "weight": null,
                "selected": false,
                "hasAnswerText": false,
                "answerText": null,
                "followups": []
              }, {
                "optionId": 225,
                "optionType": "Checkbox",
                "optionText": "Other",
                "sequence": 9,
                "weight": null,
                "selected": false,
                "hasAnswerText": true,
                "answerText": null,
                "followups": []
              }
              ],
              "followups": []
            }
            ]
          }
          ],
          "followups": []
        }, {
          "questionId": 5971,
          "questionType": "LEGACY",
          "sequence": 4,
          "displayNumber": "",
          "questionText": "15.4 Does the organization manage skills management as part of the performance monitoring process related to the CCS?",
          "answerText": null,
          "answerMemo": null,
          "referenceText": null,
          "parentQuestionId": null,
          "parentOptionId": null,
          "options": [{
            "optionId": 660,
            "optionType": "Radio",
            "optionText": "No",
            "sequence": 1,
            "weight": 74.0,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": []
          }, {
            "optionId": 661,
            "optionType": "Radio",
            "optionText": "Yes",
            "sequence": 2,
            "weight": 0.0,
            "selected": false,
            "hasAnswerText": false,
            "answerText": null,
            "followups": []
          }
          ],
          "followups": []
        }, {
          "questionId": 5972,
          "questionType": "MEMO",
          "sequence": 5,
          "displayNumber": "",
          "questionText": "15.5 Cybersecurity Training Briefing Notes:",
          "answerText": null,
          "answerMemo": null,
          "referenceText": null,
          "parentQuestionId": null,
          "parentOptionId": null,
          "options": [],
          "followups": []
        }, {
          "questionId": 5973,
          "questionType": "MEMO",
          "sequence": 6,
          "displayNumber": "",
          "questionText": "15.6 Cybersecurity Training Comments:",
          "answerText": null,
          "answerMemo": null,
          "referenceText": null,
          "parentQuestionId": null,
          "parentOptionId": null,
          "options": [],
          "followups": []
        }
        ]
      }
      ];
    return resp;
  }
}