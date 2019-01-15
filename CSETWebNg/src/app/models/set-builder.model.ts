////////////////////////////////
//
//   Copyright 2018 Battelle Energy Alliance, LLC
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
    SetName?: string;
    FullName?: string;
    ShortName?: string;
    Description?: string;
    SetCategory?: number;
    IsCustom?: boolean;
    IsDisplayed?: boolean;
}

export interface CategoryEntry {
    ID?: number;
    Text?: string;
}

/**
 * For submitting a question search request.
 * SetName is included to avoid returning questions already
 * in the Set.
 */
export interface QuestionSearch {
    SearchTerms?: string;
    SetName?: string;
}

/**
 * Used when searching questions to add to a set.
 */
export interface QuestionResult {
    QuestionID?: number;
    QuestionText?: string;
    SelectedForAdd?: boolean;
    CategoryId?: number;
    SubcategoryId?: number;
    SalLevels?: string[];

    // This is just an experiment to bind to Bootstrap checkboxes.  Not working yet.
    Sal: { [level: string]: boolean };
}

/**
 *
 */
export interface RequirementResult {
    RequirementID?: number;
    RequirementTitle: string;
    RequirementText?: string;
}


export interface Category {
    CategoryName?: string;
}
