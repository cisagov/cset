import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { ConfigService } from './config.service';
import { SetDetail, QuestionSearch, Question, RequirementResult, Requirement } from '../models/set-builder.model';

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

    activeRequirement: Requirement;
    activeQuestion: Question;

    /**
     * Converts linebreak characters to HTML <br> tag.
     */
    formatLinebreaks(text: string) {
        return text.replace(/(?:\r\n|\r|\n)/g, '<br />');
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
        this.router.navigate(['/set-detail', '']);
    }

    /**
     *
     * @param setName
     */
    loadCustomSet(setName: string) {
        sessionStorage.setItem('setName', setName);
        this.router.navigate(['/set-detail', setName]);
    }

    /**
     * Creates a copy of the set and opens the copy
     * @param setName
     */
    cloneCustomSet(setName: string) {
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



    /**********************
     * Navigational services
    ***********************/
    navSetList() {
        this.activeRequirement = null;
        sessionStorage.setItem('setName', null);
        this.router.navigate(['/', 'set-list']);
    }

    navSetDetail() {
        this.activeRequirement = null;
        const setName = sessionStorage.getItem('setName');
        this.router.navigate(['/', 'set-detail', setName]);
    }

    navReqList() {
        this.activeRequirement = null;
        const setName = sessionStorage.getItem('setName');
        this.router.navigate(['/', 'requirement-list', setName]);
    }

    navQuestionList() {
        this.activeQuestion = null;
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

    getCategoriesSubcategoriesGroupHeadings() {
        return this.http.get(this.apiUrl + 'builder/GetCategoriesSubcategoriesGroupHeadings');
    }

    existsQuestionText(questionText: string) {
        return this.http.post(this.apiUrl + 'builder/ExistsQuestionText',
            JSON.stringify(questionText),
            headers);
    }

    addCustomQuestion(customQuestionText: string, category: number, subcategoryText: string, salLevels: string[]) {
        const setName = sessionStorage.getItem('setName');
        const req = {
            SetName: setName,
            CustomQuestionText: customQuestionText,
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
    addExistingQuestion(q: Question) {
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

    /**
     *
     */
    setSalLevel(requirementID: number, questionID: number, level: string, state: boolean) {
        const salParms = {
            RequirementID: requirementID,
            QuestionID: questionID,
            SetName: sessionStorage.getItem('setName'),
            State: state,
            Level: level
        };
        return this.http
            .post(
                this.apiUrl + 'builder/SetSalLevel',
                salParms,
                headers
            );
    }

    /**
     *
     */
    updateQuestionText(q: Question) {
        const parms = {
            QuestionID: q.QuestionID,
            QuestionText: q.QuestionText
        };
        return this.http
            .post(
                this.apiUrl + 'builder/UpdateQuestionText',
                parms,
                headers
            );
    }

    isQuestionInUse(q: Question) {
        return this.http.get(this.apiUrl + 'builder/IsQuestionInUse?questionID=' + q.QuestionID);
    }

    /**
     *
     */
    updateHeadingText(subcat) {
        const parms = {
            PairID: subcat.PairID,
            HeadingText: subcat.SubHeading
        };
        return this.http
            .post(
                this.apiUrl + 'builder/UpdateHeadingText',
                parms,
                headers
            );
    }

    /**
     * Returns the Standard structure.
     */
    getStandard() {
        return this.http.get(this.apiUrl + 'builder/GetStandardStructure?setName=' + sessionStorage.getItem('setName'));
    }

    navRequirementDetail(r: Requirement) {
        this.activeRequirement = r;
        this.router.navigate(['/requirement-detail', r.RequirementID]);
    }

    /**
     * Calls the API with details of a new Requirement to create.
     */
    createRequirement(r: Requirement) {
        r.SetName = sessionStorage.getItem('setName');
        return this.http
            .post(
                this.apiUrl + 'builder/CreateRequirement',
                r,
                headers
            );
    }

    /**
     *
     */
    getRequirement(requirementID: number) {
        return this.http.get(this.apiUrl
            + 'builder/GetRequirement?setName=' + sessionStorage.getItem('setName')
            + '&reqID=' + requirementID);
    }

    /**
     * Sends the Requirement to the API.
     */
    updateRequirement(r: Requirement) {
        r.SetName = sessionStorage.getItem('setName');
        return this.http
            .post(
                this.apiUrl + 'builder/UpdateRequirement',
                r,
                headers
            );
    }
}
