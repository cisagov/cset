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
import { Component, Input, OnInit } from '@angular/core';
import { ColorService } from '../../../../services/color.service';
import { CpgService } from '../../../../services/cpg.service';

@Component({
  selector: 'app-cpg-practice-table',
  templateUrl: './cpg-practice-table.component.html',
  styleUrls: ['./cpg-practice-table.component.scss', '../../../../reports/reports.scss'],
  standalone: false
})
export class CpgPracticeTableComponent implements OnInit {

  /**
   * 
   */
  @Input()
  modelId: number;

  /**
   * To render a practice table for a specified model
   */
  @Input()
  ssgModelId?: number | null;

  model: any;

  /**
   * 
   */
  constructor(
    public cpgSvc: CpgService,
    public colorSvc: ColorService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
   // let modelId: number | null = null;

    if (!!this.ssgModelId) {
      this.modelId = this.ssgModelId;
    }

    // we need an optional argument to getStructure.  Either get CPG or a specified SSG model.
    this.cpgSvc.getStructure(this.modelId).subscribe((resp: any) => {
      this.model = resp;
    });
  }

  /**
   * 
   */
  parentQuestions(d: any) {
    return d.questions.filter(x => x.isParentQuestion);
  }

  /**
   * 
   */
  findChild(domain: any, parent: any, techDomain: string) {
    for (let q of domain.questions) {
      if (q.parentQuestionId == parent.questionId && q.questionText.indexOf(techDomain) > 0) {
        return q;
      }
    }

    return null;
  }

  /**
   * Returns the color for the CSF function of the group.
   * This is specific to CPG grouping IDs.
   * 
   * The colors were slightly modified in CSF 2.0.
   * 
   * As SSG models are added to CSET the new grouping codes will be
   * added to this logic.
   */
  backgroundColor(groupId: number): string {

    // CPG 2.0
    switch (groupId) {
      case 567:
        // govern
        return this.colorSvc.nistCsfFuncColor('GV-2');
      case 568:
        // identify
        return this.colorSvc.nistCsfFuncColor('ID-2');
      case 569:
        // protect
        return this.colorSvc.nistCsfFuncColor('PR-2');
      case 570:
        return this.colorSvc.nistCsfFuncColor('DE-2');
      case 571:
        // respond
        return this.colorSvc.nistCsfFuncColor('RS-2');
      case 572:
        // recover
        return this.colorSvc.nistCsfFuncColor('RC-2');


      // CPG 1.0
      case 200:
      case 560:
        // identify
        return this.colorSvc.nistCsfFuncColor('ID');
      case 201:
      case 561:
        // protect
        return this.colorSvc.nistCsfFuncColor('PR');
      case 202:
      case 562:
        // detect
        return this.colorSvc.nistCsfFuncColor('DE');
      case 203:
      case 563:
        // respond
        return this.colorSvc.nistCsfFuncColor('RS');
      case 204:
      case 564:
        // recover
        return this.colorSvc.nistCsfFuncColor('RC');


      // SSG - IT
      case 565:
        // SSG - IT Software Development
        return '#305496';
      case 566:
        // SSG - IT Product Design
        return '#548235';


      default:
        return '#6BA443';
    }
  }
}
