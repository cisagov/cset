import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { ConfigService } from '../../../services/config.service';
import { MaturityService } from '../../../services/maturity.service';

@Component({
  selector: 'app-cmmc-alt-justifications',
  templateUrl: './cmmc-alt-justifications.component.html',
  styleUrls: ['./../../crr/crr-report/crr-report.component.scss']
})
export class CmmcAltJustificationsComponent implements OnInit {

  model: any;
  loading: boolean = false;
  logoPath: string = '';
  keyToCategory: any;

  altJustList = [];

  constructor(
  public configSvc: ConfigService,
  private titleService: Title,
  private maturitySvc: MaturityService
  ){}

  ngOnInit() {
    this.loading = true;
    this.keyToCategory = this.maturitySvc.keyToCategory;
    this.titleService.setTitle("CMMC Alternate Justifications - CSET");
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

        // Build up alternate justifications list
        this.model.reportData.alternateList.forEach(matAns => {
          const domain = matAns.mat.question_Title.split('.')[0];
          console.log(domain);
          const aElement = this.altJustList.find(e => e.cat === this.keyToCategory[domain]);
          if (!aElement) {
            this.altJustList.push({ cat: this.keyToCategory[domain], matAnswers: [matAns] });
          } else {
            aElement.matAnswers.push(matAns);
          }
        });

        // mark questions followed by a child for border display
        this.altJustList.forEach(e => {
          for (let i = 0; i < e.matAnswers.length; i++) {
            e.matAnswers[i].showAlt = true;
            if (e.matAnswers[i + 1]?.mat.parent_Question_Id != null) {
              e.matAnswers[i].isFollowedByChild = true;
            }
          }
        });

        this.loading = false;
      },
      error => console.log('CMMC Alternate Justifications Report Error: ' + (<Error>error).message)
    );
  }

  getFullAnswerText(abb: string) {
    return this.configSvc.config['answerLabel' + abb];
  }

  printReport() {
    window.print();
  }
}
