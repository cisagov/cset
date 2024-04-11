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
import { Component, Input, OnChanges, OnInit } from '@angular/core';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-edm-relationship',
  templateUrl: './edm-relationship.component.html',
  styleUrls: ['./edm-relationship.component.scss', '../../../../reports/reports.scss']
})
export class EdmRelationshipComponent implements OnInit, OnChanges {
  @Input() section: string;
  scores: any[];
  constructor(public maturitySvc: MaturityService) { }

  ngOnInit(): void {
  }

  ngOnChanges(): void {
    this.getEdmScores();
  }

  getEdmScores() {
    if (!!this.section) {
      this.maturitySvc.getEdmScores(this.section).subscribe(
        (r: any) => {
          if (this.section == "MIL") {
            r = r.filter(function (value, index, arr) { return value.parent.title_Id != "MIL1" });
          }
          this.scores = r;
        },
        error => console.log('RF Error: ' + (<Error>error).message)
      );
    }
  }

  getEdmScoreStyle(score) {
    switch (score.toLowerCase()) {
      case 'red': return 'red-score';
      case 'yellow': return 'yellow-score';
      case 'green': return 'green-score';
      case 'lightgray': return 'light-gray-score'
      default: return 'default-score';
    }
  }
}
