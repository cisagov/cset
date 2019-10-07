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
import { Finding } from "../assessment/questions/findings/findings.model";
import { ConfigService } from "../services/config.service";

export interface QuestionExtrasResponse {
  ListTabs: QuestionInformationTabData[];
}

export interface CustomDocument {
  Title: string;
  File_Name: string;
  Section_Ref: string;
  Is_Uploaded: boolean;
}

/**
 * A document attached to a question answer.
 */
export interface QuestionDocument {
  isEdit?: boolean;
  Document_Id: number;
  Title: string;
  FileName: string;
}

export interface QuestionDetailsContentViewModel {
  SelectedStandardTabIndex: number;
  NoQuestionInformationText: string;
  ShowQuestionDetailTab: boolean;
  IsDetailAndInfo: boolean;
  IsNoQuestion: boolean;
  SelectedTabIndex: number;
  ListTabs: QuestionInformationTabData[];
  Findings: Finding[];
  Documents: QuestionDocument[];
}

export interface QuestionInformationTabData {
  RequirementFrameworkTitle: String;
  RelatedFrameworkCategory: String;
  ShowRequirementFrameworkTitle: boolean;
  Question_or_Requirement_Id: number;
  RequirementsData: RequirementTabData;
  ResourceDocumentList: CustomDocument[];
  SourceDocumentsList: CustomDocument[];
  References: string;
  ComponentTypes: ComponentOverrideLinkInfo[];
  ComponentVisibility: boolean;
  QuestionsVisible: boolean;
  ShowSALLevel: boolean;
  ShowRequirementStandards: boolean;
  FrameworkQuestions: FrameworkQuestionItem[];
  LevelName: String;
  IsCustomQuestion: boolean;
  IsComponent: boolean;
  SetsList: string[];
  QuestionsList: string[];
  ShowNoQuestionInformation: boolean;
  ExaminationApproach: String;
  Is_Component: boolean;
}

export interface RequirementTabData {
  Text: String;
  SupplementalInfo: String;
  Set_Name: string;
  ExaminationApproach: String;
}

export class CustomDocument {
  constructor(public configSvc: ConfigService) {}

  Title: string;
  File_Name: string;
  Section_Ref: string;
  Is_Uploaded: boolean;
  get Url(): string {
    return (
      (this.Is_Uploaded
        ? this.configSvc.apiUrl + '/ReferenceDocuments/'
        : this.configSvc.docUrl) +
      this.File_Name +
      '#' +
      this.Section_Ref
    );
  }
}

export interface ComponentOverrideLinkInfo {
  TypeComponetXML: string;
  Type: string;
  Enabled: boolean;
}

export interface FrameworkQuestionItem {
  QuestionText: String;
  Standard: String;
  Reference: String;
  RequirementID: number;
  SetName: string;
  CategoryAndQuestionNumber: string;
}
