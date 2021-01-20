////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
import { Component, OnInit, AfterViewChecked, AfterViewInit } from '@angular/core';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { ReportService } from '../../services/report.service';
import { ACETService } from '../../services/acet.service';


@Component({
  selector: 'app-acet-answeredquestions',
  templateUrl: './acet-answeredquestions.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss']
})
export class AcetAnsweredQuestionsComponent implements OnInit {
  response: any = {};

  constructor(
    public reportSvc: ReportService,
    private titleService: Title,
    public acetSvc: ACETService,

  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Answered Questions Report - ACET");

    this.acetSvc.getAnsweredQuestions().subscribe(
      (r: any) => {
        //this.response = r;
        console.log(r)

        ///// TEMPORARY DUMMY RESPONSE DATA ////////
        this.response.AnsweredQuestions = {
          Domains: [{
            Title: "Cyber Risk Management & Oversight",
            AssessmentFactors: [{
              Title: "Governance",
              Components: [{
                Title: "Oversight",
                Questions: [{
                  Title: "Stmt 1",
                  QuestionText: "Designated members of management are held accountable by the board or an appropriate board committee for implementing and managing the information security and business continuity programs.",
                  MaturityLevel: "B",
                  Comments: "Yes"
                }, {
                  Title: "Stmt 2",
                  QuestionText: "Information security risks are discussed in management meetings when prompted by highly visible cyber events or regulatory alerts.",
                  MaturityLevel: "B",
                  Comments: "Yes"
                }
                ]
              }]
            }, {
              Title: "Risk Management",
              Components: [{
                Title: "Strategy / Policies",
                Questions: [{
                  Title: "Stmt 28",
                  QuestionText: "The institution has policies commensurate with its risk and complexity that address the concepts of threat information sharing",
                  MaturityLevel: "Int",
                  Comments: "No"
                }
                ]
              }, {
                Title: "IT Asset Management",
                Questions: [{
                  Title: "Stmt 48",
                  QuestionText: "Organizational assets (e.g., hardware, systems, data, and applications) are prioritized for protection based on the data classification and business value.",
                  MaturityLevel: "B",
                  Comments: "No"
                }
                ]
              }
              ]
            }
            ]
          }, {
            Title: "Cybersecurity Controls",
            AssessmentFactors: [{
              Title: "Preventative Controls",
              Components: [{
                Title: "Access and Data Management",
                Questions: [{
                  Title: "Stmt 218",
                  QuestionText: "Employee access is granted to systems and confidential data based on job responsibilities and the principles of least privilege",
                  MaturityLevel: "B",
                  Comments: "Yes"
                }
                ]
              }
              ]
            }
            ]
          }]
        };
        console.log(this.response)

      },
      error => console.log('Assessment Infromation Error: ' + (<Error>error).message)
    );
  }
}