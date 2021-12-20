import { Component, OnInit } from '@angular/core';
import { ConfigService } from '../../../../services/config.service';

@Component({
  selector: 'app-tutorial-cmmc2',
  templateUrl: './tutorial-cmmc2.component.html'
})
export class TutorialCmmc2Component implements OnInit {

  constructor(public configSvc: ConfigService) { }

  ngOnInit(): void {
  }

  documentURL(documentName: string) {
    return this.configSvc.docUrl + documentName;
  }
}
