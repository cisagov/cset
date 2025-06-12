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
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { ConfigService } from './config.service';

@Injectable({
  providedIn: 'root'
})
export class SelectableGroupingsService {

  private apiUrl: string;

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
  constructor(
    private http: HttpClient,
    private configSvc: ConfigService
  ) {
    this.apiUrl = this.configSvc.apiUrl;
    this.models = new Map<number, QuestionGrouping[]>();
  }

  /**
   * 
   */
  setModelGroupings(modelId: number, groupings: QuestionGrouping[]) {
    this.models.set(modelId, groupings);
  }


  /**
   * 
   */
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
  emitSelectionChanged() {
    this.selectionChangedSubject.next();
  }

  /**
   * 
   */
  getSelectedGroupIds() {
    return this.http.get(this.apiUrl + "groupselections/");
  }

  /**
   * 
   */
  save(groupingId: number, selected: boolean) {
    const payload = { groupingId: groupingId, selected: selected };
    return this.http.post(this.apiUrl + "groupselection/", payload);
  }
}
