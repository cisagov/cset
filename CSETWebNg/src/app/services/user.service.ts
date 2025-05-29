import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ConfigService } from './config.service';
import { Observable } from 'rxjs';
import { UserRole, Roles } from '../models/user.model';

const headers = {
    headers: new HttpHeaders().set('Content-Type', 'application/json'),
    params: new HttpParams()
};
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

    getAvailableRoles(): Observable<Roles[]> {
        return this.http.get<Roles[]>(this.apiUrl + 'getAvailableRoles');
    }

    getUsers(): Observable<UserRole[]> {
        return this.http.get<UserRole[]>(this.apiUrl + 'getusers');
    }

    updateUserRole(user: UserRole) {
        return this.http.post(this.apiUrl + 'updateuser', user, headers);
    }
}