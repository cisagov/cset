import { Component } from '@angular/core';

@Component({
  selector: 'app-reports-edm',
  templateUrl: './reports-edm.component.html'
})
export class ReportsEdmComponent {

  reportList = [
    {
      linkTitle: "EDM Report",
      linkUrl: "edm",
      linkDescription: "The report includes a wide array of charts and graphs designed to visually present and summarize the responses gathered throughout the assessment process, enabling organizations to analyze and assess their incident management capabilities effectively. Organizations can gauge if their incident management functions align with the National Institute of Standards and Technology (NIST) Cybersecurity Framework (CSF), as assessment results are depicted in terms relative to the NIST CSF. Additionally, the report includes a compilation of all CRR practices along with their corresponding references.",
      securityPicker: true
    },
    {
      linkTitle: "Print EDM Report",
      linkUrl: "edm",
      linkDescription: "Opens the report and initiates the print process.  To save as a PDF, select 'Print to PDF.'",
      print: true
    },
    {
      linkTitle: "EDM Deficiency Report",
      linkUrl: "edmDeficiencyReport",
      linkDescription: ""
    },
    {
      linkTitle: "EDM Comments and Marked for Review",
      linkUrl: "edmCommentsmarked",
      linkDescription: ""
    }
  ];

}
