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
import { CmuReportModel } from '../../../models/reports.model';
import { ConfigService } from '../../../services/config.service';
import { QuestionsService } from '../../../services/questions.service';
import { CmuService } from './../../../services/cmu.service';

@Component({
  selector: 'app-crr-deficiency',
  templateUrl: './crr-deficiency.component.html',
  styleUrls: ['./../crr-report/crr-report.component.scss']
})
export class CrrDeficiencyComponent implements OnInit {
  crrModel: CmuReportModel;
  loading: boolean = false;
  keyToCategory: any;

  deficienciesList = [];

  constructor(
    public configSvc: ConfigService,
    private titleService: Title,
    private cmuSvc: CmuService,
    public questionsSvc: QuestionsService
  ) { }

  ngOnInit() {
    this.loading = true;
    this.titleService.setTitle('Deficiency Report - CRR');
    this.keyToCategory = this.cmuSvc.keyToCategory;

    this.cmuSvc.getCmuModel().subscribe(
      (r: CmuReportModel) => {
        this.crrModel = r;
        const categories = [];

        // Build up deficiencies list
        this.crrModel.reportData.deficienciesList.forEach((matAns) => {
          const domain = matAns.mat.question_Title.split(':')[0];
          const dElement = categories.find((e) => e.cat === this.keyToCategory[domain]);
          if (!dElement) {
            categories.push({ cat: this.keyToCategory[domain], matAnswers: [matAns] });
          } else {
            dElement.matAnswers.push(matAns);
          }
        });

        // We want the report to have the categories in a particular order, so manually add them in order
        this.pushDeficiencyCategory(categories.find((e) => e.cat === this.keyToCategory['AM']));
        this.pushDeficiencyCategory(categories.find((e) => e.cat === this.keyToCategory['CM']));
        this.pushDeficiencyCategory(categories.find((e) => e.cat === this.keyToCategory['CCM']));
        this.pushDeficiencyCategory(categories.find((e) => e.cat === this.keyToCategory['VM']));
        this.pushDeficiencyCategory(categories.find((e) => e.cat === this.keyToCategory['IM']));
        this.pushDeficiencyCategory(categories.find((e) => e.cat === this.keyToCategory['SCM']));
        this.pushDeficiencyCategory(categories.find((e) => e.cat === this.keyToCategory['RM']));
        this.pushDeficiencyCategory(categories.find((e) => e.cat === this.keyToCategory['EDM']));
        this.pushDeficiencyCategory(categories.find((e) => e.cat === this.keyToCategory['TA']));
        this.pushDeficiencyCategory(categories.find((e) => e.cat === this.keyToCategory['SA']));

        // Sort the list
        this.deficienciesList.forEach((e) => {
          e.matAnswers.sort((a, b) => {
            return (
              a.mat.question_Title.split('-')[0].localeCompare(b.mat.question_Title.split('-')[0]) ||
              a.mat.question_Text.localeCompare(b.mat.question_Text)
            );
          });
        });

        // mark questions followed by a child for border display
        this.deficienciesList.forEach((e) => {
          for (let i = 0; i < e.matAnswers.length; i++) {
            if (e.matAnswers[i + 1]?.mat.parent_Question_Id != null) {
              e.matAnswers[i].isFollowedByChild = true;
            }
          }
        });

        this.loading = false;
      },
      (error) => console.log('CRR Deficiency Report Error: ' + (<Error>error).message)
    );
  }

  pushDeficiencyCategory(cat) {
    if (cat) {
      this.deficienciesList.push(cat);
    }
  }

  getFullAnswerText(abb: string) {
    return this.questionsSvc.answerDisplayLabel('CRR', abb);
  }

  printReport() {
    window.print();
  }
}
