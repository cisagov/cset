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
export interface SetDetail {
    setName?: string;
    fullName?: string;
    shortName?: string;
    description?: string;
    setCategory?: number;
    isCustom?: boolean;
    isDisplayed?: boolean;
    categoryList?: Category[];
}

export interface CategoryEntry {
    id?: number;
    text?: string;
}

/**
 * For submitting a question search request.
 * RequirementID is included if the search is for a "related question".
 * SetName is included to avoid returning questions already
 * in the Set.
 */
export interface QuestionSearch {
    searchTerms?: string;
    setName?: string;
    requirementID?: number;
}

/**
 * Used when searching questions to add to a set.
 */
export interface Question {
    questionID?: number;
    questionText?: string;
    selectedForAdd?: boolean;
    categoryId?: number;
    subcategoryId?: number;
    salLevels?: string[];

    // This is just an experiment to bind to Bootstrap checkboxes.  Not working yet.
    sal: { [level: string]: boolean };
}

/**
 *
 */
export interface RequirementResult {
    requirementID?: number;
    requirementTitle: string;
    requirementText?: string;
}


export interface Category {
    id?: number;
    categoryName?: string;
}


export interface Requirement {
    requirementID?: number;
    setName?: string;
    category?: string;
    subcategory?: string;
    questionGroupHeadingID?: number;
    title?: string;
    requirementText?: string;
    salLevels?: string[];
    supplementalInfo?: string;
    sourceDocs?: ReferenceDoc[];
    additionalDocs?: ReferenceDoc[];
    questions?: Question[];
}

export interface RefDocLists {
    sourceDocs: ReferenceDoc[];
    additionalDocs: ReferenceDoc[];
}

export interface ReferenceDoc {
    id: number;
    title?: string;
    fileName?: string;
    name?: string;
    shortName?: string;
    documentNumber?: string;
    publishDate?: Date;
    documentVersion?: string;
    sourceType?: string;
    summary?: string;
    description?: string;
    comments?: string;
    selected?: boolean;
    isCustom?: boolean;
    sectionRef?: string;
}

export interface BasicResponse {
    informationalMessages: string[];
    errorMessages: string[];
}

export class SetGalleryDetails {
    setDetails: string;
    layout: string;
}
