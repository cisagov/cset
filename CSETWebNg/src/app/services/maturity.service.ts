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
import { Injectable } from '@angular/core';
import { ConfigService } from './config.service';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { AssessmentService } from './assessment.service';
import { MaturityModel } from "../models/assessment-info.model";
import { MaturityDomainRemarks } from '../models/questions.model';
const headers = {
  headers: new HttpHeaders().set("Content-Type", "application/json"),
  params: new HttpParams()
};

@Injectable({
  providedIn: 'root'
})
export class MaturityService {


  static currentMaturityModelName: string;

  domains: any[];

  keyToCategory = {
    AC: 'Access Control',
    AM: 'Asset Management',
    AU: 'Audit and Accountability',
    AT: 'Awareness and Training',
    CM: 'Configuration Management',
    IA: 'Identification And Authentication',
    IR: 'Incident Response',
    MA: 'Maintenance',
    MP: 'Media Protection',
    PS: 'Personnel Security',
    PE: 'Physical Protection',
    RM: 'Risk Management',
    CA: 'Security Assessment',
    SA: 'Situational Awareness',
    SC: 'System and Communications Protection',
    SI: 'System And Information Integrity'
  }

  // Array of Options for Consideration
  ofc: any[];


  cmmcData = null;

  mvraGroupings = [];
  cisGroupings = [];

  /**
   *
   * @param http
   * @param configSvc
   */
  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    private assessSvc: AssessmentService
  ) {

    // get MVRA grouping titles
    this.getGroupingTitles(9).subscribe((l: any[]) => {
      this.mvraGroupings = l;
    });

    // get CIS grouping titles
    this.getGroupingTitles(8).subscribe((l: any[]) => {
      this.cisGroupings = l;
    });
  }


  maturityModelIsEDM(): boolean {
    if (!MaturityService.currentMaturityModelName && !!this.assessSvc.assessment?.maturityModel) {
      MaturityService.currentMaturityModelName = this.assessSvc.assessment.maturityModel?.modelName;
    };
    return MaturityService.currentMaturityModelName == "EDM";
  }

  maturityModelIsCMMC(): boolean {
    if (!MaturityService.currentMaturityModelName && !!this.assessSvc.assessment?.maturityModel) {
      MaturityService.currentMaturityModelName = this.assessSvc.assessment.maturityModel?.modelName;
    };
    return MaturityService.currentMaturityModelName == "CMMC";
  }

  /**
   * Posts the current selections to the server.
   */
  postSelection(modelName: string) {
    MaturityService.currentMaturityModelName = modelName;
    return this.http.post(
      this.configSvc.apiUrl + "MaturityModel?modelName=" + modelName,
      null,
      headers
    );
  }

  getDomainObservations() {
    return this.http.get(this.configSvc.apiUrl + "MaturityModel/DomainRemarks",
      headers)
  }

  postDomainObservation(group: MaturityDomainRemarks) {
    return this.http.post(
      this.configSvc.apiUrl + "MaturityModel/DomainRemarks",
      group,
      headers
    );
  }

  /**
   * Gets the saved maturity level from the API.
   * If we store this in the assessment service 'assessment' object,
   * there is no need to go to the API for this.
   */
  getLevel() {
    return this.http.get(
      this.configSvc.apiUrl + "MaturityLevel",
      headers
    )
  }

  /**
   * Returns the name of the current target level.
   */
  targetLevelName() {
    const model = this.assessSvc.assessment.maturityModel;
    if (!!this.assessSvc.assessment && !!model.maturityTargetLevel) {
      const l = model.levels.find(x => x.level == this.assessSvc.assessment.maturityModel.maturityTargetLevel);
      if (!!l) {
        return l.label;
      }
      return '???';
    }
    else {
      return '???';
    }
  }

  /**
   *
   * @param reportId
   */
  public getResultsData(reportId: string) {
    if (!this.cmmcData) {
      this.cmmcData = this.http.get(this.configSvc.apiUrl + 'reports/' + reportId);
    }
    return this.cmmcData;
  }

  public getCmmcReportData() {
    return this.http.get(this.configSvc.apiUrl + 'reportscmmc/maturitymodel')
  }

  /**
   *
   */
  public getTargetLevel() {
    return this.http.get(this.configSvc.apiUrl + 'maturity/targetlevel');
  }
  /**
   *
   */
  public getComplianceByLevel() {
    return this.http.get(this.configSvc.apiUrl + 'results/compliancebylevel');
  }

  /**
   *
   */
  public getComplianceByDomain() {
    return this.http.get(this.configSvc.apiUrl + 'results/compliancebydomain');
  }

  /**
   * Posts the selected maturity level to the API.
   * @param level
   */
  saveLevel(level: number) {
    if (this.assessSvc.assessment) {
      this.assessSvc.assessment.maturityModel.maturityTargetLevel = level;
    }
    return this.http.post(
      this.configSvc.apiUrl + "MaturityLevel",
      level,
      headers
    )
  }


  /**
   * Asks the API for all maturity questions/answers for the current assessment. 
   */
  getQuestionsList(fillEmpty: boolean, groupingId?: number) {
    let url = this.configSvc.apiUrl + 'maturity/questions?fill=' + fillEmpty;

    if (!!groupingId) {
      url = url + '&groupingId=' + groupingId;
    }

    return this.http.get(url, headers);
  }

  /**
   * Asks the API for one grouping's worth of questions/answers.
   */
  getGroupingQuestions(groupingId: Number) {
    return this.http.get(this.configSvc.apiUrl
      + 'maturity/questions/grouping?groupingId=' + groupingId);
  }

  /**
   * Asks the API for 'bonus' (SSG) questions.
   */
  getBonusQuestionList(bonusModelId: number) {
    return this.http.get(this.configSvc.apiUrl
      + 'maturity/questions/bonus?m=' + bonusModelId);
  }

  /**
   * Calls the MaturityStructure endpoint.  Specifying a domain abbreviation will limit
   * the response to a specific domain.
   */
  getStructure(domainAbbrev: string = '') {
    var url = this.configSvc.apiUrl + 'MaturityStructure'
    if (domainAbbrev != '') {
      url = url + '?domainAbbrev=' + domainAbbrev;
    }

    return this.http.get(url, headers);
  }

  /**
   *
   * @param modelName
   */
  getModel(modelName: string): MaturityModel {
    for (let m of AssessmentService.allMaturityModels) {
      if (m.modelName == modelName)
        return m;
    }
  }

  /**
   * Indicates whether to show the scoring bar chart
   * on MaturityQuestionsNested.
   * Someday this could be set in the MATURITY_MODELS table as a profile item
   * for each model that uses the nested questions structure.
   */
  showChartOnNestedQPage(): boolean {
    if (this.assessSvc.assessment.maturityModel.modelName == "CIS") {
      return true;
    }
    return false;
  }

  /**
   *
   * @param maturityModel
   */
  getMaturityDeficiency(maturityModel) {
    return this.http.get(this.configSvc.apiUrl + 'maturity/deficiency?model=' + maturityModel);
  }

  getMaturityDeficiencySd() {
    return this.http.get(this.configSvc.apiUrl + 'getMaturityDeficiencyListSd');
  }

  getMaturityDeficiencySdOwner() {
    return this.http.get(this.configSvc.apiUrl + 'getMaturityDeficiencyListSdOwner');
  }

  /**
   *
   * @param maturity
   */
  getCommentsMarked() {
    return this.http.get(this.configSvc.apiUrl + 'getCommentsMarked', headers);
  }

  /**
   *
   * @param section
   */
  getEdmScores(section) {
    return this.http.get(this.configSvc.apiUrl + 'getEdmScores?section=' + section, headers);
  }

  /**
   *
   */
  getMatDetailEDMAppendixList() {
    return this.http.get(this.configSvc.apiUrl + 'getEdmNistCsfResults');
  }

  getEdmPercentScores() {
    return this.http.get(this.configSvc.apiUrl + 'getEdmPercentScores')
  }

  getSPRSScore() {
    return this.http.get(this.configSvc.apiUrl + 'SPRSScore');
  }
  /**
   *
   * @param modelName
   */
  getReferenceText(modelName) {
    return this.http.get(this.configSvc.apiUrl + 'referencetext?model=' + modelName, headers);
  }

  /**
   * @param maturityModel
   */
  getGlossary(maturityModel: string) {
    return this.http.get(this.configSvc.apiUrl + 'getGlossary?model=' + maturityModel);
  }


  /**
   * Returns SVG markup for the the specified
   *    domain abbreviation (AM, SCM, etc)
   *    and MIL (MIL-1, MIL-2) etc.
   * Scaling the SVG to 1.5 gives a nice readable chart.
   */
  getMilHeatmapWidget(domain: string, mil: string) {
    return this.http.get(this.configSvc.apiUrl + 'cmu/widget/heatmap?domain=' + domain + '&mil=' + mil + '&scale=1.5',
      { responseType: 'text' }
    );
  }

  /**
   *
   */
  getGroupingTitles(modelId: number) {
    return this.http.get(this.configSvc.apiUrl + 'maturity/groupingtitles?modelId=' + modelId);
  }

  getMvraScoring() {
    return this.http.get(this.configSvc.apiUrl + 'maturity/mvra/scoring');
  }

  getHydroResults() {
    return this.http.get(this.configSvc.apiUrl + 'maturity/hydro/getResultsData');
  }

  getMyCieAssessments() {
    return this.http.get(this.configSvc.apiUrl + 'maturity/cie/myCieAssessments');
  }
}
