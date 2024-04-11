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
import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { ConfigService } from '../../../services/config.service';
import { MaturityService } from '../../../services/maturity.service';
import { QuestionsService } from '../../../services/questions.service';

@Component({
  selector: 'app-cmmc2-deficiency',
  templateUrl: './cmmc2-deficiency.component.html',
  styleUrls: ['./../../crr/crr-report/crr-report.component.scss']
})
export class Cmmc2DeficiencyComponent implements OnInit {

  model: any;
  loading: boolean = false;
  keyToCategory: any;

  deficienciesList = [];

  constructor(
    public configSvc: ConfigService,
    private titleService: Title,
    private maturitySvc: MaturityService,
    public questionsSvc: QuestionsService
  ) { }

  ngOnInit() {
    this.loading = true;
    this.keyToCategory = this.maturitySvc.keyToCategory;
    this.titleService.setTitle("CMMC 2.0 Deficiency Report - " + this.configSvc.behaviors.defaultTitle);

    this.maturitySvc.getCmmcReportData().subscribe(
      (r: any) => {
        this.model = r;

        // Build up deficiencies list
        this.model.reportData.deficienciesList.forEach(matAns => {
          const domain = matAns.mat.question_Title.split('.')[0];
          const dElement = this.deficienciesList.find(e => e.cat === this.keyToCategory[domain]);
          if (!dElement) {
            this.deficienciesList.push({ cat: this.keyToCategory[domain], matAnswers: [matAns] });
          } else {
            dElement.matAnswers.push(matAns);
          }
        });

        // mark questions followed by a child for border display
        this.deficienciesList.forEach(e => {
          for (let i = 0; i < e.matAnswers.length; i++) {
            if (e.matAnswers[i + 1]?.mat.parent_Question_Id != null) {
              e.matAnswers[i].isFollowedByChild = true;
            }
          }
        });

        this.loading = false;
      },
      error => console.log('CMMC 2.0 Deficiency Report Error: ' + (<Error>error).message)
    );
  }

  getFullAnswerText(abb: string) {
    return this.questionsSvc.answerDisplayLabel('CMMC2', abb);
  }

  printReport() {
    window.print();
  }
}
