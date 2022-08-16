import { ConfigService } from './../../../../services/config.service';
import { Component, OnInit } from '@angular/core';
import { LayoutService } from '../../../../services/layout.service';


@Component({
  selector: 'app-tutorial-cmmc',
  templateUrl: './tutorial-cmmc.component.html',
  styleUrls: ['./tutorial-cmmc.component.scss']
})
export class TutorialCmmcComponent implements OnInit {


  constructor(
    public configSvc: ConfigService,
    public layoutSvc: LayoutService
    ) { }

  documentURL(documentName: string) {
    return this.configSvc.docUrl + documentName;
  }

  ngOnInit(): void {
  }

}
