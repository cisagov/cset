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
    DomainName: string;
    DomainId: number;
    Settings: ACETFilterSetting[];
}

export class ACETFilterSetting {
    Level: number;
    Value: boolean;
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
     * Returns the maturity levels applicable to the overall IRP,
     * based on the stairstep graph in the NCUA Guide.
     */
    getStairstepOrig(irp: number): number[] {
        switch (irp) {
            case 0:
                return [];
            case 1:
                return [1, 2]; // ['B', 'E'];
            case 2:
                return [1, 2, 3]; // ['B', 'E', 'Int'];
            case 3:
                return [2, 3, 4]; // ['E', 'Int', 'A'];
            case 4:
                return [3, 4, 5]; // ['Int', 'A', 'Inn'];
            case 5:
                return [4, 5]; // ['A', 'Inn'];
        }
    }

    /**
     * Returns the maturity levels applicable to the overall IRP,
     * based on the proposed 'grounded' stairstep graph.
     */
    getStairstepNew(irp: number): number[] {
        switch (irp) {
            case 0:
                return [];
            case 1:
                return [1]; // ['B'];
            case 2:
                return [1, 2]; // ['B', 'E'];
            case 3:
                return [1, 2, 3]; // ['B', 'E', 'Int'];
            case 4:
                return [1, 2, 3, 4]; // ['B', 'E', 'Int', 'A'];
            case 5:
                return [1, 2, 3, 4, 5]; // ['B', 'E', 'Int', 'A', 'Inn'];
        }
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

                const allSettingsFalse = x.every(f => f.Settings.every(g => g.Value === false));

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
                            DomainName: entry.DomainName,
                            DomainId: entry.DomainId,
                            Settings: entry.Settings
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

        const bands = this.getStairstepNew(irp);
        const dmf = this.domainFilters;

        this.domains.forEach((d: ACETDomain) => {
            const settings: ACETFilterSetting[] = [];
            for (let i = 1; i <= 5; i++) {
                settings.push({
                    Level: i,
                    Value: bands.includes(i)
                });
            }
            dmf.push(
                {
                    DomainName: d.DomainName,
                    DomainId: 0,
                    Settings: settings
                });

            const dFilter = this.domainFilters.find(f => f.DomainName == d.DomainName);

            let ix = 0;
            let belowBand = true;
            while (belowBand && ix < dFilter.Settings.length) {
                if (dFilter.Settings[ix].Value == false) {
                    dFilter.Settings[ix].Value == true;
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
        const targetFilter = this.domainFilters?.find(f => f.DomainName == domainName);

        // If not ACET (no domain name), return false
        if (!domainName
            || domainName.length === 0
            || !this.domainFilters
            || !targetFilter) {
            return false;
        }

        return targetFilter.Settings.every(s => s.Value == false);
    }

    /**
     *
     */
    isDefaultMatLevel(mat: number) {
        const stairstepOrig = this.getStairstepOrig(this.overallIRP);
        if (!!stairstepOrig) {
            return stairstepOrig.includes(mat);
        }
        return false;
    }

    /**
     * 
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
            const filtersForDomain = this.domainFilters.find(f => f.DomainName == currentDomainName).Settings;
            if (filtersForDomain.find(s => s.Level == q.MaturityLevel && s.Value == false)) {
                return;
            } else {
                q.Visible = true;
            }
        } else {
            q.Visible = true;
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
            .find(f => f.DomainName == domainName)
            .Settings.forEach(s => {
                s.Value = s.Level <= f;
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