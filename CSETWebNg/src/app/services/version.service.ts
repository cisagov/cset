import { Injectable } from '@angular/core';

import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { map, catchError } from 'rxjs/operators';

import { ConfigService } from './config.service';
import { environment } from '../../environments/environment';
import { AppVersion } from '../models/app-version';
import { data } from 'jquery';
import { version } from 'os';

const headers = {
  headers: new HttpHeaders().set("Content-Type", "application/json"),

  params: new HttpParams()
};
@Injectable({
  providedIn: 'root'
})
export class VersionService {
  private csetGithubApiUrl=environment.csetGithubApiUrl
  private apiURLCset=this.configSvc.apiUrl;
  installedVersion:any;
  constructor(
    private http: HttpClient,
    private configSvc: ConfigService
  ) { }

  getGithubLatestRelease():Observable<any>{
    return this.http.get<any>(this.csetGithubApiUrl)
  }
 
  getInstalledVersion():Observable<any>{
   return this.http.get<any>(this.apiURLCset+'version/getVersionNumber')
 }
 
 updateVersion (versions):Observable<any>{
   var test={
    "Id":versions.id,
    "Cset_Version1":versions.cset_Version1,
    "currentVersion":versions.updateVersion
     }
    
  return this.http.post(this.apiURLCset+'saveNewVersionNumber',
   JSON.stringify(
    test
  ),
   headers
  )
 }
}
