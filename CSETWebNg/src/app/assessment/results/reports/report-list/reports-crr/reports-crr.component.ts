import { Component } from '@angular/core';

@Component({
  selector: 'app-reports-crr',
  templateUrl: './reports-crr.component.html'
})
export class ReportsCrrComponent {

  reportList = [
    {
      linkTitle: "CRR Report",
      linkUrl: "crrreport",
      linkDescription: "The report includes a wide array of charts and graphs designed to visually present and summarize the responses gathered throughout the assessment process, enabling organizations to analyze and assess their incident management capabilities effectively. Organizations can gauge if their incident management functions align with the National Institute of Standards and Technology (NIST) Cybersecurity Framework (CSF), as assessment results are depicted in terms relative to the NIST CSF. Additionally, the report includes a compilation of all CRR practices along with their corresponding references.",
      securityPicker: true
    },
    {
      linkTitle: "CRR Deficiency Report",
      linkUrl: "crrDeficiencyReport",
      linkDescription: ""
    },
    {
      linkTitle: "CRR Comments and Marked for Review",
      linkUrl: "crrCommentsMarked",
      linkDescription: ""
    }
  ];

}
