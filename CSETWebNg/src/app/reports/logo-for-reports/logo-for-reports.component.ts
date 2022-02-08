import { Component, OnInit } from '@angular/core';
import { ConfigService } from '../../services/config.service';

@Component({
  selector: 'app-logo-for-reports',
  templateUrl: './logo-for-reports.component.html',
  styleUrls: ['./logo-for-reports.component.scss']
})
export class LogoForReportsComponent implements OnInit {
  sourceImage: string;
  LogoAlt:string;
  constructor(
    public configSvc: ConfigService
  ) { }

  ngOnInit(): void {
    if (this.configSvc.installationMode=='TSA'){
      this.sourceImage='assets/images/TSA/tsa_insignia_rgbtransparent.png';
      this.LogoAlt="TSA Logo";
    }else if (this.configSvc.installationMode=='CYOTE'){
      this.sourceImage='assets/images/CYOTE/cyotelogo.png';
      this.LogoAlt="Cyote Logo";
    }
    else if (this.configSvc.installationMode=='ACET'){
      this.sourceImage='assets/images/ACET/ACET_shield_only.png';
      this.LogoAlt="ACET Logo";
    }
    else {
      this.sourceImage='assets/images/CISA_Logo_183px.png';
      this.LogoAlt="CISA Logo";
    }
  }

}
