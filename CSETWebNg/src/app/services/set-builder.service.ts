import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { ConfigService } from './config.service';
import { SetDetail } from '../models/set-builder.model';

const headers = {
    headers: new HttpHeaders().set('Content-Type', 'application/json'),
    params: new HttpParams()
};

@Injectable()
export class SetBuilderService {

    private apiUrl: string;

    constructor(
        private http: HttpClient,
        private configSvc: ConfigService,
        private router: Router
    ) {
        this.apiUrl = this.configSvc.apiUrl;
    }


    /**
     * Returns a collection of custom standards.
     */
    getCustomSetList() {
        return this.http.get(this.apiUrl + 'builder/getCustomSets');
    }


    /**
     *
     */
    newCustomSet() {
        // navigate to the detail page with an empty key
        sessionStorage.setItem('setName', '');
        this.router.navigate(['/custom-set', '']);
    }

    /**
     *
     * @param setName
     */
    loadCustomSet(setName: string) {
        sessionStorage.setItem('setName', setName);
        this.router.navigate(['/custom-set', setName]);
    }

    /**
     * Creates a copy of the set and opens the copy
     * @param setName
     */
    cloneCustomSet(setName: string) {
        console.log('service cloneCustomSet');
        return this.http.get(this.apiUrl + 'builder/CloneSet?setName=' + setName);
    }

    /**
     *
     * @param setName
     */
    getSetDetail(setName) {
        return this.http.get(this.apiUrl + 'builder/GetSetDetail?setName=' + sessionStorage.getItem('setName'));
    }


    /**
     *
     * @param set
     */
    updateSetDetails(set: SetDetail) {
        return this.http
            .post(
                this.apiUrl + 'builder/UpdateSetDetail',
                JSON.stringify(set),
                headers
            )
            .subscribe();
    }
}
