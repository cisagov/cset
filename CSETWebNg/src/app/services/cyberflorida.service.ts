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
    console.log("reset array");
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
  }



  needArray = [];
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
    this.needArray.forEach(function (value) {
      if (value.answer == null) {
        isComplete = isComplete && false;
      }
      else if(value.answer.answerText=='U'){
        isComplete = isComplete && false;
      }
    });
    return isComplete;
  }

  updateCompleteStatus(answer: Answer) {
    if((answer.answerText=='U')){
      return;
    }
    //have a list of all the 20 necessary id's
    //then when the list is complete enable the navigation
    this.needArray.forEach(function (value) {
      if(value.id == answer.questionId)
       value.answer = answer;
    });
  }

  getInitialState(){
    this.clearState();
    return new Promise((resolve, reject)=> {
      this.http.get(this.apiUrl + 'cf/isComplete').toPromise()
      .then((data)=>{          
            for(let a in data){            
              this.updateCompleteStatus(data[a]);
            }
            resolve('initial state pulled');
        }
      );
    }
    )
    
  }
}
