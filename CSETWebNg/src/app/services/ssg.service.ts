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
import { AssessmentService } from './assessment.service';
import { DemographicService } from './demographic.service';


/**
 * A service that provides functionality related to Sector-Specific Goals (SSG).
 * One ore more SSGs may be automatically applied as additional models on a CPG assessment
 * based on the SSG Sector selections persisted in the demographics.
 */
@Injectable({
  providedIn: 'root'
})
export class SsgService {

  /**
   * Sector codes supported with SSG in CSET
   */
  csetSsgSectorList = [
    1, // chem
//    19, // chem
    13, // IT
//    28 // IT
  ];

  /**
   * Define 'sisters' of sectors 
   */
  relatedSectors = {
    1: 19,
    19: 1,
    13: 28,
    28: 13
  };

  /**
   * Sector codes with CISA online documentation.
   * We list them with a link for user reference.
   */
  otherSsgSectorList = [
    8, // energy
    25, // energy
    12, // healthcare
    27, // healthcare
    16, // water
    34 // water
  ];


  /**
   * CTOR
   */
  constructor(
    private assessSvc: AssessmentService,
    private demoSvc: DemographicService
  ) { }


  /**
   * Indicates if any of the SSGs are selected.
   */
  get isSsgActive(): boolean {
    if (this.assessSvc.assessment?.ssgSectorIds) {
      return this.assessSvc.assessment.ssgSectorIds.length > 0;
    }

    return false;
  }

  /**
   * Returns the currently selected SSG models.
   */
  get activeSsgModelIds(): number[] {

    // TODO:  crude mapping - make this slicker
    const list = new Set<number>();
    this.assessSvc.assessment?.ssgSectorIds?.forEach(sectorId => {
      if (sectorId == 1 || sectorId == 19) {
        list.add(18); // SSG CHEM
      }
      if (sectorId == 13 || sectorId == 28) {
        list.add(20); // SSG IT
      }
    });

    return Array.from(list);
  }
}
