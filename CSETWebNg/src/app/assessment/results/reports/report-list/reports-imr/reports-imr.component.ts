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
import { Component } from '@angular/core';

@Component({
  selector: 'app-reports-imr',
  templateUrl: './reports-imr.component.html'
})
export class ReportsImrComponent {

  reportList = [
    {
      linkTitle: "IMR Report",
      linkUrl: "imrreport",
      linkDescription: "The report includes a wide array of charts and graphs designed to visually present and summarize the responses gathered throughout the assessment process, enabling organizations to analyze and assess their incident management capabilities effectively. Organizations can gauge if their incident management functions align with the National Institute of Standards and Technology (NIST) Cybersecurity Framework (CSF), as assessment results are depicted in terms relative to the NIST CSF. Additionally, the report includes a compilation of all IMR practices along with their corresponding references.",
      securityPicker: true
    },
    {
      linkTitle: "IMR Deficiency Report",
      linkUrl: "genDeficiencyReport?m=IMR",
      linkDescription: "The report contains a list of all IMR practices that were marked as “No” or unanswered during the assessment process. This report serves to identify potential deficiencies or gaps in the organization's incident management practices and provides suggested areas for improvement."
    },
    {
      linkTitle: "Comments and Marked for Review",
      linkUrl: "commentsmfr",
      linkDescription: "This document consolidates all practices that have received comments and have been flagged for review during the assessment process as well as other remarks. It provides an overview of areas where further attention or clarification may be needed."
    }];


}
