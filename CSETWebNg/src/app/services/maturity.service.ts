import { Injectable } from '@angular/core';
import { ConfigService } from './config.service';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { AssessmentService } from './assessment.service';
import { MaturityModel } from "../models/assessment-info.model";
import { MaturityDomainRemarks, QuestionGrouping } from '../models/questions.model';
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

  // Array of Options for Consideration
  ofc: any[];


  cmmcData = null;

  /**
   * 
   * @param http 
   * @param configSvc 
   */
  constructor(
    // private assessSvc: AssessmentService,
    private http: HttpClient,
    private configSvc: ConfigService,
    private assessSvc: AssessmentService
  ) {

  }


  maturityModelIsEDM(): boolean {
    if (MaturityService.currentMaturityModelName == undefined) {
      MaturityService.currentMaturityModelName = this.assessSvc.assessment.MaturityModel.ModelName;
    };
    return MaturityService.currentMaturityModelName == "EDM";
  }

  maturityModelIsCMMC(): boolean {
    if (MaturityService.currentMaturityModelName == undefined) {
      MaturityService.currentMaturityModelName = this.assessSvc.assessment.MaturityModel.ModelName;
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
    const model = this.assessSvc.assessment.MaturityModel;
    if (!!this.assessSvc.assessment && !!model.MaturityTargetLevel) {
      const l = model.Levels.find(x => x.Level == this.assessSvc.assessment.MaturityModel.MaturityTargetLevel);
      if (!!l) {
        return l.Label;
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
    return this.cmmcData
  }

  /**
   * Posts the selected maturity level to the API. 
   * @param level 
   */
  saveLevel(level: number) {
    if (this.assessSvc.assessment) {
      this.assessSvc.assessment.MaturityModel.MaturityTargetLevel = level;
    }
    return this.http.post(
      this.configSvc.apiUrl + "MaturityLevel",
      level,
      headers
    )
  }


  /**
   * 
   */
  getQuestionsList(isAcetInstallation: boolean, fillEmpty: boolean) {
    return this.http.get(
      this.configSvc.apiUrl 
        + "MaturityQuestions?isAcetInstallation=" + isAcetInstallation + '&fill=' + fillEmpty,
      headers
    )
  }

  /**
   * 
   * @param modelName 
   */
  getModel(modelName: string): MaturityModel {
    for (let m of AssessmentService.allMaturityModels) {
      if (m.ModelName == modelName)
        return m;
    }
  }

  /**
   * 
   * @param maturityModel 
   */
  getMaturityDeficiency(maturityModel) {
    return this.http.get(this.configSvc.apiUrl + 'getMaturityDeficiencyList?maturity=' + maturityModel);
  }

  /**
   * 
   * @param maturity 
   */
  getCommentsMarked(maturity) {
    return this.http.get(this.configSvc.apiUrl + 'getCommentsMarked?maturity=' + maturity, headers);
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
}
