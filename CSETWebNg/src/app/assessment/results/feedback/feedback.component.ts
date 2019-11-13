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

import { Component, OnInit } from '@angular/core';
import { AnalysisService } from '../../../services/analysis.service';
import { ConfigService } from '../../../services/config.service';
import { Navigation2Service } from '../../../services/navigation2.service';
import { NavigationService } from '../../../services/navigation.service';
import { ActivatedRoute, Router } from '../../../../../node_modules/@angular/router';
import { AssessmentService } from '../../../services/assessment.service';


@Component({
  selector: 'app-feedback',
  templateUrl: './feedback.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' },
  styleUrls: ['./feedback.component.css']
})

export class FeedbackComponent implements OnInit {
  feedbackBody: string;
  feedbackHeader: string = 'Feedback';
  feedbackEmailTo: string;
  feedbackEmailSubject: string;
  feedbackEmailBody: string;
  initialized = false;
  docUrl: string;

  constructor(
    private assessSvc: AssessmentService,
    private navSvc: NavigationService,
    private router: Router,
    private route: ActivatedRoute,
    private analysisSvc: AnalysisService,
    public navSvc2: Navigation2Service,
    private configSvc: ConfigService
  ) { }

  ngOnInit() {
    this.assessSvc.currentTab = 'results';
    this.docUrl = this.configSvc.docUrl;
    this.analysisSvc.getFeedback().subscribe(x => this.setupTable(x));

    this.navSvc.itemSelected.asObservable().subscribe((value: string) => {
      this.router.navigate([value], { relativeTo: this.route.parent });
    });
  }

  copyText(div: HTMLDivElement) {
    if (window.getSelection) {
      const range = document.createRange();
      range.selectNodeContents(div);

      const selection = window.getSelection();
      selection.removeAllRanges();
      selection.addRange(range);
      document.execCommand('Copy');
    }
  }

  defaultClientEmail() {
    const createEmail = document.createElement('a');
    createEmail.setAttribute('href', 'mailto:' + this.feedbackEmailTo
      + "?" + "subject=" + this.feedbackEmailSubject
      + "&" + "body=" + this.feedbackEmailBody);
    document.body.appendChild(createEmail);
    // createEmail.style = "display: none";
    createEmail.click();
  }

  setupTable(data: any) {
    this.initialized = false;
    this.feedbackBody = data.FeedbackBody;
    this.feedbackEmailTo = data.FeedbackEmailTo;
    this.feedbackEmailSubject = data.FeedbackEmailSubject;
    this.feedbackEmailBody = data.FeedbackEmailBody;
    this.initialized = true;
  }
}
