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


/**
 * The response returned from the API 'questionlist' request.
 */
export interface QuestionResponse {
    Domains: Domain[];
    MaturityTargetLevel: number;
    ApplicationMode: string;
    QuestionCount: number;
    RequirementCount: number;
    OverallIRP: number;
    ModelName: string;

    // the answer options to be displayed
    AnswerOptions: string[];
}

export interface MaturityQuestionResponse {
    ModelName: string;
    QuestionsAlias: string;
    Levels: [];
    MaturityTargetLevel: number;
    Glossary: GlossaryEntry[];
    Groupings: QuestionGrouping[];
   
    // the answer options to be displayed
    AnswerOptions: string[];
}

export interface MaturityDomainRemarks
{
    Group_Id: number;
    DomainRemark: string;
}

export interface QuestionGrouping {
    DomainRemark: string;
    Title: string;
    Description: string;
    GroupingID: number;
    GroupingType: string;
    Questions: Question[];
    SubGroupings: QuestionGrouping[];

    // these properties are used for collapsing the lowest group
    HasReviewItems: boolean;

    // controls the expansion of question blocks
    Expanded: boolean;

    // indicates if filtering has hidden the grouping
    Visible: boolean;
}

export interface ACETDomain {
    DomainName: string;
    DomainId: number;
    Acronym: string;
}

export interface GlossaryEntry {
    Term: string;
    Definition: string;
}



/**
 * Multi-purpose container for domain, standard (requirements mode),  
 * Standard Questions, Component Defaults or Component Overrides.
 */
export interface Domain {
    SetName: string;   // TODO:  delete when possible
    SetShortName: string; // TODO:  delete when possible
    DomainName: string;
    DisplayText: string;
    IsDomain: boolean;
    DomainText: string;
    Categories: Category[];
    Visible: boolean;
}

export interface Category {
    ShowOverrideHeader: boolean;
    IsOverride: boolean;
    GroupHeadingId: number;
    GroupHeadingText: string;
    StandardShortName: string;
    SubCategories: SubCategory[];
    Visible: boolean;
    DomainName: string;
    Symbol_Name: string;
    ComponentName: string;
    NavigationGUID: string;
}

export interface SubCategory {
    GroupHeadingId: number;
    SubCategoryId: number;
    SubCategoryHeadingText: string;
    HeaderQuestionText: string;
    SubCategoryAnswer: string;
    Questions: Question[];
    Expanded: boolean;
    HasReviewItems: boolean;
    Visible: boolean;
    NavigationGUID: string;
}

export interface Question {
    DisplayNumber: string;
    QuestionId: number;
    QuestionType: string;
    QuestionText: string;
    ParmSubs: SubToken[];
    StdRefId: string;
    Answer_Id: number;
    Answer: string;
    AltAnswerText: string;
    Comment: string;
    Feedback: string;
    HasDiscovery: boolean;
    HasDocument: boolean;
    MarkForReview: boolean;
    Reviewed: boolean;
    MaturityLevel: number;
    Is_Component: boolean;
    ComponentGuid: string;
    Is_Requirement: boolean;
    Is_Maturity: boolean;
    ExtrasExpanded: boolean;

    // parent questions aren't answered directly and have subparts that are answered.
    IsParentQuestion: boolean;
    ParentQuestionId: number;

    Visible: boolean;
}

export class Answer {
    AnswerId: number;
    QuestionId: number;
    QuestionType: string;
    QuestionNumber: string;
    AnswerText: string;
    AltAnswerText: string;
    Comment: string;
    Feedback: string;
    MarkForReview: boolean;
    Reviewed: boolean;
    Is_Component: boolean;
    Is_Requirement: boolean;
    Is_Maturity: boolean;
    ComponentGuid: string;
}

export class SubToken {
    Id: number;
    Token: string;
    Substitution: string;
}


export class DefaultParameters {
    DefaultParameter: string[];
}

/**
 * All default parameters for an assessment
 */
export class DefaultParameter {
    ParameterName: string;
    ParameterValue: string;
    ParameterOrigValue: string;
    ParameterId: number;
    EditMode: boolean;
}

/**
 * Encapsulates an in-line Parameter when changing the value
 * and persisting back to the API.
 */
export class ParameterForAnswer {
    ParameterId: number;
    RequirementId: number;
    AnswerId: number;

    /**
     * The new value.
     */
    ParameterValue: string;
}


/**
 * Encapsulates an answer for a subcategory plus
 * the defaulted answers for all of its member questions.
 * This is used for sending a mass update to the API.
 */
export interface SubCategoryAnswers {
    GroupHeadingId: number;
    SubCategoryId: number;
    SubCategoryAnswer: string;
    Answers: Answer[];
}

/**
 * Represents
 */
export interface MaturityFilter {
    label: string;
    isSet: boolean;
}

/**
 *
 */
export class DomainMaturityFilterSet {

}
