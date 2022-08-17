import { Component, Input, OnInit } from '@angular/core';
import { ConfigService } from './../../../../services/config.service';
import { CrrReportModel } from '../../../../models/reports.model';

@Component({
  selector: 'app-crr-cover-sheet',
  templateUrl: './crr-cover-sheet.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrCoverSheetComponent implements OnInit {

  @Input() model: CrrReportModel;

  headerUrl: string;
  bannerUrl: string = 'assets/images/CRR/report-header.jpg';

  constructor(private configSvc: ConfigService) { }

  ngOnInit(): void {
    if (this.configSvc.installationMode === 'TSA') {
      this.headerUrl = 'assets/images/TSA/tsa_insignia_rgbtransparent.png';
    } else {
      this.headerUrl = 'assets/images/CISA_Logo_1831px.png'
    }
  }

}
