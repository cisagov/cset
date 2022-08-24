import { CrrReportModel } from './../../../models/reports.model';
import { CrrService } from './../../../services/crr.service';
import { Component, OnInit } from '@angular/core';
import { DomSanitizer, Title } from '@angular/platform-browser';
import { ConfigService } from '../../../services/config.service';
import { MaturityService } from '../../../services/maturity.service';
import { ReportAnalysisService } from '../../../services/report-analysis.service';
import { ReportService } from '../../../services/report.service';

@Component({
  selector: 'app-crr-comments-marked',
  templateUrl: './crr-comments-marked.component.html',
  styleUrls: ['./../crr-report/crr-report.component.scss']
})
export class CrrCommentsMarkedComponent implements OnInit {

  crrModel: CrrReportModel;
  loading: boolean = false;
  logoPath: string = '';

  keyToCategory = {
    AM: 'Asset Management',
    CM: 'Controls Management',
    CCM: 'Configuration and Change Management',
    VM: 'Vulnerability Management',
    IM: 'Incident Management',
    SCM: 'Service Continuity Management',
    RM: 'Risk Management',
    EDM: 'External Dependencies Management',
    TA: 'Training and Awareness',
    SA: 'Situational Awareness'
  };

  commentsList = [];
  markedForReviewList = [];

  constructor(
  public analysisSvc: ReportAnalysisService,
  public reportSvc: ReportService,
  public configSvc: ConfigService,
  private titleService: Title,
  private crrSvc: CrrService
  ){}

  ngOnInit(): void {
    this.loading = true;
    this.titleService.setTitle("Comments Report - CISA CRR");

    let appCode = this.configSvc.installationMode;
    if (!appCode || appCode === 'CSET') {
      this.logoPath = "assets/images/CISA_Logo_1831px.png";
    }
    else if (appCode === 'CSET-TSA') {
      this.logoPath = "assets/images/TSA/tsa_insignia_rgbtransparent.png";
    }

    this.crrSvc.getCrrModel().subscribe(
      (r: CrrReportModel) => {
        this.crrModel = r;
        console.log(this.crrModel);

        // Build up comments list
        this.crrModel.reportData.comments.forEach(matAns => {
          const domain = matAns.mat.question_Title.split(':')[0];
          const cElement = this.commentsList.find(e => e.cat === this.keyToCategory[domain]);

          if (!cElement) {
            this.commentsList.push({ cat: this.keyToCategory[domain], matAnswers: [matAns] });
          } else {
            cElement.matAnswers.push(matAns);
          }
        });

        // Sort the marked for review list
        this.commentsList.forEach(e => {
          e.matAnswers.sort((a, b) => {
            return a.mat.question_Title.localeCompare(b.mat.question_Title);
          })
          e.matAnswers.sort((a, b) => {
            return a.mat.question_Text.localeCompare(b.mat.question_Text);
          })
        });

        // mark questions followed by a child for border display
        this.commentsList.forEach(e => {
          for (let i = 0; i < e.matAnswers.length; i++) {
            if (e.matAnswers[i + 1]?.mat.parent_Question_Id != null) {
              e.matAnswers[i].isFollowedByChild = true;
            }
          }
        });

        // Build up marked for review list
        this.crrModel.reportData.markedForReviewList.forEach(matAns => {
          const domain = matAns.mat.question_Title.split(':')[0];
          const mfrElement = this.markedForReviewList.find(e => e.cat === this.keyToCategory[domain]);

          if (!mfrElement) {
            this.markedForReviewList.push({ cat: this.keyToCategory[domain], matAnswers: [matAns] });
          } else {
            mfrElement.matAnswers.push(matAns);
          }
        });

        // Sort the marked for review list
        this.markedForReviewList.forEach(e => {
          e.matAnswers.sort((a, b) => {
            return a.mat.question_Title.localeCompare(b.mat.question_Title);
          })
          e.matAnswers.sort((a, b) => {
            return a.mat.question_Text.localeCompare(b.mat.question_Text);
          })
        });

        // mark questions followed by a child for border display
        this.markedForReviewList.forEach(e => {
          for (let i = 0; i < e.matAnswers.length; i++) {
            if (e.matAnswers[i + 1]?.mat.parent_Question_Id != null) {
              e.matAnswers[i].isFollowedByChild = true;
            }
          }
        });

        console.log(this.markedForReviewList);
        this.loading = false;
      },
      error => console.log('Comments Marked Report Error: ' + (<Error>error).message)
    );
  }

  getFullAnswerText(abb: string) {
    return this.configSvc.config['answerLabel' + abb];
  }
}
