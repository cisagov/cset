////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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

  groupIdToClass: Record<number, string> = {
    // CSF 2.0
    567: 'csf2-func-gv',
    568: 'csf2-func-id',
    569: 'csf2-func-pr',
    570: 'csf2-func-de',
    571: 'csf2-func-rs',
    572: 'csf2-func-rc',

    // CPG 1.0 (CSF1 colors)
    200: 'csf1-func-id',
    560: 'csf1-func-id',
    201: 'csf1-func-pr',
    561: 'csf1-func-pr',
    202: 'csf1-func-de',
    562: 'csf1-func-de',
    203: 'csf1-func-rs',
    563: 'csf1-func-rs',
    204: 'csf1-func-rc',
    564: 'csf1-func-rc',

    // SSG - IT
    565: 'ssg-it-software-dev',
    566: 'ssg-it-product-design'
  };

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
}
