import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { ConfigService } from './config.service';
import { SetDetail, QuestionSearch, QuestionResult } from '../models/set-builder.model';

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

    navReqList() {
        const setName = sessionStorage.getItem('setName');
        this.router.navigate(['/', 'requirement-list', setName]);
    }

    navQuestionList() {
        const setName = sessionStorage.getItem('setName');
        this.router.navigate(['/', 'question-list', setName]);
    }

    navAddQuestion() {
        const setName = sessionStorage.getItem('setName');
        this.router.navigate(['/', 'add-question', setName]);
    }

    getQuestionList() {
        return this.http.get(this.apiUrl + 'builder/GetQuestionsForSet?setName=' + sessionStorage.getItem('setName'));
    }

    getCategoriesAndSubcategories() {
        return this.http.get(this.apiUrl + 'builder/GetCategoriesAndSubcategories');
    }

    existsQuestionText(questionText: string) {
        return this.http.post(this.apiUrl + 'builder/ExistsQuestionText',
            JSON.stringify(questionText),
            headers);
    }

    addQuestion(newQuestionText: string, category: number, subcategoryText: string, salLevels: string[]) {
        const setName = sessionStorage.getItem('setName');
        const req = {
            SetName: setName,
            NewQuestionText: newQuestionText,
            QuestionCategoryID: category,
            QuestionSubcategoryText: subcategoryText,
            SalLevels: salLevels
        };
        return this.http
            .post(
                this.apiUrl + 'builder/AddCustomQuestionToSet',
                JSON.stringify(req),
                headers
            );
    }

    /**
     *
     */
    addExistingQuestion(q: QuestionResult) {
        const setName = sessionStorage.getItem('setName');
        const req = {
            SetName: setName,
            QuestionID: q.QuestionID,
            SalLevels: q.SalLevels
        };

        return this.http
            .post(
                this.apiUrl + 'builder/AddQuestionToSet',
                JSON.stringify(req),
                headers
            );
    }

    /**
     *
     */
    removeQuestion(questionID: number) {
        const setName = sessionStorage.getItem('setName');
        const req = {
            SetName: setName,
            QuestionID: questionID
        };
        return this.http
            .post(
                this.apiUrl + 'builder/RemoveQuestionFromSet',
                JSON.stringify(req),
                headers
            );
    }

    /**
     *
     */
    searchQuestions(searchTerms: string) {
        const searchParms: QuestionSearch = {
            SearchTerms: searchTerms,
            SetName: sessionStorage.getItem('setName')
        };

        return this.http
            .post(
                this.apiUrl + 'builder/SearchQuestions',
                searchParms,
                headers
            );
    }

    setQuestionSalLevel(questionID: number, level: string, state: boolean) {
        const salParms = {
            QuestionID: questionID,
            SetName: sessionStorage.getItem('setName'),
            State: state,
            Level: level
        };
        return this.http
            .post(
                this.apiUrl + 'builder/SetQuestionSalLevel',
                salParms,
                headers
            );
    }
}
