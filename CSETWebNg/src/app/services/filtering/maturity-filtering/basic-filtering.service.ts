import { Injectable } from '@angular/core';
import { Question } from '../../../models/questions.model';

@Injectable({
  providedIn: 'root'
})
export class BasicFilteringService {

  constructor() { }

  public setQuestionVisibility(q: Question) {
    q.visible = true;
  }
}
