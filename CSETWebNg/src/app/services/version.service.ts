import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { BehaviorSubject, Observable, Subject, of } from 'rxjs';
import { ConfigService } from './config.service';


const headers = {
  headers: new HttpHeaders().set("Content-Type", "application/json"),
  params: new HttpParams()
};
@Injectable({
  providedIn: 'root'
})

export class VersionService {
  private localVersionSubject: BehaviorSubject<string> = new BehaviorSubject<string>(null);
  public localVersionObservable$: Observable<string> = this.localVersionSubject.asObservable();

  actualVersion: string = '';
  githubVersion = []
  public localVersion: string;
  showVersionNotification = false;
  private apiURLCset = this.configSvc.apiUrl;
  installedVersion: any;

  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,

  ) {
    this.getLatestVersion();
  }

  getLatestVersion() {
    this.getGithubLatestRelease().subscribe(data => {
      this.actualVersion = data.tag_name.substring(1)
      this.githubVersion = data.tag_name.substring(1).split('.').map(x => parseInt(x, 10))
      if (data) {
        this.getInstalledVersion().subscribe(version => {
          this.localVersion = version.majorVersion.toString() + '.' + version.minorVersion.toString() + '.' + version.patch.toString() + '.' + version.build.toString();
          this.localVersionSubject.next(this.localVersion);
          if (version.majorVersion < this.githubVersion[0] ||
            (version.majorVersion === this.githubVersion[0] && version.minorVersion < this.githubVersion[1]) ||
            (version.majorVersion === this.githubVersion[0] && version.minorVersion === this.githubVersion[1] && version.patch < this.githubVersion[2]) ||
            (version.majorVersion === this.githubVersion[0] && version.minorVersion === this.githubVersion[1] && version.patch === this.githubVersion[2] && version.build < this.githubVersion[3])) {
            this.showVersionNotification = true;
          }
          else {
            this.showVersionNotification = false;
          }
        })
      }
    })
    error => {
      console.log(error)
    }
  }

  getGithubLatestRelease(): Observable<any> {
    return this.http.get<any>(this.configSvc.csetGithubApiUrl)
  }
  getInstalledVersion(): Observable<any> {
    return this.http.get<any>(this.apiURLCset + 'version/getVersionNumber')
  }
}
