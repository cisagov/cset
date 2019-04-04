////////////////////////////////
//
//   Copyright 2019 Battelle Energy Alliance, LLC
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
import { SALLevelNIST } from './nist-sal.models';
export interface NistSalModel {
  Assessment_Id: number;
  Type_Value: string;
  Selected: boolean;
  Confidentiality_Value: string;
  Confidentiality_Special_Factor: string;
  Integrity_Value: string;
  Integrity_Special_Factor: string;
  Availability_Value: string;
  Availability_Special_Factor: string;
  Area: string;
  NIST_Number: string;
}

export interface NistQuestionsAnswers {
  Assessment_Id: number;
  Question_Id: number;
  Question_Answer: string;
  Question_Number: number;
  Question_Text: string;
}

export interface SALLevelNIST {
  SALValue: number;
  SALName: string;
}

export class SALLevelNISTC implements SALLevelNIST {
  SALValue: number;
  SALName: string;
}

export interface NistSpecialFactor {
  Type_Value: string;
  Confidentiality_Special_Factor: string;
  Integrity_Special_Factor: string;
  Availability_Special_Factor: string;
  Confidentiality_Value: SALLevelNIST;
  Integrity_Value: SALLevelNIST;
  Availability_Value: SALLevelNIST;
}



export interface NistModel {
  models: NistSalModel[];
  selectedInfoTypes: NistSalModel[];
  questions: NistQuestionsAnswers[];
  specialFactors: NistSpecialFactor;
}
