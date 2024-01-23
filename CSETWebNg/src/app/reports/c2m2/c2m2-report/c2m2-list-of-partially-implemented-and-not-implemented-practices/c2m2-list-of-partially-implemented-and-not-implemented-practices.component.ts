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

@Component({
  selector: 'app-c2m2-list-of-partially-implemented-and-not-implemented-practices',
  templateUrl: './c2m2-list-of-partially-implemented-and-not-implemented-practices.component.html',
  styleUrls: ['../c2m2-report.component.scss', '../../../reports.scss']
})
export class C2m2ListOfPartiallyImplementedAndNotImplementedPracticesComponent implements OnInit {

  @Input() tableData: any;
  domainList: any[] = [];
  rowspanList: any[] = []; // 10 objects (all 10 domains)
  answerTextList: any[] = [];
  mils: string[] = ['MIL-1', 'MIL-2', 'MIL-3'];
  milSortedDomainList: any[] = [];
  loading: boolean = true;

  constructor() { }

  ngOnInit(): void {
    // 1. separate by MIL (1, 2, 3)
    // 2. separate by answerChoice (PI, NI, U)
    // 3. make sure the last 3 points of data are grouped: [title (ID), questionText (Practice), comment (Self-Evaluation Notes)]
    this.domainList = this.tableData.domainList;

    this.reorderByMIL();

    this.loading = false;
  }

  styleSwitcher(answerText: string) {
    if (answerText == 'PI') {
      return 'pi-background';
    }
    if (answerText == 'NI') {
      return 'ni-background';
    }
    return 'u-background';
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

  nullReplaceWithEmpty(isThisNull: any) {
    if (isThisNull == null) {
      return '';
    }
    return isThisNull;
  }

  nullReplaceWithU(answerText: string) {
    if (answerText == null) {
      return 'U';
    }
    return answerText;
  }

  checkIfNewMilSection(domainMilGroup: any[], currentIndex: number) {
    if (currentIndex == 0) {
      return true;
    }

    let lengthOfMil = 0;
    for (let i = 0; i < domainMilGroup.length; i++) {
      if (i > 0) {
        lengthOfMil += domainMilGroup[i - 1];

        if (lengthOfMil == currentIndex) { // if true, the currentIndex has caught up 
          return true;                     // with the current rowspan length, and a new one is needed
        }
      }
    }

    return false;
  }

  getNewMilSection(domainMilGroup: any[], currentIndex: number, domainNumber: number) {
    let lengthOfMil = 0;

    for (let i = 0; i < domainMilGroup.length; i++) {
      if (currentIndex == 0) {
        lengthOfMil = domainMilGroup[i];
        if (lengthOfMil > 0) {
          // for some reason, the rowspan subtracts the number of different answerTexts in this MIL, so the function counters that
          return this.howManyDifferentAnswersInMil(domainNumber, i) + lengthOfMil;
        }
      }
      else {
        if (i > 0) {
          lengthOfMil += domainMilGroup[i - 1]; // increments to try and match up with the currentIndex

          if (lengthOfMil > 0 && lengthOfMil == currentIndex) {
            return this.howManyDifferentAnswersInMil(domainNumber, i) + domainMilGroup[i];
          }
        }
      }
    }
  }

  checkIfNewAnswerSection(domainMilGroup: any[], currentMil: number, currentIndex: number) {
    let sectionGroup = domainMilGroup[currentMil - 1]; // '-1' to start the array at index 0

    let previousRowspans = 0;

    for (let i = 0; i < currentMil - 1; i++) {
      let previousSectionGroup = domainMilGroup[i];
      for (let j = 0; j < previousSectionGroup.length; j++) {
        previousRowspans += previousSectionGroup[j];
      }
    }

    let lengthOfSection = previousRowspans; //lets lengthOfSection have context of what the previous rowspans were

    // automatically assumes it needs a new rowspan if it's the first index
    // (assuming the DOM handles 100% empty domains, so this shouldn't cause an error on blank domains)
    if (currentIndex == 0) {
      return true;
    }

    for (let i = 0; i < sectionGroup.length; i++) {
      if (lengthOfSection == currentIndex && i == 0) { // if true, the currentIndex has reached the end of the current rowspan
        return true;
      }
      let sectionValue = sectionGroup[i];
      lengthOfSection += sectionValue; // increments to try and match up with the currentIndex

      if (lengthOfSection == currentIndex) { // if true, the currentIndex has reached the end of the current rowspan
        return true;
      }
    }

    return false;
  }

  getNewAnswerSection(domainMilGroup: any[], currentMil: number, currentIndex: number) {
    let sectionGroup = domainMilGroup[currentMil - 1];

    let previousIndexes = 0;

    for (let i = 0; i < currentMil - 1; i++) {
      let previousSectionGroup = domainMilGroup[i];
      for (let j = 0; j < previousSectionGroup.length; j++) {
        previousIndexes += previousSectionGroup[j];
      }
    }

    let lengthOfSection = previousIndexes; //lets lengthOfSection have context of what the previous rowspans were

    for (let i = 0; i < sectionGroup.length; i++) {
      if (lengthOfSection == currentIndex && currentIndex != 0 && sectionGroup[i] != 0) { // when there's a match, get the next rowspan's length         
        return sectionGroup[i];
      }
      let sectionValue = sectionGroup[i];
      lengthOfSection += sectionValue; // increments to try and match up with the currentIndex
      if (currentIndex == 0) { // if it's the first item, return the first non-zero rowspan length
        if (lengthOfSection > 0) {
          return lengthOfSection;
        }
      }

      if (lengthOfSection == currentIndex && currentIndex > 0 && sectionGroup[i + 1] != 0) { // when there's a match, get the next rowspan's length
        return sectionGroup[i + 1];
      }
    }
  }

  reorderByMIL() {
    for (let i = 0; i < this.domainList.length; i++) {
      let domain = this.domainList[i];
      let newPracticeArray = [];
      let newMilArray = [];
      let newAnswerArray = [];
      let newMil1AnswerArray = [];
      let newMil2AnswerArray = [];
      let newMil3AnswerArray = [];


      let mil1Counter = 0;
      let mil1PICounter = 0;
      let mil1NICounter = 0;
      let mil1UCounter = 0;

      let mil2Counter = 0;
      let mil2PICounter = 0;
      let mil2NICounter = 0;
      let mil2UCounter = 0;


      let mil3Counter = 0;
      let mil3PICounter = 0;
      let mil3NICounter = 0;
      let mil3UCounter = 0;


      for (let j = 0; j < domain.objectives.length; j++) {
        let objective = domain.objectives[j];
        for (let k = 0; k < objective.practices.length; k++) {
          let practice = objective.practices[k];

          if (practice.answerText != 'FI' && practice.answerText != 'LI') {
            newPracticeArray.push(practice);

            let milNumber = +practice.mil.charAt(practice.mil.indexOf('-') + 1);
            let answerText = this.nullReplaceWithU(practice.answerText);
            if (milNumber == 1) {
              mil1Counter++;
              if (answerText == 'PI') {
                mil1PICounter++;
              }
              if (answerText == 'NI') {
                mil1NICounter++;
              }
              if (answerText == 'U') {
                mil1UCounter++;
              }
            }
            if (milNumber == 2) {
              mil2Counter++;
              if (answerText == 'PI') {
                mil2PICounter++;
              }
              if (answerText == 'NI') {
                mil2NICounter++;
              }
              if (answerText == 'U') {
                mil2UCounter++;
              }
            }
            if (milNumber == 3) {
              mil3Counter++;
              if (answerText == 'PI') {
                mil3PICounter++;
              }
              if (answerText == 'NI') {
                mil3NICounter++;
              }
              if (answerText == 'U') {
                mil3UCounter++;
              }
            }
          }
        }
      }

      newMilArray.push(mil1Counter);
      newMilArray.push(mil2Counter);
      newMilArray.push(mil3Counter);

      newMil1AnswerArray.push(mil1PICounter);
      newMil1AnswerArray.push(mil1NICounter);
      newMil1AnswerArray.push(mil1UCounter);

      newMil2AnswerArray.push(mil2PICounter);
      newMil2AnswerArray.push(mil2NICounter);
      newMil2AnswerArray.push(mil2UCounter);

      newMil3AnswerArray.push(mil3PICounter);
      newMil3AnswerArray.push(mil3NICounter);
      newMil3AnswerArray.push(mil3UCounter);

      newPracticeArray.sort((prac1, prac2) => {
        let prac1Mil = +prac1.mil.charAt(prac1.mil.indexOf('-') + 1);
        let prac2Mil = +prac2.mil.charAt(prac2.mil.indexOf('-') + 1);

        if (prac1Mil > prac2Mil) { //prac1's MIL is larger than prac2's
          return 1;
        }
        if (prac1Mil < prac2Mil) { //prac1's MIL is smaller than prac2's
          return -1;
        }

        //if it makes it here, both MILs are the same. Order by answerText from here on out (1.PI, 2.NI, 3.U)
        //let prac1Answer = this.answerToValue(prac1.answerText);
        if (this.answerToValue(prac1.answerText) > this.answerToValue(prac2.answerText)) {
          return 1;
        }
        if (this.answerToValue(prac1.answerText) < this.answerToValue(prac2.answerText)) {
          return -1;
        }

        return 0;
      });

      newAnswerArray.push(newMil1AnswerArray);
      newAnswerArray.push(newMil2AnswerArray);
      newAnswerArray.push(newMil3AnswerArray);

      this.milSortedDomainList.push(newPracticeArray);
      this.rowspanList.push(newMilArray);
      this.answerTextList.push(newAnswerArray);
    }

  }

  answerToValue(answerText: string) {
    if (answerText == 'PI') {
      return 1;
    }
    if (answerText == 'NI') {
      return 2;
    }
    if (answerText == null || answerText == 'U') { // 'U'
      return 3;
    }
  }

  howManyDifferentAnswersInMil(domain: number, mil: number) {

    let answerGroups = this.answerTextList[domain]; // this is the 3x3 group (3 possible answers [PI,NI,U], 3 possible MILs) for the wanted domain
    let milAnswerGroup = answerGroups[mil];
    let count = 0;
    for (let value of milAnswerGroup) {
      if (value != 0) {
        count++;
      }
    }
    return count + 1;
  }

}
