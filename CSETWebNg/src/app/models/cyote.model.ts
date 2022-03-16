////////////////////////////////
//
//   Copyright 2021 Battelle Energy Alliance, LLC
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

export interface CaseStudy {
  questions: CyoteQuestion[];
}

export enum CyoteQuestionType {
  YesNo,
  MultipleChoice
}

/**
 * A cyote question
 */
export interface CyoteQuestion {
  id: string;
  text: string;
  type: CyoteQuestionType;
  //condition: any;
  answers: [];
  selectedAnswerIndex?: number;
}

export interface CyoteAnswer {
  text: string;
  value: string;
  question?: CyoteQuestion
}

/**
 * 
 */
export interface CyoteObservable {
  assessmentId: Number;
  sequence: Number;
  observableId: Number;

  title?: string;
  description?: string;

  whenThisHappened?: string;
  approximateStart?: string; // datetime
  approximateEnd?: string; // datetime

  reporter?: string;

  networkCateogry?: boolean;
  physicalCategory?: boolean;
  digitalCategory?: boolean;

  isAffectingOperations?: boolean;
  affectingOperationsText?: string;
  isAffectingProcesses?: boolean;
  affectingProcessesText?: string;
  isMultipleDevices?: boolean;
  multipleDevicesText?: string;
  isMultipleNetworkLayers?: boolean;
  multipleNetworkLayersText?: string;


  observedShouldBeAndWas?: string;
  observedShouldBeAndWasNot?: string;
  observedShouldBeAndCantTell?: string;
  observedShouldNotBeAndWas?: string;
  observedShouldNotBeAndWasNot?: string;
  observedShouldNotBeAndCantTell?: string;
  deepDiveQuestions: any[];
}
