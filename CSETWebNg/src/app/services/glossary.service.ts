import { Injectable } from '@angular/core';
import { GlossaryEntry } from '../models/questions.model';

@Injectable({
  providedIn: 'root'
})
export class GlossaryService {

  public glossaryEntries: GlossaryEntry[];

  /**
   * 
   */
  constructor() { }
}
