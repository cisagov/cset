import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { ConfigService } from './config.service';
import { Observable } from 'rxjs';

const headers = {
    headers: new HttpHeaders()
        .set('Content-Type', 'application/json'),
    params: new HttpParams()
};

/**
 * A service that provides everything that ACET needs.
 */
@Injectable()
export class ResourceLibraryService {
    apiUrl: string;
    constructor(
        private http: HttpClient,
        private configSvc: ConfigService
    ) { 
        if(this.configSvc.apiUrl){
            this.apiUrl = this.configSvc.apiUrl;
        }
        else{
            this.apiUrl = "http://localhost:46000/api/";
        }
    }

    showResourceLibrary() {
        return this.http.get(this.apiUrl + 'ShowResourceLibrary');
    }
}
