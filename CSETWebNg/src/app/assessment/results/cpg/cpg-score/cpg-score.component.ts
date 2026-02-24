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
import { CpgService } from '../../../../services/cpg.service';

/**
 * Displays separate scores for the CPG2 IT and OT questions.
 * The scores are a percentage compliant, with each "Y"
 * answer receiving 1 point.  In-progress ("I") answers
 * receive half credit, 0.5 point.  All other answer
 * options receive 0 points.  All points are averaged
 * and a percentage score is rendered.
 */
@Component({
  selector: 'app-cpg-score',
  standalone: false,
  templateUrl: './cpg-score.component.html',
  styleUrl: './cpg-score.component.scss'
})
export class CpgScoreComponent implements OnInit {

  @Input()
  itScore?: number;

  @Input()
  otScore?: number;

  @Input()
  techDomain?: string;

  TECH_DOMAIN_OT = ['OT', 'OT+IT', null];
  TECH_DOMAIN_IT = ['IT', 'OT+IT', null];

  /**
   * 
   */
  constructor(
    public cpgSvc: CpgService
  ) { }

  /**
   * 
   */
  ngOnInit(): void { }
}
