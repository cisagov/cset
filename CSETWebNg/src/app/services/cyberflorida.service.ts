import { Injectable } from '@angular/core';
import { Answer } from '../models/questions.model';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { ConfigService } from './config.service';

const headers = {
  headers: new HttpHeaders().set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable({
  providedIn: 'root'
})
export class CyberFloridaService {
  
  
  clearState() {
    this.needArray = [
      { id: 12297, answer: null },
      { id: 12314, answer: null },
      { id: 12331, answer: null },
      { id: 12334, answer: null },
      { id: 12340, answer: null },
      { id: 12342, answer: null },
      { id: 12343, answer: null },
      { id: 12344, answer: null },
      { id: 12374, answer: null },
      { id: 28188, answer: null },
      { id: 28189, answer: null },
      { id: 28190, answer: null },
      { id: 28191, answer: null },
      { id: 28192, answer: null },
      { id: 28195, answer: null },
      { id: 1920, answer: null },
      { id: 1925, answer: null },
      { id: 1937, answer: null },
      { id: 1938, answer: null },
      { id: 1939, answer: null }
    ];  
    this.needArray2 = [
      { id: 36409, answer: null },
      { id: 36417, answer: null },
      { id: 36419, answer: null },
      { id: 36429, answer: null },
      { id: 36439, answer: null },
      { id: 36442, answer: null },
      { id: 36444, answer: null },
      { id: 36445, answer: null },
      { id: 36479, answer: null },
      { id: 36484, answer: null },
      { id: 36487, answer: null },
      { id: 36491, answer: null },
      { id: 36494, answer: null },
      { id: 36497, answer: null },
      { id: 36503, answer: null },
      { id: 1920, answer: null },
      { id: 1925, answer: null },
      { id: 1937, answer: null },
      { id: 1938, answer: null },
      { id: 1939, answer: null }
    ];
    this.needArrays = [this.needArray, this.needArray2];

    this.needArrayCpg = [
      { id: 9889, answer: null },
      { id: 9896, answer: null },
      { id: 9897, answer: null },
      { id: 9900, answer: null },
      { id: 9901, answer: null },
      { id: 9906, answer: null },
      { id: 9908, answer: null },
      { id: 9909, answer: null },
      { id: 9907, answer: null },
      { id: 9898, answer: null },
      { id: 9889, answer: null },
      { id: 9899, answer: null },
      { id: 9894, answer: null },
      { id: 9895, answer: null },
      { id: 9916, answer: null },
      { id: 9881, answer: null },
      { id: 9883, answer: null },
      { id: 9885, answer: null },
      { id: 9886, answer: null },
      { id: 9884, answer: null },
      { id: 9914, answer: null },
      { id: 9880, answer: null },
      { id: 9882, answer: null },
      { id: 9888, answer: null },
      { id: 9891, answer: null },
      { id: 9913, answer: null },
      { id: 9887, answer: null },
      { id: 9912, answer: null },
      { id: 9911, answer: null },
      { id: 9892, answer: null },
      { id: 9893, answer: null },
      { id: 9890, answer: null },
      { id: 9904, answer: null },
      { id: 9905, answer: null },
      { id: 9915, answer: null },
      { id: 9902, answer: null },
      { id: 9903, answer: null },
      { id: 9910, answer: null },
      { id: 9917, answer: null },

    ]
  }


  needArray: { id: number; answer: any; }[];
  needArray2: { id: number; answer: any; }[];
  needArrays: { id: number; answer: any; }[][];

  needArrayCpg: { id: number; answer: any; }[];

  private apiUrl: string;

  constructor(
    private http: HttpClient,
    private configSvc: ConfigService
    ) {
    this.clearState();
    this.apiUrl = this.configSvc.apiUrl;
  }

  isAssessmentComplete(entryLevel: boolean): boolean {    
    let isComplete = true;
    this.needArrays.forEach((needArray) => {  
      isComplete = true;    
      needArray.forEach(function (value) {
        if (value.answer == null) {
          isComplete = isComplete && false;
        }
        else if (entryLevel) {
          if (value.answer.answerText=='U'){
            isComplete = isComplete && false;
          }
        } 
        else {
          if (value.answer.answerText=='U' || value.answer.answerText=='0' || value.answer.answerText=='NA' || value.answer.answerText=='A'){
            isComplete = isComplete && false;
          }
        }
      });
      if(isComplete)
        return isComplete;
    });
    return isComplete;
  }

  isMidAssessmentComplete(): boolean {    
    let isComplete = true;
    this.needArrayCpg.forEach(function (value) {
      if (value.answer == null) {
        isComplete = false;
      }
      else if(value.answer.answerText=='U'){
        isComplete = false;
      }
    });

    return isComplete;
  }

  updateCompleteStatus(answer: Answer) {  
    //have a list of all the 20 necessary id's
    //then when the list is complete enable the navigation
    this.needArrays.forEach((needArray) => {
      needArray.forEach(function (value) {        
        if(value.id == answer.questionId){
          value.answer = answer;
        }                    
      });
    });
  }

  updateMidCompleteStatus(answer: Answer) {  
    //have a list of all the 38 necessary id's
    //then when the list is complete enable the navigation
    this.needArrayCpg.forEach(function (value) {        
      if(value.id == answer.questionId){
        value.answer = answer;
      }                    
    });
  }

  getInitialState(){
    this.clearState();
    return new Promise((resolve, reject)=> {
      this.http.get(this.apiUrl + 'cf/isComplete').toPromise()
      .then((data: any[])=>{    
          data.forEach(element => {
            for(let a in element){            
              this.updateCompleteStatus(element[a]);
            }  
          });      
          
          resolve('initial state pulled');
        }
      );
    }
    )
    
  }

  getMidInitialState(){
    this.clearState();
    return new Promise((resolve, reject)=> {
      this.http.get(this.apiUrl + 'cf/isMidComplete').toPromise()
      .then((data: any[])=>{    
          data.forEach(element => {
            // for(let a in element){            
              this.updateMidCompleteStatus(element);
            // }  
          });      
          
          resolve('initial state pulled');
        }
      );
    }
    )
    
  }

  getBarChartInfo(){
    return this.http.get(this.apiUrl + 'cf/getAnswerBreakdownForBarChart');
  }

  getScoreBreakdown(){
    return this.http.get(this.apiUrl + 'cf/getScoreBreakdown');
  }

  getTop5Lowest(){
    return this.http.get(this.apiUrl + 'cf/getTop5Lowest');
  }

  getTotalAverageForReports(){
    return this.http.get(this.apiUrl + 'cf/getTotalAverageForReports');
  }
}
