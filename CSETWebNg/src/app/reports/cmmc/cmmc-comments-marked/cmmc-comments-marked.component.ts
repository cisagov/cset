import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { ConfigService } from '../../../services/config.service';
import { MaturityService } from '../../../services/maturity.service';
import { QuestionsService } from '../../../services/questions.service';

@Component({
  selector: 'app-cmmc-comments-marked',
  templateUrl: './cmmc-comments-marked.component.html',
  styleUrls: ['./../../crr/crr-report/crr-report.component.scss']
})
export class CmmcCommentsMarkedComponent implements OnInit {

  model: any;
  loading: boolean = false;
  logoPath: string = '';
  keyToCategory: any;

  commentsList = [];
  markedForReviewList = [];

  constructor(
  public configSvc: ConfigService,
  private titleService: Title,
  private maturitySvc: MaturityService,
  public questionsSvc: QuestionsService
  ){}

  ngOnInit() {
    this.loading = true;
    this.keyToCategory = this.maturitySvc.keyToCategory;
    this.titleService.setTitle("CMMC Comments and Marked for Review - CSET");
    let appCode = this.configSvc.installationMode;

    if (!appCode || appCode === 'CSET') {
      this.logoPath = "assets/images/CISA_Logo_1831px.png";
    }
    else if (appCode === 'TSA') {
      this.logoPath = "assets/images/TSA/tsa_insignia_rgbtransparent.png";
    }

    this.maturitySvc.getCmmcReportData().subscribe(
      (r: any) => {
        this.model = r;
        console.log(r)

        // Build up comments list
        this.model.reportData.comments.forEach(matAns => {
          const domain = matAns.mat.question_Title.split('.')[0];
          console.log(domain);
          const cElement = this.commentsList.find(e => e.cat === this.keyToCategory[domain]);
          if (!cElement) {
            this.commentsList.push({ cat: this.keyToCategory[domain], matAnswers: [matAns] });
          } else {
            cElement.matAnswers.push(matAns);
          }
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
        this.model.reportData.markedForReviewList.forEach(matAns => {
          const domain = matAns.mat.question_Title.split('.')[0];
          const mfrElement = this.markedForReviewList.find(e => e.cat === this.keyToCategory[domain]);

          if (!mfrElement) {
            this.markedForReviewList.push({ cat: this.keyToCategory[domain], matAnswers: [matAns] });
          } else {
            mfrElement.matAnswers.push(matAns);
          }
        });


        // mark questions followed by a child for border display
        this.markedForReviewList.forEach(e => {
          for (let i = 0; i < e.matAnswers.length; i++) {
            if (e.matAnswers[i + 1]?.mat.parent_Question_Id != null) {
              e.matAnswers[i].isFollowedByChild = true;
            }
          }
        });

        this.loading = false;
      },
      error => console.log('CMMC Comments and Marked for Review Report Error: ' + (<Error>error).message)
    );
  }

  getFullAnswerText(abb: string) {
    return this.questionsSvc.getAnswerDisplayLabel(4, abb);
  }

  printReport() {
    window.print();
  }
}
