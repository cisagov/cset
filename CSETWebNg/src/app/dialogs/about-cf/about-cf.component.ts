import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { environment } from '../../../environments/environment';
import { ConfigService } from '../../services/config.service';

@Component({
  selector: 'app-about-cf',
  templateUrl: './about-cf.component.html',
  styleUrls: ['./about-cf.component.scss']
})
export class AboutCfComponent implements OnInit {

  constructor(private dialog: MatDialogRef<AboutCfComponent>,
    public configSvc: ConfigService,
    @Inject(MAT_DIALOG_DATA) public data: any) { }


    linkerTime: string = null;
      /**
       * 
       */
      ngOnInit() {
        if (this.configSvc.config.debug.showBuildTime ?? false) {
          this.linkerTime = localStorage.getItem('cset.linkerDate');
        }
        
      }
    version = environment.visibleVersion;
    helpContactEmail = this.configSvc.helpContactEmail;
    helpContactPhone = this.configSvc.helpContactPhone;

    close() {
      return this.dialog.close();
    }
  
  }