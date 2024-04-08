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
import { CmuReportModel } from './../../../models/reports.model';
import { CmuService } from './../../../services/cmu.service';
import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { ConfigService } from '../../../services/config.service';
import { QuestionsService } from '../../../services/questions.service';

@Component({
  selector: 'app-crr-comments-marked',
  templateUrl: './crr-comments-marked.component.html',
  styleUrls: ['./../crr-report/crr-report.component.scss']
})
export class CrrCommentsMarkedComponent implements OnInit {
  crrModel: CmuReportModel;
  loading: boolean = false;
  keyToCategory: any;

  commentsList = [];
  markedForReviewList = [];

  constructor(
    public configSvc: ConfigService,
    private titleService: Title,
    private cmuSvc: CmuService,
    public questionsSvc: QuestionsService
  ) { }

  ngOnInit(): void {
    this.loading = true;
    this.titleService.setTitle('Comments Report - CISA CRR');
    this.keyToCategory = this.cmuSvc.keyToCategory;

    this.cmuSvc.getCmuModel().subscribe(
      (r: CmuReportModel) => {
        this.crrModel = r;
        const commentsCategories = [];

        // Build up comments list
        this.crrModel.reportData.comments.forEach((matAns) => {
          const domain = matAns.mat.question_Title.split(':')[0];
          const cElement = commentsCategories.find((e) => e.cat === this.keyToCategory[domain]);

          if (!cElement) {
            commentsCategories.push({ cat: this.keyToCategory[domain], matAnswers: [matAns] });
          } else {
            cElement.matAnswers.push(matAns);
          }
        });

        // We want the report to have the categories in a particular order, so manually add them in order
        this.pushCommentsCategory(commentsCategories.find((e) => e.cat === this.keyToCategory['AM']));
        this.pushCommentsCategory(commentsCategories.find((e) => e.cat === this.keyToCategory['CM']));
        this.pushCommentsCategory(commentsCategories.find((e) => e.cat === this.keyToCategory['CCM']));
        this.pushCommentsCategory(commentsCategories.find((e) => e.cat === this.keyToCategory['VM']));
        this.pushCommentsCategory(commentsCategories.find((e) => e.cat === this.keyToCategory['IM']));
        this.pushCommentsCategory(commentsCategories.find((e) => e.cat === this.keyToCategory['SCM']));
        this.pushCommentsCategory(commentsCategories.find((e) => e.cat === this.keyToCategory['RM']));
        this.pushCommentsCategory(commentsCategories.find((e) => e.cat === this.keyToCategory['EDM']));
        this.pushCommentsCategory(commentsCategories.find((e) => e.cat === this.keyToCategory['TA']));
        this.pushCommentsCategory(commentsCategories.find((e) => e.cat === this.keyToCategory['SA']));

        // Sort the marked for review list
        this.commentsList.forEach((e) => {
          e.matAnswers.sort((a, b) => {
            return (
              a.mat.question_Title.split('-')[0].localeCompare(b.mat.question_Title.split('-')[0]) ||
              a.mat.question_Text.localeCompare(b.mat.question_Text)
            );
          });
        });

        // mark questions followed by a child for border display
        this.commentsList.forEach((e) => {
          for (let i = 0; i < e.matAnswers.length; i++) {
            if (e.matAnswers[i + 1]?.mat.parent_Question_Id != null) {
              e.matAnswers[i].isFollowedByChild = true;
            }
          }
        });

        const mfrCategories = [];

        // Build up marked for review list
        this.crrModel.reportData.markedForReviewList.forEach((matAns) => {
          const domain = matAns.mat.question_Title.split(':')[0];
          const mfrElement = mfrCategories.find((e) => e.cat === this.keyToCategory[domain]);

          if (!mfrElement) {
            mfrCategories.push({ cat: this.keyToCategory[domain], matAnswers: [matAns] });
          } else {
            mfrElement.matAnswers.push(matAns);
          }
        });

        // We want the report to have the categories in a particular order, so manually add them in order
        this.pushMfrCategory(mfrCategories.find((e) => e.cat === this.keyToCategory['AM']));
        this.pushMfrCategory(mfrCategories.find((e) => e.cat === this.keyToCategory['CM']));
        this.pushMfrCategory(mfrCategories.find((e) => e.cat === this.keyToCategory['CCM']));
        this.pushMfrCategory(mfrCategories.find((e) => e.cat === this.keyToCategory['VM']));
        this.pushMfrCategory(mfrCategories.find((e) => e.cat === this.keyToCategory['IM']));
        this.pushMfrCategory(mfrCategories.find((e) => e.cat === this.keyToCategory['SCM']));
        this.pushMfrCategory(mfrCategories.find((e) => e.cat === this.keyToCategory['RM']));
        this.pushMfrCategory(mfrCategories.find((e) => e.cat === this.keyToCategory['EDM']));
        this.pushMfrCategory(mfrCategories.find((e) => e.cat === this.keyToCategory['TA']));
        this.pushMfrCategory(mfrCategories.find((e) => e.cat === this.keyToCategory['SA']));

        // Sort the marked for review list
        this.markedForReviewList.forEach((e) => {
          e.matAnswers.sort((a, b) => {
            return (
              a.mat.question_Title.split('-')[0].localeCompare(b.mat.question_Title.split('-')[0]) ||
              a.mat.question_Text.localeCompare(b.mat.question_Text)
            );
          });
        });

        // mark questions followed by a child for border display
        this.markedForReviewList.forEach((e) => {
          for (let i = 0; i < e.matAnswers.length; i++) {
            if (e.matAnswers[i + 1]?.mat.parent_Question_Id != null) {
              e.matAnswers[i].isFollowedByChild = true;
            }
          }
        });

        this.loading = false;
      },
      (error) => console.log('CRR Comments Marked Report Error: ' + (<Error>error).message)
    );
  }

  pushCommentsCategory(cat) {
    if (cat) {
      this.commentsList.push(cat);
    }
  }

  pushMfrCategory(cat) {
    if (cat) {
      this.markedForReviewList.push(cat);
    }
  }

  getFullAnswerText(abb: string) {
    return this.questionsSvc.answerDisplayLabel('CRR', abb);
  }

  printReport() {
    window.print();
  }
}
