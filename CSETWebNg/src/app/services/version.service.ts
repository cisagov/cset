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

  // private apiUrl = this.configSvc.versionApiUrl + 'aAP/';
  private apiUrl='http://localhost:5001/api/AppVersion';
  // private apiUrl=environment.downloadApiUrl
  private apiURLCset=this.configSvc.apiUrl;
  installedVersion:any;
  constructor(
    private http: HttpClient,
    private configSvc: ConfigService
  ) { }
  getLatestVersion(): Observable<AppVersion> {
    return this.http.get<AppVersion>(this.apiUrl);
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
  isNewerVersionAvailable(): Observable<{ isNewer: boolean, version: AppVersion}> {
    return this.getLatestVersion()
      .pipe(
        map(version => {
        var  currentVersion =[]

          if(localStorage.getItem('versionNotificationViewed')==null){
          // currentVersion=this.installedVersion
          }

          if( (localStorage.getItem('nonExistent') != '' || localStorage.getItem('nonExistent') !=null)){
            currentVersion=(localStorage.getItem('versionNotificationViewed').split('.').map(x => parseInt(x, 10)))
          }else
          {
            currentVersion = environment.version.split('.').map(x => parseInt(x, 10));
            localStorage.setItem('versionNotificationViewed',environment.version)
          }
          if(version.majorVersion > currentVersion[0] ||
             (version.majorVersion === currentVersion[0] && version.minorVersion > currentVersion[1]) ||
             (version.majorVersion === currentVersion[0] && version.minorVersion === currentVersion[1] && version.patch > currentVersion[2]) ||
             (version.majorVersion === currentVersion[0] && version.minorVersion === currentVersion[1] && version.patch === currentVersion[2] && version.build > currentVersion[3]))
          {
            return { isNewer: true, version: version };
          }
          return { isNewer: false, version: version };
        }),
        catchError(err => {
          return of({
            isNewer: false,
            version: {
              majorVersion: parseInt(environment.version.split('.')[0], 10),
              minorVersion: parseInt(environment.version.split('.')[0], 10),
              patch: parseInt(environment.version.split('.')[0], 10),
              build: parseInt(environment.version.split('.')[0], 10),
              versionString: environment.version
            } as AppVersion
          });
        })
      );
  }

  compareVersion(current: string, compare: string): string {
    if(!current || !compare){
      return 'newer';
    }
    if(current === compare) {
      return 'same';
    } else {
      const currentVersion = this.convertStringToAppVersion(current);
      const compareVersion = this.convertStringToAppVersion(compare);
      if (compareVersion.majorVersion > currentVersion.majorVersion ||
      (compareVersion.majorVersion === currentVersion.majorVersion && compareVersion.minorVersion > currentVersion.minorVersion) ||
      (compareVersion.majorVersion === currentVersion.majorVersion && compareVersion.minorVersion === currentVersion.minorVersion && compareVersion.patch > currentVersion.patch) ||
      (compareVersion.majorVersion === currentVersion.majorVersion && compareVersion.minorVersion === currentVersion.minorVersion && compareVersion.patch === currentVersion.patch && compareVersion.build > currentVersion.build)) {
        return 'newer'
      }
    }
    return 'older';
  }

  private convertStringToAppVersion(value: string): AppVersion {
    const version = value.split('.');
    if (version.length === 4) {
      const versionInt = version.map(v => parseInt(v, 10));
      return {
        majorVersion: versionInt[0],
        minorVersion: versionInt[1],
        patch: versionInt[2],
        build: versionInt[3],
      }
    }
  }
}
