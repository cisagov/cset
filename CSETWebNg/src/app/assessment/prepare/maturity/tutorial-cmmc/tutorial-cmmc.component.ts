import { ConfigService } from './../../../../services/config.service';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-tutorial-cmmc',
  templateUrl: './tutorial-cmmc.component.html',
  styleUrls: ['./tutorial-cmmc.component.scss']
})
export class TutorialCmmcComponent implements OnInit {

  constructor(public configSvc: ConfigService) { }

  documentURL(documentName: string) {
    return this.configSvc.apiUrl + "ReferenceDocuments/" + documentName;
  }

  ngOnInit(): void {
  }

}
