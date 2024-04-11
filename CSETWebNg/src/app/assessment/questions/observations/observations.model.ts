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
export interface Observation {
  // ACET fields
  question_Id: number;
  questionType: string;
  answer_Id: number;
  observation_Id: number;
  summary: string;
  issue: string;
  impact: string;
  recommendations: string;
  vulnerabilities: string;
  resolution_Date: Date;
  importance_Id: number;
  // ISE fields
  title: string;
  type: string;
  risk_Area: string;
  sub_Risk: string;
  description: string;
  citations: string;
  actionItems: string;
  auto_Generated: number;
  supp_Guidance: string;
  // Shared fields
  importance: Importance;
  observation_Contacts: ObservationContact[];
}

export interface SubRiskArea {
  subRisk_Id: number;
  value: string;
  riskArea: string;
}

export interface Importance {
  importance_Id: number;
  value: string;
}

export interface ObservationContact {
  observation_Id: number;
  assessment_Contact_Id: number;
  name: string;
  selected: boolean;
}

export interface ActionItemTextUpdate {
  actionTextItems: ActionItemText[];
  observation_Id: number;
}

export interface ActionItemText {
  Mat_Question_Id: number;
  ActionItemOverrideText: string;
}