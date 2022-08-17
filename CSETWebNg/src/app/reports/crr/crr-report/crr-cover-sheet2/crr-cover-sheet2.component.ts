import { Component, Input, OnInit } from '@angular/core';
import { ConfigService } from '../../../../services/config.service';
import { CrrReportModel } from '../../../../models/reports.model';

@Component({
  selector: 'app-crr-cover-sheet2',
  templateUrl: './crr-cover-sheet2.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrCoverSheet2Component implements OnInit {

  @Input() model: CrrReportModel;

  logoUrl: string;

  constructor(private configSvc: ConfigService) { }

  ngOnInit(): void {
    if (this.configSvc.installationMode === 'TSA') {
      this.logoUrl = 'assets/images/TSA/tsa_insignia_rgbtransparent.png';
    } else {
      this.logoUrl = 'assets/images/CISA_Logo_1831px.png'
    }
  }

}
