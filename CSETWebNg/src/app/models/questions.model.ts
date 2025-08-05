////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
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


/**
 * The response returned from the API 'questionlist' request.
 */
export interface QuestionResponse {
    categories: Category[];
    maturityTargetLevel: number;
    applicationMode: string;
    onlyMode: boolean;
    questionCount: number;
    requirementCount: number;
    overallIRP: number;
    modelId: number;
    modelName: string;

    // the answer options to be displayed
    answerOptions: string[];
}

export interface MaturityQuestionResponse {
    modelId: number;
    modelName: string;
    questionsAlias: string;
    groupingId: number;
    title: string;
    levels: [];
    maturityTargetLevel: number;
    glossary: GlossaryEntry[];
    groupings: QuestionGrouping[];

    // the answer options to be displayed
    answerOptions: string[];
}

export interface MaturityDomainRemarks {
    group_Id: number;
    domainRemark: string;
}

export interface QuestionGrouping {
    abbreviation: string;
    domainRemark: string;
    prefix: string;
    title: string;
    description: string;
    description_Extended: string;
    groupingId: number;
    groupingLevel: number;
    groupingType: string;
    questions: Question[];
    subGroupings: QuestionGrouping[];

    // these properties are used for collapsing the lowest group
    hasReviewItems: boolean;

    // controls the expansion of question blocks
    expanded: boolean;

    // indicates if filtering has hidden the grouping
    visible: boolean;

    // in CRE+, groups can be 'selected' in order to be displayed in list
    selected: boolean;
}

export interface ACETDomain {
    domainName: string;
    domainId: number;
    acronym: string;
}

export interface GlossaryEntry {
    term: string;
    definition: string;
}



/**
 * Multi-purpose container for domain, standard (requirements mode),
 * Standard Questions, Component Defaults or Component Overrides.
 */
export interface Domain {
    setName: string;   // TODO:  delete when possible
    setShortName: string; // TODO:  delete when possible
    domainName: string;
    displayText: string;
    isDomain: boolean;
    domainText: string;
    categories: Category[];
    visible: boolean;
}

export interface Category {
    showOverrideHeader: boolean;
    isOverride: boolean;
    groupHeadingId: number;
    groupHeadingText: string;
    standardShortName: string;
    subCategories: SubCategory[];
    visible: boolean;
    domainName: string;
    symbol_Name: string;
    componentName: string;
    navigationGUID: string;
}

export interface SubCategory {
    groupHeadingId: number;
    subCategoryId: number;
    subCategoryHeadingText: string;
    headerQuestionText: string;
    subCategoryAnswer: string;
    questions: Question[];
    expanded: boolean;
    hasReviewItems: boolean;
    visible: boolean;
    navigationGUID: string;
}

export interface Question {
    displayNumber: string;
    questionId: number;
    questionType: string;
    questionText: string;
    parmSubs: SubToken[];
    supplementalInfo: string;
    stdRefId: string;
    answerOptions: string[];
    answer_Id: number;
    answer: string;

    /**
     * Stores a justification for the answer choice.
     * In Standards, it is asked for Alt answer choices.
     * In maturity models it may vary.
    */
    altAnswerText: string;

    /**
     * Used to control the ngIf of the justification field (altAmswerText)
     */
    showJustificationField: boolean;

    freeResponseAnswer?: string;
    answerMemo?: string;
    comment: string;
    feedback: string;
    hasObservation: boolean;
    hasDocument: boolean;
    documentIds: number[];
    markForReview: boolean;
    reviewed: boolean;
    maturityLevel: number;
    maturityLevelName: string;
    is_Component: boolean;
    componentGuid: string;
    is_Requirement: boolean;
    is_Maturity: boolean;
    extrasExpanded: boolean;



    // CPG fields
    securityPractice: string;
    scope: string;
    recommendedAction: string;
    services: string;
    implementationGuides: string;
    outcome?:string;

    // parent questions aren't answered directly and have subparts that are answered.
    isParentQuestion: boolean;
    parentQuestionId: number;
    isAnswerable: boolean;

    followups: [];

    visible: boolean;
    options: any[];
    failedIntegrityCheckOptions: IntegrityCheckOption[];
}

export class Answer {
    answerId: number;
    questionId: number;
    questionType: string;
    questionNumber: string;
    answerText: string;
    altAnswerText: string;
    freeResponseAnswer?: string;
    comment: string;
    feedback: string;
    markForReview: boolean;
    reviewed: boolean;
    is_Component: boolean;
    is_Requirement: boolean;
    is_Maturity: boolean;
    componentGuid: string;
    optionId?: number;
    optionType?: string;
}

export interface Option {
    optionId: number;
    optionType: string;
    optionText: string;
    sequence: number;
    weight: number;
    isNone: boolean;
    selected: boolean;
    answerId?: number;
    hasAnswerText: boolean;
    answerText: string;
    baselineSelected: boolean;
    baselineAnswerText: string;
    questionId?: number;
    freeResponseAnswer?: string;
    followups: Question[];
}

export interface IntegrityCheckOption {
    optionId: number;
    selected: boolean;
    parentQuestionText: string;
    inconsistentOptions: InconsistentOption[];
}

export interface InconsistentOption {
    optionId: number;
    parentQuestionText: string;
}

export class SubToken {
    id: number;
    token: string;
    substitution: string;
}

export class DefaultParameters {
    defaultParameter: string[];
}

/**
 * All default parameters for an assessment
 */
export class DefaultParameter {
    parameterName: string;
    parameterValue: string;
    parameterOrigValue: string;
    parameterId: number;
    editMode: boolean;
}

/**
 * Encapsulates an in-line Parameter when changing the value
 * and persisting back to the API.
 */
export class ParameterForAnswer {
    parameterId: number;
    requirementId: number;
    answerId: number;

    /**
     * The new value.
     */
    parameterValue: string;
}


/**
 * Encapsulates an answer for a subcategory plus
 * the defaulted answers for all of its member questions.
 * This is used for sending a mass update to the API.
 */
export interface SubCategoryAnswers {
    groupHeadingId: number;
    subCategoryId: number;
    subCategoryAnswer: string;
    answers: Answer[];
}

/**
 * Represents
 */
export interface MaturityFilter {
    label: string;
    isSet: boolean;
}

export interface AnswerQuestionResponse {
    answerId: number;
    detailsChanged: boolean;
}
