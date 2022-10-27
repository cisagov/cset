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

    console.log(data);

    this.reset();

    // this version gathers standard questions
    if (!!data.categories) {
      data.categories.forEach(element => {
        element.subCategories.forEach(sub => {
          sub.questions.forEach(q => {
            this.questionflat.push({
              id: q.questionId,
              answer: q.answer
            });
          })
        })
      });
    } else if (!!data.groupings) {
      // this version gathers maturity questions
      data.groupings.forEach(g => {
        g.questions.forEach(q => {
          this.questionflat.push({
            id: q.questionId,
            answer: q.answer
          });
        });
        this.recurseSubgroups(g);
      });
    }

    this.countAnswers();
  }

  /**
   * Loops through a grouping's subgroups, 
   * adding its questions to the collection.
   */
  recurseSubgroups(gg) {
    gg.subGroupings?.forEach(g => {
      g.questions.forEach(q => {
        this.questionflat.push({
          id: q.questionId,
          answer: q.answer
        });
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
