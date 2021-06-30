import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { CmmcStyleService } from './cmmc-style.service';
import { ConfigService } from './config.service';


const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable({
  providedIn: 'root'
})
export class RraDataService {
  apiUrl: string;
  constructor(public cmmcSvc:CmmcStyleService,private http: HttpClient, private configSvc: ConfigService) {
    this.apiUrl = this.configSvc.apiUrl + 'reports';
    
  }

  response: any;
  pageInitialized = false;
  referenceTable: any;

  cmmcModel: any;
  statsByLevel: any;
  statsByDomain: any;
  statsByDomainAtUnderTarget: any;
  stackBarChartData: any;
  complianceLevelAcheivedData: any;
  gridColumnCount = 10
  gridColumns = new Array(this.gridColumnCount);

  public getRRADetail(){
    return this.http.get(this.apiUrl + '/rradetail')
  }
  
  public getRRAQuestions() {
    return this.http.get(this.apiUrl + '//rraquestions')
  }
}
