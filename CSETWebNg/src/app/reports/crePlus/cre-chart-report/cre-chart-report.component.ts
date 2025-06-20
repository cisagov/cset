import { Component, OnInit } from '@angular/core';
import { AssessmentService } from '../../../services/assessment.service';
import { ReportService } from '../../../services/report.service';
import { QuestionsService } from '../../../services/questions.service';
import { ConfigService } from '../../../services/config.service';
import { Title } from '@angular/platform-browser';


@Component({
  selector: 'app-cre-chart-report',
  standalone: false,
  templateUrl: './cre-chart-report.component.html',
  styleUrls: ['../../reports.scss'],
})
export class CreChartReportComponent implements OnInit {

  title = 'CISA Cyber Resilience Essentials (CRE+) Chart Report';
  assessmentName: string;
  assessmentDate: string;
  assessorName: string;
  facilityName: string;
  selfAssessment: boolean;


  colorScheme = {
    domain: ['#5AA454', '#367190', '#b17300', '#DC3545']
  }

d1 = [
  {
    "name": "Implemented",
    "value": 13
  },
  {
    "name": "In Progress",
    "value": 28
  },
  {
    "name": "Scoped",
    "value": 28
  },
    {
    "name": "Not Implemented",
    "value": 12
  }
];

d2 = [
  {
    "name": "Implemented",
    "value": 13
  },
  {
    "name": "In Progress",
    "value": 28
  },
  {
    "name": "Scoped",
    "value": 28
  },
    {
    "name": "Not Implemented",
    "value": 12
  }
];


multi = [
  {
    "name": "Asset Management",
    "series": [
      {
        "name": "Implemented",
        "value": 1
      },
      {
        "name": "In Progress",
        "value": 4
      },
            {
        "name": "Scoped",
        "value": 5
      },
            {
        "name": "Not Implemented",
        "value": 2
      }
    ]
  },
  {
    "name": "Configuration and Change Management",
    "series": [
      {
        "name": "Implemented",
        "value": 3
      },
      {
        "name": "In Progress",
        "value": 5
      },
            {
        "name": "Scoped",
        "value": 4
      },
            {
        "name": "Not Implemented",
        "value": 3
      }
    ]
  },
  {
    "name": "Controls Managment",
    "series": [
      {
        "name": "Implemented",
        "value": 2
      },
      {
        "name": "In Progress",
        "value": 3
      },
            {
        "name": "Scoped",
        "value": 2
      },
            {
        "name": "Not Implemented",
        "value": 0
      }
    ]
  },
  {
    "name": "Incident Management",
    "series": [
      {
        "name": "Implemented",
        "value": 1
      },
      {
        "name": "In Progress",
        "value": 4
      },
            {
        "name": "Scoped",
        "value": 5
      },
            {
        "name": "Not Implemented",
        "value": 2
      }
    ]
  },
  {
    "name": "Risk Management",
    "series": [
      {
        "name": "Implemented",
        "value": 3
      },
      {
        "name": "In Progress",
        "value": 5
      },
            {
        "name": "Scoped",
        "value": 4
      },
            {
        "name": "Not Implemented",
        "value": 3
      }
    ]
  },
  {
    "name": "Service Continuity",
    "series": [
      {
        "name": "Implemented",
        "value": 2
      },
      {
        "name": "In Progress",
        "value": 3
      },
            {
        "name": "Scoped",
        "value": 2
      },
            {
        "name": "Not Implemented",
        "value": 0
      }
    ]
  },
  {
    "name": "Situational Awareness",
    "series": [
      {
        "name": "Implemented",
        "value": 1
      },
      {
        "name": "In Progress",
        "value": 4
      },
            {
        "name": "Scoped",
        "value": 5
      },
            {
        "name": "Not Implemented",
        "value": 2
      }
    ]
  },
  {
    "name": "Supply Chain Risk",
    "series": [
      {
        "name": "Implemented",
        "value": 3
      },
      {
        "name": "In Progress",
        "value": 5
      },
            {
        "name": "Scoped",
        "value": 4
      },
            {
        "name": "Not Implemented",
        "value": 3
      }
    ]
  },
  {
    "name": "Training and Awareness",
    "series": [
      {
        "name": "Implemented",
        "value": 2
      },
      {
        "name": "In Progress",
        "value": 3
      },
            {
        "name": "Scoped",
        "value": 2
      },
            {
        "name": "Not Implemented",
        "value": 0
      }
    ]
  },
   {
    "name": "Vulnerability Management",
    "series": [
      {
        "name": "Implemented",
        "value": 2
      },
      {
        "name": "In Progress",
        "value": 3
      },
            {
        "name": "Scoped",
        "value": 2
      },
            {
        "name": "Not Implemented",
        "value": 0
      }
    ]
  }
];


  constructor(
    public assessSvc: AssessmentService,
    public reportSvc: ReportService,
    public questionsSvc: QuestionsService,
    public configSvc: ConfigService,
    public titleService: Title
  ) {

  }

  ngOnInit(): void {
    this.titleService.setTitle(this.title);

    this.assessSvc.getAssessmentDetail().subscribe((assessmentDetail: any) => {
      this.assessmentName = assessmentDetail.assessmentName;
      this.assessmentDate = assessmentDetail.assessmentDate;
      this.assessorName = assessmentDetail.facilitatorName;
      this.facilityName = assessmentDetail.facilityName;
      this.selfAssessment = assessmentDetail.selfAssessment;
    });
  }

  formatYAxisTick(label: string): string {
  return label; // Customize as needed
}
}
