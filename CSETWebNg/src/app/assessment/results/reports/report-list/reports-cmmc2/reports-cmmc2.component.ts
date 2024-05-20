import { Component } from '@angular/core';

@Component({
  selector: 'app-reports-cmmc2',
  templateUrl: './reports-cmmc2.component.html'
})
export class ReportsCmmc2Component {

  reportList = [
    {
      linkTitle: "CMMC 2.0 - Executive Summary",
      linkUrl: "executivecmmc2",
      linkDescription: "The report includes graphs to highlight compliance by level, compliance by domain, and the SPRS Scorecard. Additionally, it includes a compilation of all CMMC practices and their responses, along with their corresponding assessment objectives and SPRS value."
    },
    {
      linkTitle: "CMMC 2.0 - Deficiency Report",
      linkUrl: "cmmc2DeficiencyReport",
      linkDescription: "The report contains a list of all CMMC practices that were marked as “No” or unanswered during theassessment process. This report serves to identify potential deficiencies or gaps in the contractor’s cybersecurity practices."
    },
    {
      linkTitle: "CMMC 2.0 - Comments and Marked for Review",
      linkUrl: "cmmc2CommentsMarked",
      linkDescription: "This document consolidates all practices that have received comments and have been flagged for review during the assessment process. It provides an overview of areas where further attention or clarification may be needed."
    }
  ]

}
