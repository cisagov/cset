import { ConfigService } from './config.service';
import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class AlertsAndAdvisoriesService {

  private apiUrl: string;

  constructor(private http: HttpClient, private configSvc: ConfigService) {
    this.apiUrl = this.apiUrl = this.configSvc.apiUrl + 'diagram/';
  }

  getAlertsAndAdvisories() {
    return this.http.get(this.apiUrl + 'alertsandadvisories');
  }
}
