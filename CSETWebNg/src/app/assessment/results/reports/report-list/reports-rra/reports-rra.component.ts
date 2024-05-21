import { Component } from '@angular/core';

@Component({
  selector: 'app-reports-rra',
  templateUrl: './reports-rra.component.html'
})
export class ReportsRraComponent {
  reportList = [
    {
      linkTitle: "RRA Report",
      linkUrl: "rrareport",
      linkDescription: "The report includes a wide array of charts and graphs designed to visually present and summarize the responses gathered throughout the assessment process. Additionally, it includes a compilation of all RRA practices along with their corresponding references. This report provides a comprehensive overview of the assessment outcomes, enabling organizations to analyze and assess their ransomware readiness effectively."
    },
    {
      linkTitle: "RRA Deficiency Report",
      linkUrl: "rraDeficiencyReport",
      linkDescription: "The report contains a list of all RRA practices that were marked as “No” or unanswered during the assessment process. This report serves to identify potential deficiencies or gaps in the organization’s ransomware readiness practices and provides suggested areas for improvement."
    },
    {
      linkTitle: "Comments and Marked for Review",
      linkUrl: "commentsmfr",
      linkDescription: "This document consolidates all practices that have received comments or have been flagged for review during the assessment process. It provides an overview of areas where further attention or clarification may be needed."
    }
  ]
}
