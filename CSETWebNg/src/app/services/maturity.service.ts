import { Injectable } from '@angular/core';
import { ConfigService } from './config.service';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { AssessmentService } from './assessment.service';
import {MaturityModel} from "../models/assessment-info.model";
const headers = {
  headers: new HttpHeaders().set("Content-Type", "application/json"),
  params: new HttpParams()
};

@Injectable({
  providedIn: 'root'
})
export class MaturityService {
  

  static currentMaturityModel: string;
  static allMaturityModels: MaturityModel[];
  /**
   * These are specific to CMMC and will need to be configured somewhere,
   * and not hard coded.
   */
  availableLevels = [
    { Label: "Level 1", Level: 1 },
    { Label: "Level 2", Level: 2 },
    { Label: "Level 3", Level: 3 },
    { Label: "Level 4", Level: 4 },
    { Label: "Level 5", Level: 5 }
  ];

  cmmcData = null;

  /**
   * 
   * @param http 
   * @param configSvc 
   */
  constructor(
    private assessSvc: AssessmentService,
    private http: HttpClient,
    private configSvc: ConfigService
  ) {
      this.http.get(
        this.configSvc.apiUrl + "MaturityModels",
        headers
      ).subscribe((data: MaturityModel[]) => {
          MaturityService.allMaturityModels = data;
        }      
      );
   }


  maturityModelIsEDM(): boolean{
    if(MaturityService.currentMaturityModel==undefined){
      MaturityService.currentMaturityModel = this.assessSvc.assessment.MaturityModel.ModelName;
    };
    return MaturityService.currentMaturityModel == "EDM";
  }

  /**
   * Posts the current selections to the server.
   */
  postSelection(modelName: string) {
    MaturityService.currentMaturityModel = modelName;
    return this.http.post(
      this.configSvc.apiUrl + "MaturityModel?modelName=" + modelName,
      null,
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
    if (!!this.assessSvc.assessment && !!this.assessSvc.assessment.MaturityModel.MaturityTargetLevel) {
      const l = this.availableLevels.find(x => x.Level == this.assessSvc.assessment.MaturityModel.MaturityTargetLevel);
      if (!!l) {
        return l.Label;
      }
      return '???';
    }
    else {
      return '???';
    }
  }

  
  public getResultsData(reportId: string) {      
    if(!this.cmmcData) {
      this.cmmcData =  this.http.get(this.configSvc.apiUrl+ 'reports/' + reportId);
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
  getQuestionsList( isAcetInstallation:boolean) {
    return this.http.get(
      this.configSvc.apiUrl + "MaturityQuestions?isAcetInstallation="+isAcetInstallation,
      headers
    )
  }

  getModel(modelName: string): MaturityModel{
    for (let m of MaturityService.allMaturityModels){
      if(m.ModelName == modelName)
        return m;
    }
  }

}