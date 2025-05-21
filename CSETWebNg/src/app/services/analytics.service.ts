import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { ConfigService } from './config.service';


@Injectable({
  providedIn: 'root'
})
export class AnalyticsService {
  private apiUrl: string;
  private baseUrl: string;
  private analyticsUrl: string;
  public headers = {
    headers: new HttpHeaders().set('Content-Type', 'application/json'),
    params: new HttpParams()
  };

  /**
   * 
   */
  constructor(private http: HttpClient, private configSvc: ConfigService) {
    this.baseUrl = this.configSvc.apiUrl;
    this.apiUrl = this.baseUrl + "analytics/";
    this.analyticsUrl = this.configSvc.analyticsUrl + "api/";
  }

  /**
   * 
   */
  getAnalytics(): any {
    return this.http.get(this.apiUrl + 'getAggregation');
  }

  /**
   * 
   */
  isCisaAssessorMode() {
    return this.configSvc.installationMode == "IOD";
  }

  /**
   * 
   */
  getAnalyticResults(maturityModelId: number, sectorId?: number): any {
    let url = this.apiUrl + "maturity/bars?"
    if (maturityModelId) {
      url += `&modelId=${maturityModelId}`;
    }
    if (sectorId) {
      url += `&sectorId=${sectorId}`;
    }
    return this.http.get(url);
  }

  /**
   * 
   */
  getAnalyticsToken(username, password): any {
    let obj =  JSON.stringify({
          Email: username,
          Password: password,
          TzOffset: new Date().getTimezoneOffset().toString(),
          Scope: "CSET"
        });
    return this.http.post(
      this.analyticsUrl + 'auth/login', obj, this.headers
    );
  }

  /**
   * 
   */
  postAnalyticsWithLogin(token): any {
    //const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    this.headers.headers = this.headers.headers.append('RemoteAuthorization', `Bearer ${token}`);
    //return this.http.get(this.baseUrl + 'assessment/exportandsend', { headers.headers, observe: 'response', responseType: 'blob' });
     return this.http.get(
      this.baseUrl + 'assessment/exportandsend', this.headers
    );
  }
}