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
import { Component, Input, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Answer, Question, IntegrityCheckOption } from '../../../../../models/questions.model';
import { CisService } from '../../../../../services/cis.service';
import { QuestionsService } from '../../../../../services/questions.service';
import { ConfigService } from '../../../../../services/config.service';
import { QuestionExtrasDialogComponent } from '../../../question-extras-dialog/question-extras-dialog.component';
import { AssessmentService } from '../../../../../services/assessment.service';
import { LayoutService } from '../../../../../services/layout.service';
import { ActivatedRoute } from '@angular/router';
import { MalcolmService } from '../../../../../services/malcolm.service';


@Component({
  selector: 'app-question-block-nested',
  templateUrl: './question-block-nested.component.html'
})
export class QuestionBlockNestedComponent implements OnInit {

  @Input() grouping: any;
  @Input() questions: Question[];

  questionList: Question[] = [];

  /** 
   * Some models should show the maturity level.
   * This should probably be a property of the 
   * maturity model and eventually defined in the database.
   */
  showQuestionLevel = false;

  // temporary debug aid
  showIdTag = false;

  sectionId = 0;
  malcolmInfo: any;

  constructor(
    public assessSvc: AssessmentService,
    public questionsSvc: QuestionsService,
    public cisSvc: CisService,
    public malcolmSvc: MalcolmService,
    private configSvc: ConfigService,
    public dialog: MatDialog,
    public layoutSvc: LayoutService,
    private route: ActivatedRoute
  ) { }

  /**
   *
   */
  ngOnInit(): void {
    this.sectionId = +this.route.snapshot.params['sec'];

    if (!!this.grouping) {
      this.questionList = this.grouping.questions;
    }

    if (!!this.questions) {
      this.questionList = this.questions;
    }

    // MVRA should show the maturity level.  CIS does not.
    if (this.assessSvc.assessment.maturityModel.modelId == 9) {
      this.showQuestionLevel = true;
    }

    this.showIdTag = this.configSvc.showQuestionAndRequirementIDs();

    // listen for changes to the extras
    this.questionsSvc.extrasChanged$.subscribe((qe) => {
      this.refreshExtras(qe);
    });
    
    if (this.configSvc.behaviors.showMalcolmAnswerComparison) {
      this.malcolmSvc.getMalcolmAnswers().subscribe((r: any) => {    
        this.malcolmInfo = r;
      });
    }
  }

  getMhdNum(val: string) {
    if (!val) {
      return '';
    }
    let p = val.split('|');
    if (p.length > 0) {
      return p[0];
    }
  }

  getMhdUnit(val: string) {
    if (!val) {
      return '';
    }
    let p = val.split('|');
    if (p.length > 1) {
      return p[1];
    }
  }

  /**
   * Returns 'inline' if any details/extras exist
   */
  hasDetails(q: Question): string {
    if (q.comment !== null && q.comment.length > 0) {
      return 'inline';
    }
    if (q.documentIds !== null && q.documentIds.length > 0) {
      return 'inline';
    }
    if (q.hasObservation) {
      return 'inline';
    }
    if (q.feedback !== null && q.feedback.length > 0) {
      return 'inline';
    }
    if (q.markForReview) {
      return 'inline';
    }
    return 'none';
  }

  /**
   * Updates the local question object's document ID list.
   * This is done to refresh the red content dot on the "i" icon.
   */
  refreshExtras(extras: any) {
    // make sure these extras belong to the current assessment
    if (this.assessSvc.id() !== extras.assessmentId) {
      return;
    }

    // find the question whose extras were just changed
    var q = this.questionList.find(q => q.questionId == extras.questionId);
    if (!q) {
      return;
    }

    // update the documentIds per the extras passed to me
    q.documentIds = [];
    extras.documents.forEach(doc => {
      q.documentIds.push(doc.document_Id);
    });
  }

  /**
   *
   */
  changeText(q, event) {
    q.answerMemo = event.target.value;
    this.storeAnswer(q, event.target.value);
  }

  /**
   *
   */
  changeMemo(q, event) {
    q.answerMemo = event.target.value;
    this.storeAnswer(q, event.target.value);
  }


  /**
   * Builds a single answer from the number + unit fields
   */
  changeMinHrDay(num, unit, q) {
    let val = num.value + '|' + unit.value;

    q.answerMemo = val;
    this.storeAnswer(q, val);
  }

  /**
   *
   */
  storeAnswer(q, val) {
    const answer: Answer = {
      answerId: q.answerId,
      questionId: q.questionId,
      questionType: 'Maturity',
      is_Maturity: true,
      is_Component: false,
      is_Requirement: false,
      questionNumber: '',
      answerText: '',
      altAnswerText: '',
      freeResponseAnswer: val,
      comment: '',
      feedback: '',
      markForReview: false,
      reviewed: false,
      componentGuid: '00000000-0000-0000-0000-000000000000'
    };

    this.cisSvc.storeAnswer(answer, this.sectionId).subscribe((x: any) => {
      let score = x.groupingScore;
      this.cisSvc.changeScore(score);
    });
  }

  /**
   *
   */
  openExtras(q) {
    if (!q.questionType) {
      q.questionType = 'Maturity';
    }

    this.dialog.open(QuestionExtrasDialogComponent, {
      data: {
        question: q,
        options: {
          eagerSupplemental: true,
          showMfr: true
        }
      },
      width: this.layoutSvc.hp ? '90%' : '50%',
      maxWidth: this.layoutSvc.hp ? '90%' : '50%'
    });
  }

  /**
   * Gets the corresponding questions to the given optionIds
   * and returns an error message for the integrity check.
   */
  getIntegrityCheckErrors(inconsistentOptions: IntegrityCheckOption[]) {
    if (!inconsistentOptions.length) {
      return null;
    }

    let integrityCheckErrors = 'This answer is inconsistent with the answer to the following question(s): '

    inconsistentOptions.forEach((option: IntegrityCheckOption) => {
      if (!integrityCheckErrors.includes(option.parentQuestionText)) {
        integrityCheckErrors += option.parentQuestionText;
      }
    });

    return integrityCheckErrors;
  }
}
