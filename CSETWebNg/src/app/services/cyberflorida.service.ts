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
  }


  needArray: { id: number; answer: any; }[];
  needArray2: { id: number; answer: any; }[];
  needArrays: { id: number; answer: any; }[][];

  private apiUrl: string;

  constructor(
    private http: HttpClient,
    private configSvc: ConfigService
    ) {
    this.clearState();
    this.apiUrl = this.configSvc.apiUrl;
  }

  isAssessmentComplete(): boolean {    
    let isComplete = true;
    this.needArrays.forEach((needArray) => {  
      isComplete = true;    
      needArray.forEach(function (value) {
        if (value.answer == null) {
          isComplete = isComplete && false;
        }
        else if(value.answer.answerText=='U'){
          isComplete = isComplete && false;
        }
      });
      if(isComplete)
        return isComplete;
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
}
