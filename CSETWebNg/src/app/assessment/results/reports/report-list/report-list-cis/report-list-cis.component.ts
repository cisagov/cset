import { Component } from '@angular/core';

@Component({
  selector: 'app-report-list-cis',
  templateUrl: './report-list-cis.component.html'
})
export class ReportListCisComponent {

  reportList = [
    {
      linkTitle: "Survey Report",
      linkUrl: "cisSurveyReport",
      linkDescription: "The report contains a list of all survey questions and their corresponding answers."
    },
    {
      linkTitle: "Section Scoring Report",
      linkUrl: "cisSectionScoringReport",
      linkDescription: "The report compiles all the sub-domain charts, each displaying a score based on how the associated questions were answered. If a baseline survey was selected on the Critical Service Information page, the corresponding baseline score for each sub-domain will also be displayed."
    },
    {
      linkTitle: "Deficiency Report",
      linkUrl: "cisRankedDeficiencyReport",
      linkDescription: "To run the Deficiency Report, a baseline survey must be selected on the Critical Service Information page. The report displays a chart indicating whether the organization’s cybersecurity infrastructure practices have remained unchanged, worsened, or improved compared to the baseline for each sub-domain."
    },
    {
      linkTitle: "Comments and Marked for Review",
      linkUrl: "cisCommentsmarked",
      linkDescription: " This document consolidates all practices that have received comments or have been flagged for review during the survey process. It provides an overview of areas where further attention or clarification may be needed."
    },
  ]

}
