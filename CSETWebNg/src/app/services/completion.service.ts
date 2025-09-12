////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
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
import { Subject } from 'rxjs';
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
  private completionChanged = new Subject<void>();
  public completionChanged$ = this.completionChanged.asObservable();
  public structure: any;
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
   *
   * NOTE:  this service's 'structure' property must be set before
   * calling this function.
   */
  setQuestionArray() {
    this.reset();

    // this version gathers questions from a Standard response structure
    if (!!this.structure.categories) {
      this.structure.categories.forEach(element => {
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
    } else if (!!this.structure.groupings) {
      // this version gathers questions from a Maturity response structure
      this.targetMaturityLevel = this.structure.maturityTargetLevel;

      this.structure.groupings.filter(x => x.selected).forEach(g => {
        g.questions.forEach(q => {
          if (q.maturityLevel <= this.targetMaturityLevel && (g.selected && q.countable)) {
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
   *
   * Only questions within the maturity level that are
   * in selected groupings and are considered 'countable' are collected.
   */
  private recurseSubgroups(gg) {
    gg.subGroupings?.filter(x => x.selected).forEach(g => {
      g.questions.forEach(q => {
        // how do we only consider 'countable' questions?  For VADR the parents are countable, but for others, parents are not.
        // so we can't blindly treat parents one way for all models.
        if (q.maturityLevel <= this.targetMaturityLevel && q.countable) {
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
   * Recalculate question completion numbers
   */
  toggleGroupSelection() {
    // rebuild from scratch to get an accurate number for the new selected groupings
    this.setQuestionArray();
  }

  /**
   *
   */
  setAnswer(id: number, value: string) {
    console.log('🔥 CompletionService.setAnswer called:', { id, value });
    const ans = this.questionflat.find(x => x.id == id);
    if (!!ans) {
      ans.answer = value;
    }
    this.countAnswers();
    this.completionChanged.next();
  }

  /**
   * Tallies answered questions
   */
  countAnswers() {
    this.answeredCount = this.questionflat.filter(x => x.answer !== 'U' && x.answer !== '' && x.answer !== null).length;
    this.totalCount = this.questionflat.length;


  }
}
