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
import { SelectableModel } from '../models/selectable-model.model';
import { QuestionGrouping } from '../models/questions.model';
import { BehaviorSubject, Subject } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class SelectableGroupingsService {

  /**
   * We can store multiple models for multiple question page state
   */
  models: Map<number, QuestionGrouping[]>;

  // 
  private selectionChangedSubject = new Subject<void>();
  selectionChanged$ = this.selectionChangedSubject.asObservable();


  /**
   * 
   */
  constructor() {
    this.models = new Map<number, QuestionGrouping[]>();
  }

  /**
   * 
   * @param groupings 
   */
  public evaluateGroupSelection(groupings: QuestionGrouping[] | null) {
    groupings?.forEach(g => {
      // find my local thing
      const mySetting = this.models.get(22)?.find(x => x.groupingID == g.groupingID);
      if (!!mySetting) {
        g.visible = mySetting?.selected;
      }
    });
  }

  public findGrouping(modelId: number, groupingID: number): QuestionGrouping | null {
    const targetModel = this.models.get(modelId);
    if (!targetModel) {
      return null;
    }

    for (let i: number = 0; i < targetModel.length; i++) {
      const sb = targetModel[i].subGroupings.find(y => y.groupingID == groupingID);
      if (!!sb) {
        return sb;
      }
    }

    return null;
  }

  /**
   * 
   */
  emitEvent() {
    this.selectionChangedSubject.next();
  }
}
