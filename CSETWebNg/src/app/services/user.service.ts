import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ConfigService } from './config.service';
import { Observable } from 'rxjs';


@Injectable()
export class UserService {

    private apiUrl: string;


    constructor(
        private http: HttpClient,
        private configSvc: ConfigService
    ) {
        this.apiUrl = this.configSvc.apiUrl
    }

    getRole(): Observable<any> {
        return this.http.get(this.apiUrl + 'getRole');
    }
}