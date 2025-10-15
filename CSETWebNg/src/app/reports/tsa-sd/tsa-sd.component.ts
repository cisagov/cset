import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { AssessmentService } from '../../services/assessment.service';
import { MaturityService } from '../../services/maturity.service';
import { AssessmentDetail } from '../../models/assessment-info.model';

@Component({
  selector: 'app-tsa-sd',
  templateUrl: './tsa-sd.component.html',
  styleUrls: ['./tsa-sd.component.scss', '../reports.scss'],
  standalone: false
})
export class TsaSdComponent implements OnInit {

  domains: any[] = [];
  info: AssessmentDetail;

  loading = false;

  responseU: any;
  responseS: any;

  constructor(
    public maturitySvc: MaturityService,
    public assessSvc: AssessmentService,
    public titleService: Title
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.titleService.setTitle("Deficiency Report - Pipeline SD02 Series");
    this.loading = true;

    this.assessSvc.getAssessmentDetail().subscribe((assessmentDetail: any) => {
      this.info = assessmentDetail;
    });

    this.maturitySvc.getMaturityDeficiencySd().subscribe(
      (r: any) => {
        this.loading = false;
        this.responseU = r.unanswered;
        this.responseS = r.no;
      });
  }

}
