import { Injectable } from '@angular/core';

/**
 * This service tracks questions for the current page and 
 * tallies answer completion.  This feeds the "0/100" display
 * on question page headers.
 */
@Injectable({
  providedIn: 'root'
})
export class CompletionService {

  /**
   * We can store a target level here to help
   * decide if a question is within the target range
   * or not.  Questions above the target level
   * should not be counted for the totals.
   */
  targetMaturityLevel = 100;

  answeredCount = 0;
  totalCount = 0;

  questionflat: any[];

  /**
   * 
   */
  constructor() { }


  /**
   * 
   */
  reset() {
    this.questionflat = [];
    this.answeredCount = 0;
    this.totalCount = 0;
  }

  /**
   * Converts a question structure into a bag of IDs so that
   * we can quickly calculate answer counts.
   */
  setQuestionArray(data) {
    this.reset();

    // this version gathers questions from a Standard response structure
    if (!!data.categories) {
      data.categories.forEach(element => {
        element.subCategories.forEach(sub => {
          sub.questions.forEach(q => {
            this.questionflat.push({
              id: q.questionId,
              answer: q.answer,
              maturityLevel: q.maturityLevel
            });
          });
        })
      });
    } else if (!!data.groupings) {
      // this version gathers questions from a Maturity response structure
      this.targetMaturityLevel = data.maturityTargetLevel;

      data.groupings.forEach(g => {
        g.questions.forEach(q => {
          if (q.maturityLevel <= this.targetMaturityLevel) {
            this.questionflat.push({
              id: q.questionId,
              answer: q.answer,
              maturityLevel: q.maturityLevel
            });
          }
        });
        this.recurseSubgroups(g);
      });
    }

    this.countAnswers();
  }

  /**
   * Loops through a maturity grouping's subgroups, 
   * adding its questions to the collection.
   * Only questions within the maturity level are collected.
   */
  recurseSubgroups(gg) {
    gg.subGroupings?.forEach(g => {
      g.questions.forEach(q => {
        if (q.maturityLevel <= this.targetMaturityLevel) {
          this.questionflat.push({
            id: q.questionId,
            answer: q.answer,
            maturityLevel: q.maturityLevel
          });
        }
      });
      this.recurseSubgroups(g);
    });
  }

  /**
   * 
   */
  setAnswer(id: number, value: string) {
    const ans = this.questionflat.find(x => x.id == id);
    if (!!ans) {
      ans.answer = value;
    }

    this.countAnswers();
  }

  /**
   * Tallies answered questions
   */
  countAnswers() {
    this.answeredCount = this.questionflat.filter(x => x.answer !== 'U' && x.answer !== '' && x.answer !== null).length;
    this.totalCount = this.questionflat.length;
  }
}
