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
import { AssessmentDetail } from './assessment-info.model';

export interface MaturityBasicReportData {
  deficienciesList: any[];
  information: any;
  alternateList: any[];
  comments: any[];
  markedForReviewList: any[];
  questionsList: any[];
  matAnsweredQuestions: any[];
}

/**
 * This interface can/should be cleaned up
 */
export interface CmuReportModel {
  structure?: any;
  cmuResultsData?: CmuResultsModel;
  assessmentDetails?: AssessmentDetail;
  parentScores?: EdmScoreParent[];
  cmuScores?: CmuScoringHelper;
  reportChart?: CmuReportChart;
  criticalService?: string;
  reportData?: MaturityBasicReportData;
  pageNumbers?: { [key: string]: number };
  includeResultsStylesheet?: boolean;
}

export interface CmuResultsModel {
  cmuDomains: CmuMaturityDomainModel[];
}

export interface CmuMaturityDomainModel {
  domainName: string;
  acheivedLevel: number;
  domainScore: number;
  widthValpx: number;
  statsByLevel: CmuMaturityLevelStats[];
}

export interface CmuMaturityLevelStats {
  level: number;
  questionCount: number;
  questionsAnswered: number;
  percentAnswered: number;
}

export interface CmuScoringHelper {
  assessmentId: number;
  cmuModelId: number;
  xDoc: any;
  xCsf: any;
  csfFunctionColors: { [key: string]: string };
}

export interface EDMScore {
  title_Id: string;
  color: string;
  children: EDMScore[];
}

export interface EdmScoreParent {
  parent: EDMScore;
  children: EDMScore[];
}

export interface CmuReportChart {
  labels: string[];
  values: number[];
}

/**
 * Intended to be a generic model that
 * supports the CMU models: EDM, CRR and IMR
 */
export interface CmuReport {
  domains: CmuMaturityDomainModel[];
}
