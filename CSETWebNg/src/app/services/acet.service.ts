////////////////////////////////
//
//   Copyright 2021 Battelle Energy Alliance, LLC
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
import { ConfigService } from './config.service';
import { AdminSaveData, AttributePair } from '../models/admin-save.model';
import { AcetDashboard } from '../models/acet-dashboard.model';

const headers = {
    headers: new HttpHeaders()
        .set('Content-Type', 'application/json'),
    params: new HttpParams()
};

/**
 * A service that provides everything that ACET needs.
 */
@Injectable()
export class ACETService {


    apiUrl: string;
    constructor(
        private http: HttpClient,
        private configSvc: ConfigService
    ) {
        if (this.configSvc.apiUrl) {
            this.apiUrl = this.configSvc.apiUrl;
        }
        else {
            this.apiUrl = "http://localhost:46000/api/";
        }
    }

    getAdminData() {
        return this.http.get(this.apiUrl + 'admintab/Data');
    }

    saveData(data: AdminSaveData) {
        return this.http.post(this.apiUrl + 'admintab/save', data, headers);
    }

    saveAttribute(data: AttributePair) {
        return this.http.post(this.apiUrl + 'admintab/saveattribute', data, headers);
    }


    ////////////////////  Dashboard functions /////////////////////////////
    getAcetDashboard() {
        return this.http.get(this.apiUrl + 'acetdashboard');
    }

    postSelection(selected: AcetDashboard) {
        return this.http.post(this.apiUrl + 'summary', selected, headers);
    }

    getAnswerCompletionRate() {
        return this.http.get(this.apiUrl + 'MaturityAnswerCompletionRate');
    }

    ////////////////// Maturity Detail functions ///////////////////////////

    /**
    * Returns the maturity details.
    */
    getMatDetailList() {
        return this.http.get(this.apiUrl + 'getMaturityResults');
        // return this.http.get(this.configSvc.apiUrl + 'getMaturityResults/' + this.authSvc.userId());
    }

    /**
    * Returns the maturity EDM Appendix Report details.
    */
    getMatDetailEDMAppendixList() {
        return this.http.get(this.apiUrl + 'getEdmNistCsfResults');
    }

    /*
    * Returns matury range based on current IRP rating
    */
    getMatRange() {
        return this.http.get(this.apiUrl + 'getMaturityRange');
    }

    /*
    * Return the overall IRP score
    */
    getOverallIrp() {
        return this.http.get(this.apiUrl + 'getOverallIrpForMaturity');
    }

    /*
    * Get target band 
    */
    getTargetBand() {
        return this.http.get(this.apiUrl + 'getTargetBand');
    }

    getAssessmentInformation() {
        return this.http.get(this.apiUrl + 'reports/acet/getAssessmentInformation', headers);
    }

    getAnsweredQuestions() {
        return this.http.get(this.apiUrl + 'reports/acet/getAnsweredQuestions', headers);
    }

    /*
    * Save targetBand
    */
    setTargetBand(value: boolean) {
        //adding a comment to force this to push up again
        return this.http.post(this.apiUrl + 'setTargetBand', value, headers);
    }

    /**
    * Returns the color-coded maturity styling for a particular level of maturity.
    *
    * ex:  [ngClass]="maturityClasses(domain.domainMaturity)"
    * @param mat string that is the maturity of the component
    */
    maturityClasses(mat: string) {
        if (mat === "Incomplete") {
            return "alert-incomplete";
        } else if (mat === "Sub-Baseline") {
            return "alert-danger";
        } else if (mat === "Ad-hoc") {
            return "alert-danger";
        } else if (mat === "Baseline") {
            return "alert-baseline";
        } else if (mat === "Evolving") {
            return "alert-evolving";
        } else if (mat === "Intermediate") {
            return "alert-intermediate";
        } else if (mat === "Advanced") {
            return "alert-advanced";
        } else if (mat === "Innovative") {
            return "alert-innovative";
        }
        else {
            return "alert-domain";
        }
    }

    /**
     *
     * @param maturity
     */
    translateMaturity(maturity: string) {
        if (maturity === "Sub-Baseline") {
            return "Incomplete";
        }
        else if (maturity === "Ad-hoc") {
            return "Ad Hoc";
        }
        return maturity;
    }

    /**
     *
     * @param mat
     */
    levelClasses(mat: number) {
        if (mat === 0) {
            return "alert-danger";
        } else if (mat > 0 && mat < 100) {
            return "alert-warning";
        } else {
            return "alert-success";
        }
    }

    /**
     *
     * @param riskLevel
     */
    interpretRiskLevel(riskLevel: number) {
        switch (riskLevel) {
            case 1:
                return "1 - Least";
                break;
            case 2:
                return "2 - Minimal";
                break;
            case 3:
                return "3 - Moderate";
                break;
            case 4:
                return "4 - Significant";
                break;
            case 5:
                return "5 - Most";
                break;
            default:
                return "0 - Incomplete";
                break;
        }
    }
}

