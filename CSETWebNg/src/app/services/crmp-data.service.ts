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
export class CrmpDataService {
  apiUrl: string;
  constructor(public cmmcSvc:CmmcStyleService,private http: HttpClient, private configSvc: ConfigService) {
    this.apiUrl = this.configSvc.apiUrl + 'results';
    console.log(this.apiUrl);
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
  crmpData = null;


  public getCRMPDetail(){
    return this.http.get(this.apiUrl + '/crmpSiteSummary')
  }
  
  public getCRMPQuestions() {
    return this.http.get(this.apiUrl + '/crmpquestions')
  }

  /**
   *
   * @param reportId
   */
   public getResultsData(reportId: string) {
    if (!this.crmpData) {
      this.crmpData = this.http.get(this.apiUrl + '/' + reportId);
    }
    return this.crmpData;
  }
}