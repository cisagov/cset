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
import { Component, OnInit } from "@angular/core";
import { Title } from "@angular/platform-browser";
//import { data } from 'jquery';
import { ConfigService } from "../../../services/config.service";
import { MaturityService } from "../../../services/maturity.service";
import { ReportAnalysisService } from "../../../services/report-analysis.service";
import { ReportService } from "../../../services/report.service";
import {
  QuestionGrouping,
  MaturityQuestionResponse
} from "../../../models/questions.model";
import { NavigationService } from "../../../services/navigation/navigation.service";
import { QuestionFilterService } from "../../../services/filtering/question-filter.service";
import { MatDialog, MatDialogRef } from "@angular/material/dialog";
import { QuestionFiltersComponent } from "../../../dialogs/question-filters/question-filters.component";
import { MaturityFilteringService } from "../../../services/filtering/maturity-filtering/maturity-filtering.service";
import { ngxCsv } from "ngx-csv/ngx-csv";

@Component({
  selector: "app-open-ended-questions",
  templateUrl: "./open-ended-questions.component.html",
  styleUrls: [
    "../../reports.scss",
    "../../acet-reports.scss",
    "./open-ended-questions.component.scss",
  ],
})
export class OpenEndedQuestionsComponent implements OnInit {
  groupings: QuestionGrouping[];
  // subgroup: any [];
  noData: boolean = false;
  openEndedQuestion = false;
  onlyOpenQuestionData = [];
  response: any;
  data2 = [];
  modelName: string = "";
  // data1 = [];

  options = {
    fieldSeparator: ",",
    quoteStrings: '"',
    decimalseparator: ".",
    showLabels: true,
    showTitle: true,
    title: ["Open Ended Questions"],
    useBom: false,
    noDownload: false,
    headers: [
      "Category Name",
      "Question Number",
      "Questions",
      "Primary Question's Answer",
      "Secondary Question's Answer",
    ],
  };

  loaded = false;

  filterDialogRef: MatDialogRef<QuestionFiltersComponent>;
  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    private titleService: Title,
    public maturitySvc: MaturityService,
    public navSvc: NavigationService,
    public filterSvc: QuestionFilterService,
    public maturityFilteringSvc: MaturityFilteringService,
    private dialog: MatDialog
  ) { }

  ngOnInit() {
    this.loadQuestions();
    this.titleService.setTitle(
      "Validated Architecture Design Review Report - VADR"
    );
    this.maturitySvc.getMaturityDeficiency("VADR").subscribe((r: any) => {
      this.response = r;
      // this.response.deficienciesList = this.response.deficienciesList.filter(x => x.mat.parent_Question_Id == null);
    });
  }

  // previous = 0;

  loadQuestions() {
    this.groupings = null;
    this.maturitySvc
      .getQuestionsList(false)
      .subscribe(
        (response: MaturityQuestionResponse) => {
          this.modelName = response.modelName;
          this.groupings = response.groupings;
          this.groupings.forEach((element) => {
            element.subGroupings.forEach((s) => {
              this.onlyOpenQuestionData.push(s);
            });
          });
          this.onlyOpenQuestionData.forEach((q) => {
            const title = q.title;
            const Subgroup = q.questions.filter(
              (item) =>
                !(item.parentQuestionId == null && !item.isParentQuestion)
            );
            const myArray = [];

            Subgroup.forEach(function (item, index) {
              if (Subgroup[index].freeResponseAnswer != null) {
                myArray.push(Subgroup[index - 1]);
                myArray.push(Subgroup[index]);
              }
            });
            if (myArray.length >= 1) {
              this.data2.push({ title, myArray });
            } else if (this.data2.length === 0) {
              this.noData = true;
            }
          });

        },
        (error) => {
          console.log(
            "Error getting questions: " +
            (<Error>error).name +
            (<Error>error).message
          );
          console.log("Error getting questions: " + (<Error>error).stack);
        }
      );
  }
  toggleShow() {
    this.openEndedQuestion = !this.openEndedQuestion;
  }
  convertTocSvOnlyAnswered() {
    const dataOnlyAnswered = [];
    this.data2.forEach((e) => {
      const title = e.title;
      dataOnlyAnswered.push({ title });
      e.myArray.forEach((x) => {

        const questionNumber = x.displayNumber;
        const question = x.questionText;
        var OpenAnswer = "";
        var ParentAnswer = "";
        if (x.answer == "Y") {
          ParentAnswer = "Yes";
        }
        if (x.answer == "N") {
          ParentAnswer = "No";
        }
        if (x.answer == "U") {
          ParentAnswer = "Unanswered";
        }
        if (x.answer == "A" && x.altAnswerText) {
          ParentAnswer = "Alternate: " + x.altAnswerText;
        }
        if (x.answer == "A" && x.altAnswerText == null) {
          ParentAnswer = "Alternate";
        }
        if (x.freeResponseAnswer) {
          OpenAnswer = x.freeResponseAnswer;
          ParentAnswer = "";
        }
        dataOnlyAnswered.push({
          title: "",
          questionNumber,
          question,
          ParentAnswer,
          OpenAnswer,
        });
      });
    });
    new ngxCsv(dataOnlyAnswered, "Open Ended questions report only answered questions", this.options);
  }
  convertTocSvAll() {
    const data1 = [];
    this.onlyOpenQuestionData.forEach((e) => {

      const title = e.title;

      data1.push({ title });
      e.questions.forEach((x) => {
        const questionNumber = x.displayNumber;
        const question = x.questionText;
        var OpenAnswer = "";
        var ParentAnswer = "";
        if (x.answer == "Y") {
          ParentAnswer = "Yes";
        }
        if (x.answer == "N") {
          ParentAnswer = "No";
        }
        if (x.answer == "U") {
          ParentAnswer = "Unanswered";
        }
        if (x.answer == "A" && x.altAnswerText) {
          ParentAnswer = "Alternate: " + x.altAnswerText;
        }
        if (x.answer == "A" && x.altAnswerText == null) {
          ParentAnswer = "Alternate";
        }
        if (x.freeResponseAnswer) {
          OpenAnswer = x.freeResponseAnswer;
          ParentAnswer = "";
        }
        data1.push({
          title: "",
          questionNumber,
          question,
          ParentAnswer,
          OpenAnswer,
        });
      });
    });
    new ngxCsv(data1, "Open Ended All questions report", this.options);
  }
}
