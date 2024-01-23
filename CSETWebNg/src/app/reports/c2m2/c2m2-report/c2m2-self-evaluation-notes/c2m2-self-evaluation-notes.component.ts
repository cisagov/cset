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
import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'app-c2m2-self-evaluation-notes',
  templateUrl: './c2m2-self-evaluation-notes.component.html',
  styleUrls: ['../c2m2-report.component.scss', '../../../reports.scss']
})
export class C2m2SelfEvaluationNotesComponent implements OnInit {

  constructor() { }

  @Input() tableData: any = null;
  loading: boolean = true;
  domainTitles = [];
  domainCategories = [];
  hasComments = new Map();

  commentTableData: {
    id: string, // ASSET-1a
    mil: string, // 1
    practiceText: string, // "IT and OT assets that are important to..."
    response: string, // "Fully Implemented (FI)"
    comment: string // "My comment!"
  }[] = [];


  ngOnInit(): void {
    this.parseData();
    this.loading = false;
  }

  parseData() {
    for (let i = 0; i < this.tableData.domainList.length; i++) {
      // Domain Title ==> "Manage IT and OT Asset Inventory"
      this.domainTitles.push(this.tableData.domainList[i].title);

      // Domain Category ==> "ASSET-1a" or "THREAT-2c". Modified removes the text after the dash.
      let category = this.tableData.domainList[i].objectives[0].practices[0].title;
      let modifiedCategory = category.split('-')[0];

      if (modifiedCategory === 'THIRD') {
        this.domainCategories.push('THIRD-PARTIES'); // Third-parties is the only domain with a '-' inside the domain.
      } else {
        this.domainCategories.push(modifiedCategory);
      }

      // Table Data
      for (let j = 0; j < this.tableData.domainList[i].objectives.length; j++) {
        for (let k = 0; k < this.tableData.domainList[i].objectives[j].practices.length; k++) {
          let myData = this.tableData.domainList[i].objectives[j].practices[k];

          if (myData.comment !== null && myData.comment !== '') {
            this.hasComments.set(modifiedCategory, true);

            this.commentTableData.push({
              "id": myData.title,
              "mil": (myData.mil = myData.mil.split('-')[1]),
              "practiceText": myData.questionText,
              "response": (myData.answerText != null ? myData.answerText : 'U'),
              "comment": myData.comment
            });
          }
        }
      }

      if (i === this.tableData.domainList.length - 1) {
        this.loading = false;
      }
    }
  }

  getBackgroundColor(answer: string) {
    switch (answer) {
      case 'FI':
        return '#265B94';
      case 'LI':
        return '#90A5C7';
      case 'PI':
        return '#F5DA8C';
      case 'NI':
        return '#DCA237';
      case 'U':
      case null:
        return '#E6E6E6';
    }
  }

  getTextColor(answer: string) {
    if (answer == 'FI') {
      return 'white';
    } else {
      return 'black';
    }
  }

  checkForComments(category: string) {
    if (this.hasComments.get(category) === true) {
      return true;
    } else {
      return false;
    }
  }

  checkCategory(id: string, category: string) {
    if (id.split('-')[0] === category) {
      return true;
    } else {
      return false;
    }
  }

  fullNameTranslate(answerText: string) {
    if (answerText == 'FI') {
      return 'Fully Implemented (PI)';
    }
    if (answerText == 'LI') {
      return 'Largely Implemented (PI)';
    }
    if (answerText == 'PI') {
      return 'Partially Implemented (PI)';
    }
    if (answerText == 'NI') {
      return 'Not Implemented (NI)';
    }
    return 'Unanswered (U)';
  }

}
