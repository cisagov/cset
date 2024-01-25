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
import { Component, Input, OnInit } from '@angular/core';
import { AssessmentService } from '../../../../../services/assessment.service';
import { ConfigService } from '../../../../../services/config.service';
import { MaturityService } from '../../../../../services/maturity.service';

@Component({
  selector: 'app-grouping-block-nested',
  templateUrl: './grouping-block-nested.component.html',
  styleUrls: ['./grouping-block-nested.component.scss']
})
export class GroupingBlockNestedComponent implements OnInit {

  @Input('grouping') grouping: any;

  title: string;

  constructor(
    public assessSvc: AssessmentService,
    public matSvc: MaturityService,
    public configSvc: ConfigService
  ) { }

  ngOnInit(): void {
    this.title = this.grouping.title;
    if (!!this.grouping.prefix) {
      this.title = this.grouping.prefix + '. ' + this.grouping.title;
    }
  }

  shouldDescriptionBeSticky() {
    return this.assessSvc.assessment.maturityModel?.modelName === 'MVRA';
  }

}
