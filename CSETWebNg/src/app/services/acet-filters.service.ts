import { Injectable } from '@angular/core';
import { HttpHeaders, HttpParams, HttpClient } from '@angular/common/http';
import { ConfigService } from './config.service';
import { AssessmentService } from './assessment.service';
import { Domain } from '../models/questions.model'



const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

export class ACETFilter{
  DomainName: string;
  DomainId: number;
  B: boolean;
  E: boolean;
  Int: boolean;
  A: boolean;
  Inn: boolean;
}

@Injectable({
  providedIn: 'root'
})
export class AcetFiltersService {
  
  

  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    private assessmentSvc: AssessmentService
  ) {
    
  }

  getACETDomains() {
    return this.http.get(this.configSvc.apiUrl + 'ACETDomains');
  }

  getFilters(){
    return this.http.get(this.configSvc.apiUrl + 'GetAcetFilters');
  }

  saveFilter(domainName: string, f: string, e: any) {

    var filter = {DomainName: domainName, Field: f, Value: e};    
    return this.http.post(this.configSvc.apiUrl + 'SaveAcetFilter', filter, headers);
  }

  saveFilters(filters: Map<string, Map<string, boolean>>){
    var saveValue: ACETFilter[] = [];
        
    for(let entry of  Array.from(filters.entries()))
    {
      let x:ACETFilter  =  new ACETFilter();
      x.DomainName  = entry[0];
      x.DomainId = 0; 
      x.B =  entry[1].get('B');
      x.E = entry[1].get('E');
      x.Int = entry[1].get('Int');
      x.A = entry[1].get('A');
      x.Inn = entry[1].get('Inn');    
      saveValue.push(x);
    }

    return this.http.post(this.configSvc.apiUrl + 'SaveAcetFilters', saveValue, headers);
  }
}

