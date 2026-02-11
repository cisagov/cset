////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
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
  installedVersion: any;

  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,

  ) {
    this.getLatestVersion();
  }

  /**
   * Compares the latest GitHub version with the CSET version being run to see if
   * we are running the latest.
   */
  getLatestVersion() {
    this.getGithubLatestRelease().subscribe(data => {
      this.actualVersion = data.tag_name.substring(1);
      this.githubVersion = data.tag_name.substring(1).split('.').map(x => parseInt(x, 10));
      if (data) {
        this.getInstalledVersion().subscribe(v => {
          const version = v.codebaseVersion;
          
          this.localVersion = version.majorVersion.toString() + '.' + version.minorVersion.toString() + '.' + version.build.toString() + '.' + version.revision.toString();
          this.localVersionSubject.next(this.localVersion);

          if (version.majorVersion < this.githubVersion[0] ||
            (version.majorVersion === this.githubVersion[0] && version.minorVersion < this.githubVersion[1]) ||
            (version.majorVersion === this.githubVersion[0] && version.minorVersion === this.githubVersion[1] && version.build < this.githubVersion[2]) ||
            (version.majorVersion === this.githubVersion[0] && version.minorVersion === this.githubVersion[1] && version.build === this.githubVersion[2] && version.revision < this.githubVersion[3])) {
            this.showVersionNotification = true;
          }
          else {
            this.showVersionNotification = false;
          }
        });
      }
    })
    error => {
      console.error(error)
    }
  }

  getGithubLatestRelease(): Observable<any> {
    return this.http.get<any>(this.configSvc.csetGithubApiUrl)
  }

  getInstalledVersion(): Observable<any> {
    return this.http.get<any>(this.configSvc.apiUrl + 'version')
  }
}
