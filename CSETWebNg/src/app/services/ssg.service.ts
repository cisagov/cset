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
import { Injectable } from '@angular/core';
import { AssessmentService } from './assessment.service';


/**
 * A service that provides functionality related to Sector-Specific Goals (SSG).
 * An SSG may be automatically applied as a 'bonus' model on a CPG assessment
 * based on the assessment's chosen cybsersecurity SECTOR.
 */
@Injectable({
  providedIn: 'root'
})
export class SsgService {

  constructor(
    private assessSvc: AssessmentService
  ) { }

   /**
   * Returns a simple keyword that describes the assessment's
   * sector.  This keyword is concatenated to form a translation key.
   * 
   * Because IOD and everyone else use different sector/industry
   * value lists, these will likely be defined in pairs, one
   * cyber sector and one NIPP sector.
   */
   ssgSimpleSectorLabel() {
    const s : number = Number(this.assessSvc.assessment?.sectorId);

    if ([1, 19].includes(s)) {
      return 'chemical';
    }

    return 'other';
  }

  /**
   * Returns the maturity model that applies to the
   * assessment's current sector.  
   * 
   * Because IOD and everyone else use different sector/industry
   * value lists, these will likely be defined in pairs, one
   * cyber sector and one NIPP sector.
   */
  ssgBonusModel(): number {
    const s : number = Number(this.assessSvc.assessment?.sectorId);
    
    if ([1, 19].includes(s)) {
      return 18; // chemical
    }
    return null;
  }

  /**
   * Indicates if any of the SSGs apply to the assessment
   * due to its sector.
   */
  doesSsgApply() {
    return this.ssgBonusModel() != null;
  }
}
