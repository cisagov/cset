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
export interface NistSalModel {
  assessment_Id: number;
  type_Value: string;
  selected: boolean;
  confidentiality_Value: string;
  confidentiality_Special_Factor: string;
  integrity_Value: string;
  integrity_Special_Factor: string;
  availability_Value: string;
  availability_Special_Factor: string;
  area: string;
  nist_Number: string;
}

export interface NistQuestionsAnswers {
  assessment_Id: number;
  question_Id: number;
  question_Answer: string;
  question_Number: number;
  question_Text: string;
}

export interface SALLevelNIST {
  salValue: number;
  salName: string;
}

export class SALLevelNISTC implements SALLevelNIST {
  salValue: number;
  salName: string;
}

export interface NistSpecialFactor {
  type_Value: string;
  confidentiality_Special_Factor: string;
  integrity_Special_Factor: string;
  availability_Special_Factor: string;
  confidentiality_Value: SALLevelNIST;
  integrity_Value: SALLevelNIST;
  availability_Value: SALLevelNIST;
}



export interface NistModel {
  models: NistSalModel[];
  selectedInfoTypes: NistSalModel[];
  questions: NistQuestionsAnswers[];
  specialFactors: NistSpecialFactor;
}
