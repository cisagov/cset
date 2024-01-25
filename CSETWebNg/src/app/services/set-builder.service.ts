////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
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
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { ConfigService } from './config.service';
import { SetDetail, QuestionSearch, Question, Requirement, ReferenceDoc } from '../models/set-builder.model';

const headers = {
    headers: new HttpHeaders().set('Content-Type', 'application/json'),
    params: new HttpParams()
};

@Injectable()
export class SetBuilderService {

    public navXml: Document;
    activeRequirement: Requirement;
    activeQuestion: Question;
    navOrigin: string;
    standardDocumentsNavOrigin: string;
    standardDocumentsNavOriginID: string;
    moduleBuilderPaths: string[] = [];

    private apiUrl: string;


    constructor(
        private http: HttpClient,
        private configSvc: ConfigService,
        private router: Router
    ) {
        this.apiUrl = this.configSvc.apiUrl;
        this.readBreadcrumbXml().subscribe((x: any) => {
            const oParser = new DOMParser();
            this.navXml = oParser.parseFromString(x, 'application/xml');
            let htmlElements: HTMLCollection = this.navXml.getElementsByTagName('Page');
            for (let i = 0; i < htmlElements.length; i++) {
                this.moduleBuilderPaths.push(htmlElements[i].attributes.getNamedItem('navpath').value);
            }
        });
    }

    /**
     * Converts linebreak characters to HTML <br> tag.
     */
    formatLinebreaks(text: string) {
        if (!text) {
            return '';
        }
        return text.replace(/(?:\r\n|\r|\n)/g, '<br />');
    }

    /**
     * Returns a collection of custom standards.
     */
    getCustomSetList() {
        return this.http.get(this.apiUrl + 'builder/getCustomSets');
    }


    /**
     * Returns a collection of all standards.
     */
    getAllSetList() {
        return this.http.get(this.apiUrl + 'builder/getAllSets');
    }


    /**
     * Returns a collection of all standards that are currently being used in an assessment.
     */
    getSetsInUseList() {
        return this.http.get(this.apiUrl + 'builder/getSetsInUse');
    }


    /**
     *
     */
    newCustomSet() {
        // navigate to the detail page with an empty key
        localStorage.setItem('setName', '');
        this.router.navigate(['/set-detail', '']);
    }

    /**
     *
     * @param setName
     */
    navSetDetail2(setName: string) {
        localStorage.setItem('setName', setName);
        this.navSetDetail();
    }

    getBaseSetsList(setName) {
        return this.http.get(this.apiUrl + 'builder/GetBaseSets?setName=' + setName);
    }

    saveSets(setName: string, selectedSets: SetDetail[]) {
        let setslist: string[] = [];
        selectedSets.forEach(x => setslist.push(x.setName));
        return this.http.post(this.apiUrl + 'builder/SetBaseSets?setName=' + setName,
            JSON.stringify(setslist),
            headers);
    }

    /**
     * Creates a copy of the set and opens the copy
     * @param setName
     */
    cloneCustomSet(setName: string) {
        return this.http.get(this.apiUrl + 'builder/CloneSet?setName=' + setName);
    }

    getNonCustomSets(setName: string) {
        return this.http.get(this.apiUrl + 'builder/GetNonCustomSets?setName=' + setName);
    }

    CopyBaseToCustom(sourceSetName: string, destinationSetName: string) {
        return this.http.get(this.apiUrl + 'builder/CopyBaseToCustom?SourceSetName=' + sourceSetName + '&DestinationSetName=' + destinationSetName);
    }
    BaseToCustomDelete(destinationSetName: string) {
        return this.http.get(this.apiUrl + 'builder/BaseToCustomDelete?setName=' + destinationSetName);
    }


    /**
     *
     * @param setName
     */
    getSetDetail(setName) {
        return this.http.get(this.apiUrl + 'builder/GetSetDetail?setName=' + localStorage.getItem('setName'));
    }

    /**
     *
     */
    updateSetDetails(set: SetDetail) {
        return this.http
            .post(
                this.apiUrl + 'builder/UpdateSetDetail',
                JSON.stringify(set),
                headers
            );
    }

    /**
     *
     */
    deleteSet(setName: string) {
        return this.http
            .post(
                this.apiUrl + 'builder/DeleteSet',
                JSON.stringify(setName),
                headers
            );
    }

    /**
     * Gets questions with this "original set name".
     */
    getQuestionsOriginatingFromSet(setName: string) {
        return this.http
            .get(
                this.apiUrl + 'builder/GetQuestionsOriginatingFromSet?setName=' + setName,
                headers
            );
    }



    /**********************
     * Navigational services
    ***********************/
    navSetList() {
        this.activeRequirement = null;
        this.activeQuestion = null;
        localStorage.setItem('setName', null);
        this.router.navigate(['/set-list']);
    }

    navSetDetail() {
        this.activeRequirement = null;
        this.activeQuestion = null;
        const setName = localStorage.getItem('setName');
        this.router.navigate(['/set-detail', setName]);
    }

    navReqList() {
        this.activeRequirement = null;
        this.activeQuestion = null;
        const setName = localStorage.getItem('setName');
        this.router.navigate(['/requirement-list', setName]);
    }

    navRequirementDetail(reqID: number) {
        this.getRequirement(reqID).subscribe((r: Requirement) => {
            this.activeRequirement = r;
            this.activeQuestion = null;
            this.router.navigate(['/requirement-detail', r.requirementID]);
        });
    }

    navQuestionList() {
        this.activeQuestion = null;
        const setName = localStorage.getItem('setName');
        this.router.navigate(['/question-list', setName]);
    }

    navAddQuestion() {
        const setName = localStorage.getItem('setName');
        this.router.navigate(['/add-question', setName]);
    }

    navStandardDocuments(origin, id) {
        if (origin !== '') {
            // Remember where we are navigating from (unless 'back'-ing from ref-document)
            this.navOrigin = origin;
            this.standardDocumentsNavOrigin = origin;
            this.standardDocumentsNavOriginID = id;
        }

        const setName = localStorage.getItem('setName');
        this.router.navigate(['/standard-documents', setName]);
    }

    navRefDocDetail(newFileID: number) {
        this.navOrigin = 'standard-documents';
        this.router.navigate(['/ref-document', newFileID]);
    }

    /**
     * The idea behind this is to create a 'smart' navigation method that can
     * deduce the correct navigation path and parameters, based on knowledge of
     * the application.
     */
    navBreadcrumb(navPath: string) {
    }




    getQuestionList() {
        return this.http.get(this.apiUrl + 'builder/GetQuestionsForSet?setName=' + localStorage.getItem('setName'));
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
        const setName = localStorage.getItem('setName');
        const req = {
            setName: setName,
            customQuestionText: customQuestionText,
            questionCategoryID: category,
            QuestionSubcategoryText: subcategoryText,
            salLevels: salLevels,
            requirementID: 0
        };

        if (!!this.activeRequirement) {
            req.requirementID = this.activeRequirement.requirementID;
        }

        return this.http
            .post(
                this.apiUrl + 'builder/AddCustomQuestion',
                JSON.stringify(req),
                headers
            );
    }

    /**
     * Send all selected questions to the API.
     */
    addExistingQuestions(qs: Question[]) {
        const setName = localStorage.getItem('setName');

        const questions = [];
        qs.forEach(element => {
            questions.push(
                {
                    questionID: element.questionID,
                    salLevels: element.salLevels
                }
            );
        });

        const req = {
            setName: setName,
            questionList: questions,
            requirementID: 0
        };

        if (!!this.activeRequirement) {
            req.requirementID = this.activeRequirement.requirementID;
        }

        return this.http
            .post(
                this.apiUrl + 'builder/AddQuestions',
                JSON.stringify(req),
                headers
            );
    }

    /**
     *
     */
    removeQuestion(questionID: number) {
        const setName = localStorage.getItem('setName');
        const req = {
            setName: setName,
            questionID: questionID,
            requirementID: 0
        };

        if (!!this.activeRequirement) {
            req.requirementID = this.activeRequirement.requirementID;
        }

        return this.http
            .post(
                this.apiUrl + 'builder/RemoveQuestion',
                JSON.stringify(req),
                headers
            );
    }

    /**
     *
     */
    searchQuestions(searchTerms: string) {
        const searchParms: QuestionSearch = {
            searchTerms: searchTerms,
            setName: localStorage.getItem('setName'),
            requirementID: 0
        };

        if (!!this.activeRequirement) {
            searchParms.requirementID = this.activeRequirement.requirementID;
        }

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
            SetName: localStorage.getItem('setName'),
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
            QuestionID: q.questionID,
            QuestionText: q.questionText
        };
        return this.http
            .post(
                this.apiUrl + 'builder/UpdateQuestionText',
                parms,
                headers
            );
    }

    isQuestionInUse(q: Question) {
        return this.http.get(this.apiUrl + 'builder/IsQuestionInUse?questionID=' + q.questionID);
    }

    /**
     *
     */
    updateHeadingText(subcat) {
        const parms = {
            pairID: subcat.pairID,
            headingText: subcat.subHeading
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
        return this.http.get(this.apiUrl + 'builder/GetStandardStructure?setName=' + localStorage.getItem('setName'));
    }

    /**
     * Calls the API with details of a new Requirement to create.
     */
    createRequirement(r: Requirement) {
        r.setName = localStorage.getItem('setName');
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
            + 'builder/GetRequirement?setName=' + localStorage.getItem('setName')
            + '&reqID=' + requirementID);
    }

    /**
     * Sends the Requirement to the API.
     */
    updateRequirement(r: Requirement) {
        r.setName = localStorage.getItem('setName');
        return this.http
            .post(
                this.apiUrl + 'builder/UpdateRequirement',
                r,
                headers
            );
    }

    /**
     * Removes the requirement from the set.
     */
    removeRequirement(r: Requirement) {
        r.setName = localStorage.getItem('setName');
        return this.http
            .post(
                this.apiUrl + 'builder/RemoveRequirement',
                r,
                headers
            );
    }

    /**
     * Gets the list of reference documents whose title
     * matches the filter parameters.
     */
    getReferenceDocuments(text: string) {
        return this.http
            .get(this.apiUrl + 'builder/GetReferenceDocs?setName=' + localStorage.getItem('setName') + '&filter=' + text,
                headers);
    }

    /**
     * Sends a list of currently-selected gen file IDs to the API.
     */
    selectDocumentForSet(setName: string, doc: ReferenceDoc) {
        const parms = { setName: setName, doc: doc };
        return this.http
            .post(this.apiUrl + 'builder/SelectSetFile',
                parms,
                headers);
    }

    /**
     * Gets only documents associated with the set
     */
    getReferenceDocumentsForSet() {
        return this.http
            .get(this.apiUrl + 'builder/GetReferenceDocsForSet?setName=' + localStorage.getItem('setName'),
                headers);
    }

    /**
     * Returns detail of the specified GEN_FILE.
     */
    getDocumentDetail(id: number) {
        return this.http
            .get(this.apiUrl + 'builder/GetReferenceDocDetail?id=' + id,
                headers);
    }

    /**
     * Pushes the detail for updating GEN_FILE.
     */
    updateDocumentDetail(doc: ReferenceDoc) {
        return this.http
            .post(this.apiUrl + 'builder/UpdateReferenceDocDetail',
                doc,
                headers);
    }


    /**
     * Adds or deletes a reference document from a requirement.
     */
    addDeleteRefDocToRequirement(reqId: number, docId: number, isSource: boolean, bookmark: string, adddelete: boolean) {
        return this.http
            .get(this.apiUrl + 'builder/AddDeleteRefDocToRequirement?reqId='
                + reqId + '&docId=' + docId + '&isSourceRef=' + isSource + '&bookmark=' + bookmark + '&add=' + adddelete,
                headers);
    }

    /**
     * Returns an Observable that gets the breadcrumbs.xml file in the assets folder.
     */
    readBreadcrumbXml() {
        return this.http.get('assets/breadcrumbs.xml',
            {
                headers: new HttpHeaders().set('Content-Type', 'text/xml'),
                responseType: 'text'
            });
    }
}
