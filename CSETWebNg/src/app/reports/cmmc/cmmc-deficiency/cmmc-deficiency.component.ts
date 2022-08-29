import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { CrrReportModel } from '../../../models/reports.model';
import { ConfigService } from '../../../services/config.service';
import { CrrService } from '../../../services/crr.service';
import { MaturityService } from '../../../services/maturity.service';
import { ReportAnalysisService } from '../../../services/report-analysis.service';
import { ReportService } from '../../../services/report.service';

@Component({
  selector: 'app-cmmc-deficiency',
  templateUrl: './cmmc-deficiency.component.html',
  styleUrls: ['./../../crr/crr-report/crr-report.component.scss']
})
export class CmmcDeficiencyComponent implements OnInit {

  model: any;
  loading: boolean = false;
  logoPath: string = '';
  keyToCategory: any;

  deficienciesList = [];

  constructor(
  public configSvc: ConfigService,
  private titleService: Title,
  private maturitySvc: MaturityService
  ){}

  ngOnInit() {
    this.loading = true;
    this.keyToCategory = this.maturitySvc.keyToCategory;
    this.titleService.setTitle("CMMC Deficiency Report - CSET");
    let appCode = this.configSvc.installationMode;

    if (!appCode || appCode === 'CSET') {
      this.logoPath = "assets/images/CISA_Logo_1831px.png";
    }
    else if (appCode === 'CSET-TSA') {
      this.logoPath = "assets/images/TSA/tsa_insignia_rgbtransparent.png";
    }

    this.maturitySvc.getCmmcReportData().subscribe(
      (r: any) => {
        this.model = r;
        console.log(this.model);

        // Build up deficiencies list
        this.model.reportData.deficienciesList.forEach(matAns => {
          const domain = matAns.mat.question_Title.split('.')[0];
          const dElement = this.deficienciesList.find(e => e.cat === this.keyToCategory[domain]);
          if (!dElement) {
            this.deficienciesList.push({ cat: this.keyToCategory[domain], matAnswers: [matAns] });
          } else {
            dElement.matAnswers.push(matAns);
          }
        });

        // Sort the list
        this.deficienciesList.forEach(e => {
          e.matAnswers.sort((a, b) => {
            return a.mat.question_Title.split('-')[0].localeCompare(b.mat.question_Title.split('-')[0]) || a.mat.question_Text.localeCompare(b.mat.question_Text);;
          });
        });

        // mark questions followed by a child for border display
        this.deficienciesList.forEach(e => {
          for (let i = 0; i < e.matAnswers.length; i++) {
            if (e.matAnswers[i + 1]?.mat.parent_Question_Id != null) {
              e.matAnswers[i].isFollowedByChild = true;
            }
          }
        });

        this.loading = false;
      },
      error => console.log('CRR Deficiency Report Error: ' + (<Error>error).message)
    );
  }

  getFullAnswerText(abb: string) {
    return this.configSvc.config['answerLabel' + abb];
  }

  printReport() {
    window.print();
  }
}
