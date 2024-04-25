import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { ConfigService } from './config.service';


@Injectable({
  providedIn: 'root'
})
export class AnalyticsService {
  private apiUrl: string;
  private analyticsUrl: string;
  public headers = {
    headers: new HttpHeaders().set('Content-Type', 'application/json'),
    params: new HttpParams()
  };



  constructor(private http: HttpClient, private configSvc: ConfigService) {
    this.apiUrl = this.configSvc.apiUrl + "analytics/";
    this.analyticsUrl = this.configSvc.analyticsUrl + "api/";

  }

  getAnalytics(): any {
    return this.http.get(this.apiUrl + 'getAggregation');
  }

  getAnalyticsToken(username, password): any {
    return this.http.post(
      this.analyticsUrl + 'auth/login', { username, password }, this.headers
    );
  }

  postAnalyticsWithLogin(analytics, token): any {
    let header: HttpHeaders = new HttpHeaders();
    header = header.append('Content-Type', 'application/json');
    header = header.append("Authorization", "Bearer " + token);
    console.log(token);
    console.log(analytics);
    let params: HttpParams = new HttpParams();

    return this.http.post(
      this.analyticsUrl + 'assessment/saveassessment', analytics, { headers: header, params }
    );
  }

  // pingAnalyticsService(): any {
    // return this.http.get(this.analyticsUrl + 'ping/GetPing');
  // }
}