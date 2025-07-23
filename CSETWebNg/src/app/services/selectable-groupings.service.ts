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
import { BehaviorSubject, firstValueFrom, Observable, Subject } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { ConfigService } from './config.service';

@Injectable({
  providedIn: 'root'
})
export class SelectableGroupingsService {

  private apiUrl: string;

  public modelsThatSupportSelectableGroupings = [23, 24];

  /**
   * We can store multiple models for multiple question page state
   */
  models: Map<number, QuestionGrouping[]>;

  selectedGroupIds: number[];


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
   * Returns the grouping in the structure with the specified ID
   */
  findGrouping(modelId: number, id: number): QuestionGrouping | null {
    const modelDomains = this.models.get(modelId);
    return this.findDeep(modelDomains, item => item.groupingId == id);
  }

  /**
   * Finds the target's parent, then iterate through the parent's children, 
   * setting their selected property to true if they are below or at the 
   * target level, and false above the target.
   */
  findGroupingAndLesser(modelId: number, id: number): QuestionGrouping[] {
    let resp: Array<QuestionGrouping> = [];

    const modelDomains = this.models.get(modelId);
    const target = this.findDeep(modelDomains, item => item.groupingId == id);

    const parent = this.findParent(modelDomains, target);

    let selected = true;

    for (let c of parent) {
      resp.push(c);
      c.selected = selected;
      if (c == target) {
        selected = false;
      }
    }

    return resp;
  }

  /**
   * 
   */
  findDeep(arr, predicate): QuestionGrouping | null {
    let result;
    result = null;

    for (const item of arr) {
      if (predicate(item)) {
        result = item;
        break;
      }

      if (item.subGroupings && item.subGroupings.length) {
        result = this.findDeep(item.subGroupings, predicate);
        if (result) break;
      }
    }
    return result;
  }

  /**
   * 
   * @param obj 
   * @param target 
   * @returns 
   */
  findParent(obj, target) {
    for (let key in obj) {
      if (obj[key] === target) {
        return obj;
      }
      if (typeof obj[key] === 'object' && obj[key] !== null) {
        let parent = this.findParent(obj[key], target);
        if (parent) {
          return parent;
        }
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
   * Persists a group of groupings with the same selected status.
   */
  save(groupings: any) {
    const payload = [] as any[];
    for (let g of groupings) {
      payload.push({ groupingId: g.groupingId, selected: g.selected});
    }
    return this.http.post(this.apiUrl + "groupselection/", { groups: payload });
  }
}
