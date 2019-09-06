import { Injectable } from '@angular/core';
import { HttpHeaders, HttpParams, HttpClient } from '@angular/common/http';
import { InventoryConfigService } from './config.service';

@Injectable({
    providedIn: 'root'
  })
  export class DiagramService {
    private apiUrl: string;
  
  
  
    constructor(private http: HttpClient, private configSvc: InventoryConfigService) {
      this.apiUrl = this.configSvc.apiUrl + "diagram/";
    }
  
    getSymbols() {
      return this.http.get(this.apiUrl + 'symbols/get');
    }
  }