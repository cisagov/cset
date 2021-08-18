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
import { Question } from "../../../models/questions.model";
import { ConfigService } from "../../config.service";
import { HttpHeaders, HttpParams, HttpClient } from '@angular/common/http';
import { ACETDomain, Domain, QuestionGrouping } from '../../../models/questions.model';
import { Injectable, Output, EventEmitter } from "@angular/core";
import { QuestionFilterService } from "../question-filter.service";
import { AssessmentService } from "../../assessment.service";




export class ACETFilter {
    domainName: string;
    domainId: number;
    settings: ACETFilterSetting[];
}

export class ACETFilterSetting {
    level: number;
    value: boolean;
}

const headers = {
    headers: new HttpHeaders()
        .set('Content-Type', 'application/json'),
    params: new HttpParams()
};


@Injectable()
export class AcetFilteringService {

    @Output() filterAcet: EventEmitter<any> = new EventEmitter();
    domains: ACETDomain[];

    public overallIRP: number;

    /**
     * Trying a new way to manage these things.  This is now the master filter object.
     * These are currently used exclusively for ACET.
     */
    public domainFilters: ACETFilter[];


    constructor(
        public http: HttpClient,
        public configSvc: ConfigService,
        public assessmentSvc: AssessmentService
    ) {
        this.getACETDomains().subscribe((domains: ACETDomain[]) => {
            this.domains = domains;
        });
    }

    /**
     * Returns any levels that are REQUIRED to be answered
     * for the specified IRP.
     */
    getStairstepRequired(irp: number): number[] {
        switch (irp) {
            case 0:
                return [];
            case 1:
                return [1]; // Baseline
            case 2:
                return [1]; // Baseline
            case 3:
                return [1, 2]; // Baseline, Evolving
            case 4:
                return [1, 2, 3]; // Baseline, Evolving, Intermediate
            case 5:
                return [1, 2, 3, 4]; // Baseline, Evolving, Intermediate, Advanced
        }
    }

    /**
     * Returns any levels that are not required but are 
     * RECOMMENDED for the specified IRP.
     */
    getStairstepRecommended(irp: number): number[] {
        switch (irp) {
            case 0:
                return [];
            case 1:
                return [2]; // Evolving
            case 2:
                return [2, 3]; // Evolving, Intermediate
            case 3:
                return [3, 4]; // Intermediate, Advanced
            case 4:
                return [4, 5]; // Advanced, Innovative
            case 5:
                return [5]; // Innovative
        }
    }

    /**
    * Indicates if the specified level falls within the 
    * risk levels for the IRP of the assessment.
    */
    isRequiredLevel(level: number) {
        const stairstep = this.getStairstepRequired(this.overallIRP);
        return stairstep.includes(level);
    }

    /**
     * Indicates if the specified level is not required
     * for the current IRP but are 'recommended'.
     */
    isRecommendedLevel(level: number) {
        const stairstep = this.getStairstepRecommended(this.overallIRP);
        return stairstep.includes(level);
    }

    /**
    * Sets the starting value of the maturity filters, based on the 'stairstep.'
    * Any 'empty' values below the bottom of the band are set as well.
    */
    initializeMatFilters(targetLevel: number): Promise<any> {
        return new Promise((resolve) => {
            this.overallIRP = targetLevel;

            // if we have an IRP, default the maturity filters based on the stairstep.
            this.domainFilters = [];

            this.getFilters().subscribe((x: ACETFilter[]) => {

                const allSettingsFalse = x.every(f => f.settings.every(g => g.value === false));

                if (!x || x.length === 0 || allSettingsFalse) {
                    // the server has not filter pref set or they have all been set to false
                    // -- set default filters based on the bands
                    this.setDmfFromDefaultBand(targetLevel);
                    this.saveFilters(this.domainFilters).subscribe();
                } else {
                    // rebuild domainFilters from what the API gave us
                    this.domainFilters = [];
                    for (const entry of x) {
                        this.domainFilters.push({
                            domainName: entry.domainName,
                            domainId: entry.domainId,
                            settings: entry.settings
                        });
                    }
                }

                // resolve this promise
                resolve(this.domainFilters);
            });
        });
    }


    /**
     * Gets the default stairstep and creates a filter profile
     * for all Domains from that stairstep.
     */
    setDmfFromDefaultBand(irp: number) {
        if (!this.domains) {
            return;
        }

        const bands = this.getStairstepRequired(irp);
        const dmf = this.domainFilters;

        this.domains.forEach((d: ACETDomain) => {
            const settings: ACETFilterSetting[] = [];
            for (let i = 1; i <= 5; i++) {
                settings.push({
                    level: i,
                    value: bands.includes(i)
                });
            }
            dmf.push(
                {
                    domainName: d.domainName,
                    domainId: 0,
                    settings: settings
                });

            const dFilter = this.domainFilters.find(f => f.domainName == d.domainName);

            let ix = 0;
            let belowBand = true;
            while (belowBand && ix < dFilter.settings.length) {
                if (dFilter.settings[ix].value == false) {
                    dFilter.settings[ix].value == true;
                } else {
                    belowBand = false;
                }
                ix++;
            }
        });
    }

    /**
     * Returns true if no maturity filters are enabled.
     * This is used primarily to ngif the 'all filters are off' message.
     */
    allDomainMaturityLevelsHidden(domainName: string) {
        const targetFilter = this.domainFilters?.find(f => f.domainName == domainName);

        // If not ACET (no domain name), return false
        if (!domainName
            || domainName.length === 0
            || !this.domainFilters
            || !targetFilter) {
            return false;
        }

        return targetFilter.settings.every(s => s.value == false);
    }

    /**
     * Sets the domain filters based on the specified IRP value.
     */
    resetDomainFilters(irp: number) {
        this.getACETDomains().subscribe((domains: ACETDomain[]) => {
            this.domains = domains;
            this.domainFilters = [];
            this.setDmfFromDefaultBand(irp);
            this.saveFilters(this.domainFilters).subscribe();
        });
    }

    /**
     * Indicates if the ACET question should be visible based on current
     * filtering.
     */
    public setQuestionVisibility(q: Question, currentDomainName: string): boolean {
        if (!!this.domainFilters) {
            const filtersForDomain = this.domainFilters.find(f => f.domainName == currentDomainName).settings;
            if (filtersForDomain.find(s => s.level == q.maturityLevel && s.value == false)) {
                return;
            } else {
                q.visible = true;
            }
        } else {
            q.visible = true;
        }
    }


    /**
     * Sets the new value in the service's filter map and tells the host page
     * to refresh the question list.
     * @param f
     * @param e
     */
    filterChanged(domainName: string, f: number, e: boolean) {
        // set all true up to the level they hit, then all false above that
        this.domainFilters
            .find(f => f.domainName == domainName)
            .settings.forEach(s => {
                s.value = s.level <= f;
            });
        this.saveFilters(this.domainFilters).subscribe(() => {
            this.filterAcet.emit(true);
        });
    }

    //------------------ API requests ------------------



    /**
     * 
     */
    getACETDomains() {
        return this.http.get(this.configSvc.apiUrl + 'ACETDomains');
    }

    /**
     * 
     */
    getFilters() {
        return this.http.get(this.configSvc.apiUrl + 'GetAcetFilters');
    }




    /**
     * Sets a bit ('val') for the domain and level.  The bit indicates if the fiter is
     * on or of.
     */
    saveFilter(domainName: string, level: number, val: any) {
        const setting = { DomainName: domainName, Level: level, Value: val };
        return this.http.post(this.configSvc.apiUrl + 'SaveAcetFilter', setting, headers);
    }

    /**
     * Sets the state of a group of filters.  
     */
    saveFilters(filters: ACETFilter[]) {
        return this.http.post(this.configSvc.apiUrl + 'SaveAcetFilters', filters, headers);
    }
}