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
import { Injectable } from "@angular/core";
import { Question } from "../../../models/questions.model";
import { AssessmentService } from "../../assessment.service";
import { QuestionFilterService } from "../question-filter.service";

/**
 * Maturity filtering for CMMC is basically whether to include questions
 * above the target level or not.  
 */
@Injectable()
export class CmmcFilteringService {

    constructor(
        public assessmentSvc: AssessmentService,
        public questionFilterSvc: QuestionFilterService
    ) { }

    /**
     * Indicates if the CMMC question should be visible based on current
     * filtering.  CMMC filtering is based on target level.  
     * Should we show questions above target level?
     */
    public setQuestionVisibility(q: Question) {
        const targetLevel = this.assessmentSvc.assessment ?
            this.assessmentSvc.assessment.maturityModel?.maturityTargetLevel :
            10;

        // if the question's maturity level is at or below the target level, show it
        if (q.maturityLevel <= targetLevel) {
            q.visible = true;
        }

        // if the 'show above target' filter is turned on, show it, regardless of the question's level
        if (this.questionFilterSvc.showFilters.includes('MT+')) {
            q.visible = true;
        }
    }
}